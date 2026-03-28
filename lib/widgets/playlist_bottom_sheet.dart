import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';
import 'package:flutter_music_app/widgets/playlist_song_cell.dart';
import 'package:get/state_manager.dart';

class PlaylistBottomSheet extends StatelessWidget {
  final int currentIndex; // 当前播放歌曲的索引
  final List playlist; // 播放列表
  final Function(int index) onPressed; // 点击播放
  const PlaylistBottomSheet({
    super.key,
    required this.currentIndex,
    required this.playlist,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return SizedBox(
      height: media.height * 0.6,
      child: Obx(
        () => Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "播放列表 (${playlist.length}首歌)",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: playlist.length,
                itemBuilder: (context, index) {
                  final song = playlist[index];
                  return PlaylistSongCell(
                    index: index,
                    image: song.picUrl,
                    title: song.name,
                    subtitle: song.singersName,
                    onPressedPlay: () => onPressed(index),
                    onPressedMore: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
