// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        // 当前歌曲播放完毕
        isPlaying.value = false;
      }
    });
  }

  Future<void> playSong(int id) async {
    if (currentSongId.value == id) {
      // 如果点击的是同一首歌就播放，后面逻辑不执行
      play();
      return;
    }
    try {
      isLoading.value = true;
      await _checkSong(id);
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
  Future<void> _checkSong(int id) async {
    final res = await SongRepository.checkSong(id);
    isAvailable.value = res;
  }

  // 获取歌曲URL
  Future<void> _getSongUrl(int id) async {
    final res = await SongRepository.getSongUrl(id, level: 'higher');
    songUrl.value = res as String?;
    if (songUrl.value != null) {
      await _audioPlayer.setUrl(songUrl.value!);
      play();
    }
  }

  // 播放歌曲
  Future<void> play() async {
    if (isCompleted) {
      // 如果当前歌曲播放完毕，则从头开始播放
      _audioPlayer.seek(Duration(milliseconds: 0));
    } else {
      await _audioPlayer.play();
      isPlaying.value = true;
    }
  }

  // 暂停歌曲
  Future<void> pause() async {
    await _audioPlayer.pause();
    isPlaying.value = false;
  }

  // 跳转歌曲进度条
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
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
  }); // 歌曲总时长
}
