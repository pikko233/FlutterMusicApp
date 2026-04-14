import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/widgets/playlist_song_cell.dart';
import 'package:get/state_manager.dart';

class PlaylistBottomSheet extends StatefulWidget {
  final int currentIndex; // 当前播放歌曲的索引
  final List playlist; // 播放列表（分页加载部分的歌曲）
  final int total; // 播放列表歌曲总数（包含分页未加载完的歌曲）
  final Function(int index) onPressed; // 点击播放
  final VoidCallback onScrollBottom; // 滚动触底事件
  const PlaylistBottomSheet({
    super.key,
    required this.currentIndex,
    required this.playlist,
    required this.total,
    required this.onPressed,
    required this.onScrollBottom,
  });

  @override
  State<PlaylistBottomSheet> createState() => _PlaylistBottomSheetState();
}

class _PlaylistBottomSheetState extends State<PlaylistBottomSheet> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        widget.onScrollBottom();
      }
    });
  }

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
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 15,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "播放列表",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${widget.total}",
                          style: TextStyle(
                            color: AppColors.textPrimary80,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: widget.playlist.length,
                      itemBuilder: (context, index) {
                        final song = widget.playlist[index];
                        return PlaylistSongCell(
                          index: index,
                          song: song,
                          onPressedPlay: () => widget.onPressed(index),
                          showImage: false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
