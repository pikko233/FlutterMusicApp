import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';
import 'package:flutter_music_app/widgets/song_popup_menu.dart';
import 'package:get/get.dart';

class PlaylistSongCell extends StatelessWidget {
  final int index;
  final bool isPlaying;
  final SongModel song;
  final VoidCallback onPressedPlay;
  final bool showImage;
  PlaylistSongCell({
    super.key,
    this.isPlaying = false,
    required this.index,
    required this.song,
    required this.onPressedPlay,
    this.showImage = true,
  });

  final _player = Get.find<PlayerService>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Material(
        color: _player.currentSongId.value == song.id
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.bgCard,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
          side: BorderSide(
            color: _player.currentSongId.value == song.id
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: ListTile(
          onTap: onPressedPlay,
          contentPadding: const EdgeInsets.only(left: 5),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 36,
                child: _player.currentSongId.value == song.id
                    ? const Icon(Icons.play_arrow, color: AppColors.primary)
                    : Text(
                        "${index + 1}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
              ),
              !showImage
                  ? const SizedBox.shrink()
                  : ClipRRect(
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
          title: Text(
            song.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _player.currentSongId.value == song.id
                  ? AppColors.primary
                  : AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '${song.singersName} - ${song.al.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary60,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: SongPopupMenu(song: song),
        ),
      ),
    );
  }
}
