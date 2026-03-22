import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/utils/time_util.dart';

class RecentSongCell extends StatelessWidget {
  final bool isPlaying;
  final String image;
  final String title;
  final String subtitle;
  final Duration duration;
  final VoidCallback onPressed;
  const RecentSongCell({
    super.key,
    this.isPlaying = false,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      contentPadding: const EdgeInsets.only(left: 15, right: 15),
      tileColor: isPlaying
          ? AppColors.primary.withValues(alpha: 0.12)
          : AppColors.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
        side: BorderSide(
          color: isPlaying
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(image, width: 40, height: 40, fit: BoxFit.cover),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            style: TextStyle(
              color: isPlaying ? AppColors.primary : AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Opacity(
            opacity: isPlaying ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: AppColors.primary.withValues(alpha: 0.7),
                    size: 13,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    "播放中",
                    style: TextStyle(
                      color: AppColors.primary.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        style: TextStyle(
          color: AppColors.textPrimary60,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Text(
        TimeUtil.formatDuration(duration),
        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
    );
  }
}
