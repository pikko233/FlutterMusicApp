import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/utils/time_util.dart';
import 'package:flutter_music_app/widgets/song_popup_menu.dart';

class SearchSongCell extends StatelessWidget {
  final bool isPlaying;
  final SongModel song;
  // final String image;
  // final String title;
  // final String subtitle;
  final VoidCallback onPressedPlay;
  const SearchSongCell({
    super.key,
    this.isPlaying = false,
    required this.song,
    // required this.image,
    // required this.title,
    // required this.subtitle,
    required this.onPressedPlay,
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
        "${song.singersName} - ${song.al.name} • ${TimeUtil.formatDuration(Duration(milliseconds: song.dt))}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColors.textPrimary60,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      // trailing: IconButton(
      //   onPressed: onPressedMore,
      //   icon: Icon(Icons.more_horiz, color: AppColors.textPrimary40),
      // ),
      trailing: SongPopupMenu(song: song),
    );
  }
}
