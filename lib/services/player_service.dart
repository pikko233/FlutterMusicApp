// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  LoopMode _loopMode = LoopMode.all; // 当前歌曲播放循环模式
  final loopModeIcon = Rxn<IconData>(Icons.repeat); // 循环模式icon
  final Map<LoopMode, IconData> _loopModeIconMap = {
    LoopMode.off: Icons.sync_alt,
    LoopMode.one: Icons.repeat_one,
    LoopMode.all: Icons.repeat,
  };

  int _skipCount = 0; // 记录因为无版权而跳到下一首歌的次数，如果跳过次数大于等于playlist长度，则停止播放

  final playlist = <SongModel>[].obs; // 当前播放列表, 列表api不返回音频资源url字段

  late final AnimationController rotationController; // 歌曲封面图片旋转动画控制

  late final Worker _songIdWorker;

  // 当前播放歌曲位于播放列表中的索引
  int get currentIndex => playlist.isEmpty
      ? 0
      : playlist.indexWhere((item) => item.id == currentSongId.value);

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
    _audioPlayer.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {
        if (_loopMode == LoopMode.off) {
          // 播完暂停
          // 如果当前是列表的最后一首，则暂停
          if (currentIndex == playlist.length - 1) return;
          // 否则继续播放下一首
          next();
        } else if (_loopMode == LoopMode.one) {
          // 单曲循环
          await seek(Duration.zero);
          play();
        } else if (_loopMode == LoopMode.all) {
          // 循环播放
          next();
        }
      }
    });

    // 监听当前歌曲ID是否发生变化，如果变化则调整播放列表，保证当前歌曲始终在列表第一位
    _songIdWorker = ever(currentSongId, (_) {
      // 如果当前循环模式为播完暂停，那么就不改变播放列表playlist
      if (_loopMode == LoopMode.off) return;

      print('当前播放歌曲ID发生变化: ${currentSongId.value}');
      // 每次当前播放歌曲改变，都将当前歌曲改为播放列表第一位，前面的歌曲则整体移至列表最后
      final newList = [
        ...playlist.sublist(currentIndex),
        ...playlist.sublist(0, currentIndex),
      ];
      playlist.assignAll(newList);
    });
  }

  @override
  void onClose() {
    rotationController.dispose();
    _songIdWorker.dispose();
    _audioPlayer.dispose();
    super.onClose();
  }

  // 点击列表中的某一首歌
  Future<void> playSong(
    int id,
    List<SongModel> list, {
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
      playlist.value = [...list];
      currentSongId.value = id;
      await _getSongDetail(id); // 获取歌曲信息
      await _getSongUrl(id); // 获取歌曲音频资源url
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
  Future<void> play() async {
    if (isCompleted) {
      // 当前歌曲播放完毕
      // 判断循环模式
      if (_loopMode == LoopMode.one) {
        // 如果是单曲循环，则从头开始播放
        await seek(Duration.zero);
        _audioPlayer.play();
      } else {
        // 如果是循环播放或者播完暂停，则直接播放下一首歌
        next();
      }
    } else {
      // 当前歌曲未播放完毕
      _audioPlayer.play();
    }
  }

  // 暂停歌曲
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  // 跳转歌曲进度条
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // 切换歌曲循环模式
  void toggleLoopMode() {
    final modes = [LoopMode.off, LoopMode.one, LoopMode.all];
    final currentModeIndex = modes.indexOf(_loopMode);
    final nextIndex = (currentModeIndex + 1) % modes.length;
    _loopMode = modes[nextIndex];
    loopModeIcon.value = _loopModeIconMap[_loopMode];
  }

  // 播放指定索引的歌曲
  Future<void> playAt(int index) async {
    try {
      isLoading.value = true;
      final id = playlist[index].id;
      isAvailable.value = await checkSong(id); // 检查当前点击的歌曲是否有版权
      if (!isAvailable.value) {
        // 没有版权就跳过这首，然后播放下一首
        _skipNext(index);
        return;
      }
      currentSongId.value = id;
      await _getSongDetail(id);
      await _getSongUrl(id);
      _skipCount = 0; // 播放成功时归零
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _skipNext(int index) {
    _skipCount++;
    if (_skipCount >= playlist.length) {
      // 播放失败跳过的次数大于等于播放列表长度
      print('播放列表所有歌曲都无版权，停止播放');
      return;
    }
    final nextIndex = (index + 1) % playlist.length;
    playAt(nextIndex);
  }

  // 播放下一首
  void next() {
    final nextIndex = (currentIndex + 1) % playlist.length;
    playAt(nextIndex);
  }

  // 播放上一首
  void previous() {
    final previousIndex =
        (currentIndex - 1 + playlist.length) % playlist.length;
    playAt(previousIndex);
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
