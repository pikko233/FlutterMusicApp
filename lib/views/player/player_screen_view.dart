import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/widgets/lyric_view.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/constants/app_lyric.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:flutter_music_app/widgets/custom_marquee.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';
import 'package:flutter_music_app/widgets/playlist_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreenView extends StatefulWidget {
  const PlayerScreenView({super.key});

  @override
  State<PlayerScreenView> createState() => _PlayerScreenViewState();
}

class _PlayerScreenViewState extends State<PlayerScreenView> {
  final _player = Get.find<PlayerService>();
  final _carouselController = CarouselSliderController();
  late final Worker _carouselWorker;
  bool _showLyric = false; // 是否显示歌词
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _carouselWorker = ever(_player.song, (_) {
      // song 变化时 UI 已渲染出 CarouselSlider，controller 此时可用
      if (_player.song.value == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final diff = (_player.currentIndex - _currentPage).abs();
        if (diff <= 1 || diff == _player.playlist.length - 1) {
          // 如果点击的歌曲索引相邻，使用动画跳转
          _carouselController.animateToPage(
            _player.currentIndex,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          _carouselController.jumpToPage(_player.currentIndex);
        }
        _currentPage = _player.currentIndex;
      });
    });

    _currentPage = _player.currentIndex;
  }

  @override
  void dispose() {
    _carouselWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return Obx(() {
      if (_player.song.value == null) {
        return Center(child: CircularProgressIndicator());
      }
      final song = _player.song.value!;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.bgAppBar,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary60),
          ),
          title: Text(
            _showLyric ? song.name : "正在播放",
            style: TextStyle(
              color: AppColors.textPrimary60,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_horiz, color: AppColors.textPrimary60),
            ),
          ],
        ),
        body: StreamBuilder<PlayerState>(
          stream: _player.playerStateStream,
          builder: (context, snapshot) {
            final isPlaying = _player.isPlaying.value; // 当前歌曲正在播放 且 未播放完毕
            return Container(
              // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.bgPrimary, AppColors.bgAppBar],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      // 切换歌曲封面图片和歌词的时候添加淡入淡出效果
                      duration: Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: _showLyric
                          ? Column(
                              key: const ValueKey('lyric'),
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      LyricView(
                                        // 歌词
                                        controller: _player.lyricController,
                                        style: AppLyric.playerScreenLyricStyle,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                      Positioned.fill(
                                        // 点击隐藏歌词
                                        child: GestureDetector(
                                          behavior: HitTestBehavior
                                              .translucent, // 透明穿透
                                          onTap: () {
                                            setState(() {
                                              _showLyric = false;
                                            });
                                          },
                                          child: const SizedBox.expand(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              key: const ValueKey('cover'),
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // 点击显示歌词
                                        _showLyric = true;
                                      });
                                    },
                                    onLongPress: () {
                                      // 长按预览封面图
                                      final item =
                                          _player.playlist[_currentPage];
                                      showDialog(
                                        context: context,
                                        barrierColor: Colors.black87,
                                        builder: (ctx) => GestureDetector(
                                          onTap: () => Navigator.pop(ctx),
                                          child: Center(
                                            child: NeteaseImage(
                                              url: item.picUrl,
                                              width: media.width,
                                              height: media.width,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: CarouselSlider.builder(
                                      // 歌曲封面轮播图 - 可左右滑动切换歌曲
                                      carouselController: _carouselController,
                                      itemCount: _player.playlist.length,
                                      itemBuilder:
                                          (context, itemIndex, pageViewIndex) {
                                            final itemSong =
                                                _player.playlist[itemIndex];
                                            return Hero(
                                              tag: 'cover_${itemSong.id}',
                                              child: RotationTransition(
                                                turns:
                                                    _player.rotationController,
                                                child: ClipOval(
                                                  child: NeteaseImage(
                                                    url: itemSong.picUrl,
                                                    width: media.width * 0.6,
                                                    height: media.width * 0.6,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                      options: CarouselOptions(
                                        height: media.width * 0.6,
                                        aspectRatio: 1 / 1,
                                        viewportFraction: 1,
                                        initialPage: _player.currentIndex,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: false,
                                        enlargeCenterPage: true,
                                        enlargeFactor: 0.3,
                                        enlargeStrategy:
                                            CenterPageEnlargeStrategy
                                                .zoom, // 景深效果
                                        scrollDirection: Axis.horizontal,
                                        onPageChanged: (index, reason) {
                                          _currentPage = index;
                                          if (reason ==
                                              CarouselPageChangedReason
                                                  .manual) {
                                            // 只有手动切换轮播图才触发，点击播放上一首/下一首 - 控制器切换page不触发该事件
                                            _player.playAt(index); // 滑动轮播图切换歌曲
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // 添加至喜欢按钮、歌曲名称、歌手、添加至歌单按钮
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // 爱心按钮
                                      IconButton(
                                        onPressed: () {
                                          print("添加至我的喜欢歌单");
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Color(0xFFEC4899),
                                        ),
                                      ),
                                      // 歌曲名称、专辑、歌手
                                      Expanded(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 28,
                                              child: CustomMarquee(
                                                text: song.name,
                                                style: TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            SizedBox(
                                              height: 20,
                                              child: CustomMarquee(
                                                text: song.singersName,
                                                style: TextStyle(
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // 添加至歌单
                                      IconButton(
                                        onPressed: () {
                                          print("添加至歌单");
                                        },
                                        icon: Icon(
                                          Icons.add_box,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        // 音频进度条
                        StreamBuilder<PositionData>(
                          stream: _player.positionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;
                            return ProgressBar(
                              progress: positionData?.position ?? Duration.zero,
                              buffered:
                                  positionData?.bufferedPosition ??
                                  Duration.zero,
                              total: positionData?.duration ?? Duration.zero,
                              progressBarColor: AppColors.primary,
                              baseBarColor: Colors.white.withValues(
                                alpha: 0.24,
                              ),
                              bufferedBarColor: Colors.white.withValues(
                                alpha: 0.24,
                              ),
                              thumbColor: AppColors.primary,
                              barHeight: 4.0,
                              thumbRadius: 8.0,
                              timeLabelTextStyle: TextStyle(
                                color: AppColors.textPrimary40,
                                fontSize: 13,
                              ),
                              onSeek: _player.seek,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        // 播放模式切换按钮、上一首、暂停/播放、下一首、播放列表
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => IconButton(
                                onPressed: () {
                                  _player.toggleLoopMode(context: context);
                                },
                                icon: Icon(
                                  _player.loopModeIcon.value,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                              ),
                            ),
                            // 播放上一首
                            IconButton(
                              onPressed: () {
                                _player.previous();
                              },
                              icon: Icon(
                                Icons.skip_previous,
                                color: AppColors.textPrimary,
                                size: 40,
                              ),
                            ),
                            // 暂停/播放按钮
                            IconButton.filled(
                              onPressed: () {
                                if (isPlaying) {
                                  _player.pause();
                                } else {
                                  _player.play();
                                }
                              },
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                              ),
                              iconSize: 40,
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.textPrimary,
                                minimumSize: const Size(80, 80),
                              ),
                            ),
                            // 播放下一首
                            IconButton(
                              onPressed: () {
                                _player.next();
                              },
                              icon: Icon(
                                Icons.skip_next,
                                color: AppColors.textPrimary,
                                size: 40,
                              ),
                            ),
                            // 点击弹出当前播放列表
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => PlaylistBottomSheet(
                                    currentIndex: _player.currentIndex,
                                    playlist: _player.playlist,
                                    total: _player.songTotalCount.value,
                                    onPressed: (index) => _player.playAt(index),
                                    onScrollBottom: () {
                                      if (_player.hasMore &&
                                          !_player.isLoading.value) {
                                        _player.loadMore();
                                      }
                                    },
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.format_list_bulleted,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // 音量大小进度条
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.volume_down,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ProgressBar(
                                progress: Duration(
                                  milliseconds: (_player.volumn * 100).toInt(),
                                ),
                                total: Duration(milliseconds: 100),
                                progressBarColor: AppColors.primary.withValues(
                                  alpha: 0.7,
                                ),
                                baseBarColor: Colors.white.withValues(
                                  alpha: 0.24,
                                ),
                                thumbColor: Colors.transparent,
                                thumbGlowColor: Colors.transparent,
                                barHeight: 4.0,
                                thumbRadius: 20,
                                timeLabelLocation: TimeLabelLocation.none,
                                onSeek: (duration) async {
                                  final newVolumn =
                                      duration.inMilliseconds / 100;
                                  _player.setVolumn(newVolumn);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.volume_up,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // obxxxxxxx
            );
          },
        ),
      );
    }); // scaffoldddddd
  }
}
