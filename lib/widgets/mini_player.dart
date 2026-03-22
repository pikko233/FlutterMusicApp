import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:get/get.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final Duration _progress = Duration(milliseconds: 30000);
  final Duration _buffered = Duration(milliseconds: 50000);
  final Duration _total = Duration(milliseconds: 300000);
  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              onTap: () {
                Get.toNamed(AppRoutes.playerScreen);
              },
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: const EdgeInsets.only(left: 15),
              leading: Hero(
                tag: "song_image",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/images/ar_4.png",
                    width: 35,
                    height: 35,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                "晴天",
                maxLines: 1,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "周杰伦",
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
                    onPressed: () {},
                    icon: Icon(Icons.pause),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.skip_next, color: AppColors.textSecondary),
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ProgressBar(
                progress: _progress,
                buffered: _buffered,
                total: _total,
                progressBarColor: AppColors.primary,
                baseBarColor: Colors.white.withValues(alpha: 0.24),
                bufferedBarColor: Colors.transparent,
                thumbColor: Colors.transparent,
                barHeight: 3.0,
                thumbRadius: 5.0,
                timeLabelLocation: TimeLabelLocation.none,
                onSeek: null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
