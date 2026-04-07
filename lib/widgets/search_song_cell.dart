import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';

class SearchSongCell extends StatelessWidget {
  final bool isPlaying;
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onPressedPlay;
  final VoidCallback onPressedMore;
  const SearchSongCell({
    super.key,
    this.isPlaying = false,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onPressedPlay,
    required this.onPressedMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressedPlay,
      contentPadding: const EdgeInsets.only(left: 15),
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
        child: NeteaseImage(url: image, width: 40, height: 40),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isPlaying ? AppColors.primary : AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          !isPlaying
              ? const SizedBox.shrink()
              : Padding(
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
      trailing: IconButton(
        onPressed: onPressedMore,
        icon: Icon(Icons.more_horiz, color: AppColors.textPrimary40),
      ),
    );
  }
}
