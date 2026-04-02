import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';
import 'package:get/get.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final _player = Get.find<PlayerService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final song = _player.song.value;
      final isPlaying = _player.isPlaying.value;
      if (song == null) {
        return SizedBox.shrink();
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87, Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            // 迷你播放器卡片 - 显示歌曲信息 以及 播放/暂停、下一首 按钮
            Material(
              color: AppColors.bgElevated,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.playerScreen,
                    arguments: {
                      'id': song.id,
                      'needPlay': false,
                    }, // 从迷你播放器跳转至播放详情时，不自动播放歌曲
                  );
                },
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.only(left: 10, right: 5),
                leading: Hero(
                  tag: "playing_song_image_${song.id}",
                  child: RotationTransition(
                    turns: _player.rotationController,
                    child: ClipOval(
                      child: NeteaseImage(
                        url: song.picUrl,
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  song.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  song.singersName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary60,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (isPlaying) {
                          _player.pause();
                        } else {
                          _player.play();
                        }
                      },
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      onPressed: () {
                        _player.next();
                      },
                      icon: Icon(
                        Icons.skip_next,
                        color: AppColors.textSecondary,
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ),
            // 播放进度条
            IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<PositionData>(
                  stream: _player.positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return ProgressBar(
                      progress: positionData?.position ?? Duration.zero,
                      buffered: positionData?.bufferedPosition ?? Duration.zero,
                      total: positionData?.duration ?? Duration.zero,
                      progressBarColor: AppColors.primary,
                      baseBarColor: Colors.white.withValues(alpha: 0.24),
                      bufferedBarColor: Colors.transparent,
                      thumbColor: Colors.transparent,
                      barHeight: 3.0,
                      thumbRadius: 5.0,
                      timeLabelLocation: TimeLabelLocation.none,
                      onSeek: null,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
