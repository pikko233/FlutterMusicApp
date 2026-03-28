// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:get/get.dart' hide Rx;

import 'package:flutter_music_app/repositories/song_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class PlayerService extends GetxController {
  late AudioPlayer _audioPlayer;

  final isLoading = false.obs; // 是否发送请求加载中
  final isAvailable = false.obs; // 音乐是否可用（是否有版权）
  final song = Rxn<SongModel>(); // 歌曲信息，如歌曲名称、歌手、歌曲封面图片等等
  final songUrl = RxnString(); // 歌曲音频资源URL
  final isPlaying = false.obs; // 当前歌曲是否在播放
  final currentSongId = RxnInt(); // 当前歌曲ID
  final currentIndex = 0.obs; // 当前播放歌曲位于播放列表中的索引
  final playlist = <dynamic>[].obs; // 当前播放列表, 列表api不返回音频资源url字段
  final loopMode = LoopMode.all.obs; // 当前循环模式

  late AnimationController rotationController; // 歌曲封面图片旋转动画控制

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  // 判断当前歌曲是否播放完毕
  bool get isCompleted =>
      _audioPlayer.processingState == ProcessingState.completed;

  // 合并三个数据流 - 播放进度、缓冲进度、歌曲总时长 三个Duration
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

    // 实例化播放器
    _audioPlayer = AudioPlayer();

    // 实例化旋转动画控制器
    rotationController = AnimationController(
      // vsync: this,
      vsync: _StandaloneTickerProvider(),
      duration: Duration(seconds: 30),
    );

    // 监听播放状态流，判断当前是否在播放歌曲
    _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value =
          state.playing && state.processingState != ProcessingState.completed;
      if (isPlaying.value) {
        // 如果歌曲播放中，则旋转歌曲封面图片
        rotationController.repeat();
      } else {
        // 如果歌曲暂停中，则停止旋转
        rotationController.stop();
      }
    });

    // 监听当前播放进度
    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        // 播放完毕则自动播放下一首
        next();
      }
    });

    // 监听当前歌曲循环模式
    _audioPlayer.loopModeStream.listen((mode) {
      loopMode.value = mode;
    });
  }

  @override
  void onClose() {
    rotationController.dispose();
    super.onClose();
  }

  // 点击列表中的某一首歌
  Future<void> playSong(
    int id,
    List<dynamic> list, {
    bool needPlay = true,
  }) async {
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
      isAvailable.value = await checkSong(id); // 检查当前点击的歌曲是否有版权
      if (!isAvailable.value) return; // 没有版权就返回
      currentSongId.value = id;
      await _getSongDetail(id); // 获取歌曲信息
      await _getSongUrl(id); // 获取歌曲音频资源url
      playlist.value = list;
      print("播放列表: $playlist");
      currentIndex.value = list.indexWhere((item) => item.id == id);
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
      // _audioPlayer.seek(Duration(milliseconds: 0));
      // 如果当前歌曲播放完毕，则自动播放下一首
      next();
    } else {
      _audioPlayer.play();
    }
  }

  // 暂停歌曲
  void pause() {
    _audioPlayer.pause();
  }

  // 跳转歌曲进度条
  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  // 切换歌曲循环模式
  void toggleLoopMode() {
    final modes = [LoopMode.off, LoopMode.one, LoopMode.all];
    final currentIndex = modes.indexOf(_audioPlayer.loopMode);
    final nextIndex = (currentIndex + 1) % modes.length;
    _audioPlayer.setLoopMode(modes[nextIndex]);
  }

  // 播放指定索引的歌曲
  Future<void> playAt(int index) async {
    print(playlist[index]);
    final id = playlist[index].id;
    isAvailable.value = await checkSong(id); // 检查当前点击的歌曲是否有版权
    if (!isAvailable.value) {
      // 没有版权就播放下一首
      next();
      return;
    }
    currentSongId.value = id;
    await _getSongDetail(id);
    await _getSongUrl(id);
  }

  // 播放下一首
  void next() {
    currentIndex.value = currentIndex.value == playlist.length - 1
        ? 0
        : currentIndex.value + 1;
    playAt(currentIndex.value);
  }

  // 播放上一首
  void previous() {
    currentIndex.value = currentIndex.value == 0
        ? playlist.length - 1
        : currentIndex.value - 1;
    playAt(currentIndex.value);
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
