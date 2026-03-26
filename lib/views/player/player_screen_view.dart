import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/viewmodels/player_screen_viewmodel.dart';
import 'package:flutter_music_app/widgets/custom_marquee.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';
import 'package:get/get.dart';

class PlayerScreenView extends StatefulWidget {
  const PlayerScreenView({super.key});

  @override
  State<PlayerScreenView> createState() => _PlayerScreenViewState();
}

class _PlayerScreenViewState extends State<PlayerScreenView> {
  Duration _position = Duration(milliseconds: 30000);
  Duration _buffered = Duration(milliseconds: 50000);
  Duration _duration = Duration(milliseconds: 200000);
  bool _isPlaying = true;
  late int _songId;
  late PlayerScreenViewmodel _playerScreenVM;

  @override
  void initState() {
    super.initState();
    _songId = Get.arguments['id'] ?? 0;
    print("播放歌曲id: $_songId");
    _playerScreenVM = Get.put(
      PlayerScreenViewmodel(ids: Get.arguments?['id'] ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
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
          "正在播放",
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgPrimary, AppColors.bgAppBar],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Obx(() {
          if (_playerScreenVM.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          final _song = _playerScreenVM.song.value;
          return Column(
            children: [
              // 歌曲封面图片
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "song_image",
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(media.width * 0.3),
                        child: NeteaseImage(
                          url: _song!.picUrl,
                          width: media.width * 0.6,
                          height: media.width * 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // 添加至喜欢按钮、歌曲名称、歌手、添加至歌单按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 爱心按钮
                  IconButton(
                    onPressed: () {
                      print("添加至我的喜欢歌单");
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Color(0xFFEC4899),
                      size: 20,
                    ),
                  ),
                  // 歌曲名称、专辑、歌手
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 28,
                          child: CustomMarquee(
                            text: _song.name,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        // const SizedBox(height: 5),
                        SizedBox(
                          height: 20,
                          child: CustomMarquee(
                            text: "${_song.al.name} • ${_song.singersName}",
                            style: TextStyle(
                              color: AppColors.textSecondary,
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
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 音频进度条
              ProgressBar(
                progress: Duration(milliseconds: 30000),
                buffered: Duration(milliseconds: 50000),
                total: Duration(milliseconds: _song.dt),
                progressBarColor: AppColors.primary,
                baseBarColor: Colors.white.withValues(alpha: 0.24),
                bufferedBarColor: Colors.white.withValues(alpha: 0.24),
                thumbColor: Colors.white,
                barHeight: 4.0,
                thumbRadius: 8.0,
                timeLabelTextStyle: TextStyle(
                  color: AppColors.textPrimary40,
                  fontSize: 13,
                ),
                onSeek: (duration) {
                  // _player.seek(duration);
                  print("播放进度跳转至: $duration");
                },
              ),
              const SizedBox(height: 20),
              // 播放模式切换按钮、上一首、暂停/播放、下一首、播放列表
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 播放模式切换按钮
                  IconButton(
                    onPressed: () {
                      print("切换播放模式");
                    },
                    icon: Icon(
                      Icons.sync_alt,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  // 上一首
                  IconButton(
                    onPressed: () {
                      print("播放上一首");
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
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 40,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textPrimary,
                      minimumSize: const Size(80, 80),
                    ),
                  ),
                  // 下一首
                  IconButton(
                    onPressed: () {
                      print("播放下一首");
                    },
                    icon: Icon(
                      Icons.skip_next,
                      color: AppColors.textPrimary,
                      size: 40,
                    ),
                  ),
                  // 弹出当前播放列表
                  IconButton(
                    onPressed: () {
                      print("弹出当前播放列表");
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
                  Icon(Icons.volume_down, color: AppColors.textSecondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ProgressBar(
                      progress: Duration(milliseconds: 30000),
                      total: Duration(milliseconds: 200000),
                      progressBarColor: AppColors.primary.withValues(
                        alpha: 0.7,
                      ),
                      baseBarColor: Colors.white.withValues(alpha: 0.24),
                      thumbColor: Colors.transparent,
                      thumbGlowColor: Colors.transparent,
                      barHeight: 4.0,
                      thumbRadius: 16,
                      timeLabelLocation: TimeLabelLocation.none,
                      onSeek: (duration) {
                        // _player.seek(duration);
                        print("播放进度跳转至: $duration");
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.volume_up, color: AppColors.textSecondary),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
