import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';
import 'package:flutter_music_app/widgets/song_popup_menu.dart';

class PlaylistSongCell extends StatelessWidget {
  final int index;
  final bool isPlaying;
  final SongModel song;
  // final String image;
  // final String title;
  // final String subtitle;
  final VoidCallback onPressedPlay;
  const PlaylistSongCell({
    super.key,
    this.isPlaying = false,
    required this.index,
    required this.song,
    required this.onPressedPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPlaying
          ? AppColors.primary.withValues(alpha: 0.12)
          : AppColors.bgCard,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
        side: BorderSide(
          color: isPlaying
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: ListTile(
        onTap: onPressedPlay,
        contentPadding: EdgeInsets.zero,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 36,
              child: Text(
                "${index + 1}",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NeteaseImage(
                url: song.picUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                song.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isPlaying ? AppColors.primary : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          song.singersName,
          maxLines: 1,
          style: TextStyle(
            color: AppColors.textPrimary60,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: SongPopupMenu(song: song),
      ),
    );
  }
}
