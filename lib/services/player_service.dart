// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:get/get.dart' hide Rx;

import 'package:flutter_music_app/repositories/song_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class PlayerService extends GetxController {
  late AudioPlayer _audioPlayer;

  final isLoading = false.obs;
  final isAvailable = false.obs; // 音乐是否可用（是否有版权）
  final song = Rxn<SongModel>(); // 歌曲信息，如歌曲名称、歌手、歌曲封面图片等等
  final songUrl = RxnString(); // 歌曲音频资源URL
  final isPlaying = false.obs; // 当前歌曲是否在播放
  final currentSongId = RxnInt(); // 当前歌曲ID

  late AnimationController rotationController; // 歌曲封面图片旋转动画控制

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  bool get isCompleted =>
      _audioPlayer.processingState == ProcessingState.completed;

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position: position,
          bufferedPosition: bufferedPosition,
          duration: duration ?? Duration.zero,
        ),
      );

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer(); // 实例化播放器
    rotationController = AnimationController(
      // vsync: this,
      vsync: _StandaloneTickerProvider(),
      duration: Duration(seconds: 30),
    )..repeat(); // 实例化旋转动画控制器
    rotationController.stop();
    _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value =
          state.playing && state.processingState != ProcessingState.completed;
      if (isPlaying.value) {
        rotationController.repeat();
      } else {
        rotationController.stop();
      }
    });
  }

  @override
  void onClose() {
    rotationController.dispose();
    super.onClose();
  }

  Future<void> playSong(int id, {bool needPlay = true}) async {
    if (currentSongId.value == id) {
      // 如果点击的是同一首歌，后面逻辑不执行
      if (needPlay) {
        // 从歌单列表点击来就播放，从miniplayer迷你播放器点进来不自动播放
        play();
      }
      return;
    }
    try {
      isLoading.value = true;
      isAvailable.value = await checkSong(id);
      if (!isAvailable.value) return;
      currentSongId.value = id;
      await _getSongDetail(id);
      await _getSongUrl(id);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 获取歌曲信息
  Future<void> _getSongDetail(int id) async {
    final res = await SongRepository.getSongDetail(id);
    song.value = res;
  }

  // 检查歌曲是否有版权
  Future<bool> checkSong(int id) async {
    final res = await SongRepository.checkSong(id);
    return res;
  }

  // 获取歌曲URL
  Future<void> _getSongUrl(int id) async {
    final res = await SongRepository.getSongUrl(id, level: 'higher');
    songUrl.value = res as String?;
    await _audioPlayer.setUrl(songUrl.value!);
    play();
  }

  // 播放歌曲
  void play() {
    if (isCompleted) {
      // 如果当前歌曲播放完毕，则从头开始播放
      _audioPlayer.seek(Duration(milliseconds: 0));
    }
    // ps
    // audioPlayer.play()不能放await，否则这个方法会阻塞到播放结束
    // 暂停倒是加不加await都无所谓 - 被这里的bug搞了好久，真是血的教训
    // pps
    // 直接监听playerStateStream就行了，不要手动管理isPlaying状态
    _audioPlayer.play();
  }

  // 暂停歌曲
  void pause() {
    _audioPlayer.pause();
  }

  // 跳转歌曲进度条
  void seek(Duration position) {
    _audioPlayer.seek(position);
  }
}

class PositionData {
  final Duration position; // 当前播放位置
  final Duration bufferedPosition; // 已缓冲的进度
  final Duration duration; // 歌曲总时长

  PositionData({
    required this.position,
    required this.bufferedPosition,
    required this.duration,
  });
}

// PlayerService继承自GetxController, 不是TickerProvider, 不能用vsync: this, 需要定义一个独立的TickerProvider
class _StandaloneTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
