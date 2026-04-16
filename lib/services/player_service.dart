// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_lyric/flutter_lyric.dart';
import 'package:flutter_music_app/models/artist_detail_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/repositories/artist_repository.dart';
import 'package:flutter_music_app/utils/toast_util.dart';
import 'package:get/get.dart' hide Rx;

import 'package:flutter_music_app/repositories/song_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class PlayerService extends GetxController {
  late AudioPlayer _audioPlayer;
  late final AnimationController rotationController; // 歌曲封面图片旋转动画控制
  late final LyricController lyricController; // 歌词控制器

  final isLoading = false.obs; // 是否发送请求加载中
  final isAvailable = false.obs; // 音乐是否可用（是否有版权）
  final song = Rxn<SongModel>(); // 歌曲信息，如歌曲名称、歌手、歌曲封面图片等等
  final songUrl = RxnString(); // 歌曲音频资源URL
  final isPlaying = false.obs; // 当前歌曲是否在播放
  final currentSongId = RxnInt(); // 当前歌曲ID
  Future<List<SongModel>> Function(int offset)?
  _loadMoreCallback; // 加载更多歌曲的回调，不同来源（歌单/搜索）传入不同实现
  final playlist =
      <SongModel>[].obs; // 当前播放列表（分页加载，可能不包含所有歌）, 列表api不返回音频资源url字段
  final songTotalCount = 0.obs; // 播放列表歌曲总数（包含所有分页）
  LoopMode _loopMode = LoopMode.all; // 当前歌曲播放循环模式
  final loopModeIcon = Rxn<IconData>(Icons.repeat); // 循环模式icon
  final Map<LoopMode, IconData> _loopModeIconMap = {
    LoopMode.off: Icons.sync_alt,
    LoopMode.one: Icons.repeat_one,
    LoopMode.all: Icons.repeat,
  };
  final Map<LoopMode, String> _loopToastMap = {
    LoopMode.off: '播完暂停',
    LoopMode.one: '单曲循环',
    LoopMode.all: '循环播放',
  };
  final volumn = 1.0.obs; // 播放器音量（非系统音量，ios不允许app直接修改系统音量）
  final artists =
      <ArtistDetailModel>[].obs; // 当前歌曲有多位歌手的时候，需要批量请求，获取每位歌手的头像以及当前用户是否关注的字段

  bool get hasMore => playlist.length < songTotalCount.value;

  int _skipCount = 0; // 记录因为无版权而跳到下一首歌的次数，如果跳过次数大于等于playlist长度，则停止播放

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

    // 实例化歌词控制器
    lyricController = LyricController();

    ever(song, (_) {
      rotationController.reset(); // 归零
      if (isPlaying.value) {
        rotationController.repeat(); // 开始旋转
      }

      // 判断当前歌曲是否是播放列表最后几首，触发加载下一页
      if (hasMore && currentIndex >= playlist.length - 3) {
        loadMore();
      }
    });

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

    // 监听歌曲播放进度 - 驱动歌词滚动
    _audioPlayer.positionStream.listen(lyricController.setProgress);
  }

  @override
  void onClose() {
    rotationController.dispose();
    lyricController.dispose();
    _audioPlayer.dispose();
    super.onClose();
  }

  // 点击列表中的某一首歌
  Future<void> playSong(
    int id,
    List<SongModel> list,
    int total,
    Future<List<SongModel>> Function(int offset)? loadMore, {
    bool needPlay = true,
  }) async {
    try {
      isLoading.value = true;
      isAvailable.value = await checkSong(id); // 检查当前点击的歌曲是否有版权
      if (!isAvailable.value) return; // 没有版权就返回
      if (currentSongId.value == id && listEquals(playlist, list)) {
        if (needPlay) {
          // 从歌单列表点击来就播放，从miniplayer迷你播放器点进来不自动播放
          play();
        }
        // 如果点击的是同一首歌，后面逻辑不执行
        return;
      }
      playlist.value = [...list];
      songTotalCount.value = total;
      _loadMoreCallback = loadMore;
      currentSongId.value = id;
      await _getSongDetail(id); // 获取歌曲信息
      await _getSongUrl(id); // 获取歌曲音频资源url
      await _getSongLyric(id); // 获取歌曲歌词
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 加载下一页歌曲列表
  Future<void> loadMore() async {
    if (playlist.length >= songTotalCount.value) return;
    if (_loadMoreCallback == null) return;
    try {
      isLoading.value = true;
      final res = await _loadMoreCallback!(playlist.length);
      // 搜索歌曲api 一共309首歌，但是最后一次请求limit=30&offset=300 又给我返回30首而不是9首，309首变330首
      // 不知道网易怎么写的api，只能在这里截取一下
      final remaining = songTotalCount.value - playlist.length;
      playlist.addAll(res.take(remaining));
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 获取歌曲信息
  Future<void> _getSongDetail(int id) async {
    final res = await SongRepository.getSongDetail(id);
    // 用详情接口返回的专辑封面更新 playlist 对应项（type=1 搜索结果无 picUrl）
    final index = playlist.indexWhere((s) => s.id == id);
    if (index != -1 && res.al.picUrl.isNotEmpty) {
      playlist[index] = playlist[index].copyWith(al: res.al);
    }
    song.value = res;
    final ids = song.value!.ar.map((e) => e.id).toList();
    _getArtistsDetail(ids);
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
    // await _audioPlayer.setUrl(songUrl.value!);
    await _audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(songUrl.value!),
        tag: MediaItem(
          id: currentSongId.value.toString(),
          title: song.value!.name,
          artist: song.value!.artistsName,
          artUri: Uri.parse(song.value!.picUrl),
        ),
      ),
      preload: true,
    );
    play();
  }

  // 获取歌曲逐字歌词
  Future<void> _getSongLyric(int id) async {
    final res = await SongRepository.getSongLyric(id);
    final lyric = _filterEmptyLines(
      res['lrc']['lyric'] as String,
      fallback: '[00:00.000]该歌曲暂无歌词',
    );
    final tlyric = _filterEmptyLines(res['tlyric']?['lyric'] as String?);
    lyricController.loadLyric(lyric, translationLyric: tlyric);
  }

  // 过滤歌词为空的字符串行
  String _filterEmptyLines(String? lrc, {String fallback = ''}) {
    if (lrc == null || lrc.trim().isEmpty) return fallback;
    final timestampReg = RegExp(r'\[\d{2}:\d{2}\.\d+\]');
    final lines = lrc.split('\n').where((line) {
      // 必须包含至少一个时间戳
      if (!timestampReg.hasMatch(line)) return false;
      // 去掉所有时间戳后，剩余文本必须非空
      final text = line.replaceAll(timestampReg, '').trim();
      return text.isNotEmpty;
    }).toList();
    if (lines.isEmpty) return fallback;
    return lines.join('\n');
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
  void toggleLoopMode({BuildContext? context}) {
    final modes = [LoopMode.off, LoopMode.one, LoopMode.all];
    final currentModeIndex = modes.indexOf(_loopMode);
    final nextIndex = (currentModeIndex + 1) % modes.length;
    _loopMode = modes[nextIndex];
    loopModeIcon.value = _loopModeIconMap[_loopMode];
    if (context != null) {
      ToastUtil.showToast(_loopToastMap[_loopMode]!);
    }
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
      await _getSongLyric(id); // 获取歌曲歌词
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
    if (playlist.isEmpty) return;
    final nextIndex = (currentIndex + 1) % playlist.length;
    playAt(nextIndex);
  }

  // 播放上一首
  void previous() {
    if (playlist.isEmpty) return;
    final previousIndex =
        (currentIndex - 1 + playlist.length) % playlist.length;
    playAt(previousIndex);
  }

  // 添加至下一首播放
  void addToNextPlay(SongModel song) {
    // 先判断添加的歌曲是否已经在当前播放列表中
    final index = playlist.indexWhere((item) => item.id == song.id);

    // 如果已经在播放列表中
    if (index != -1) {
      // 如果是当前播放歌曲，则返回，不做任何操作
      if (index == currentIndex) return;
      // 从播放列表中移除
      playlist.removeAt(index);
    }

    // 插入到当前播放歌曲索引的下一位
    playlist.insert(currentIndex + 1, song);
    ToastUtil.showToast('添加成功');
  }

  // 从播放列表中移除
  void removeFromPlaylist(int songId) {
    final index = playlist.indexWhere((item) => item.id == songId);
    if (index != -1) {
      ToastUtil.showToast('播放列表中不存在这首歌');
      return;
    }
    playlist.removeAt(index);
    ToastUtil.showToast('移除成功');
  }

  // 设置播放器音量
  Future<void> setVolumn(double value) async {
    await _audioPlayer.setVolume(value);
    volumn.value = value;
  }

  // 批量获取歌手的信息
  Future<void> _getArtistsDetail(List<int> ids) async {
    final results = await Future.wait(
      ids.map((id) => ArtistRepository.getArtistDetail(id)),
    );
    artists.value = results
        .map(
          (res) => ArtistDetailModel.fromMap(
            res['artist'] as Map<String, dynamic>,
            videoCount: res['videoCount'] as int,
          ),
        )
        .toList();
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
