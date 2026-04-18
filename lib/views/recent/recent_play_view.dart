import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:flutter_music_app/widgets/mini_player.dart';
import 'package:flutter_music_app/widgets/playlist_song_cell.dart';
import 'package:get/get.dart';

class RecentPlayView extends StatefulWidget {
  const RecentPlayView({super.key});

  @override
  State<RecentPlayView> createState() => _RecentPlayViewState();
}

class _RecentPlayViewState extends State<RecentPlayView> {
  final _player = Get.find<PlayerService>();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          '最近播放',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgCard, AppColors.bgPrimary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [kToolbarHeight / media.height, 1],
          ),
        ),
        child: Stack(
          children: [
            Obx(() {
              if (_player.recentSongs.isEmpty) {
                return const SizedBox.shrink();
              }
              return ListView.separated(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: 80,
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: _player.recentSongs.length,
                itemBuilder: (context, index) {
                  final item = _player.recentSongs[index];
                  return PlaylistSongCell(
                    index: index,
                    song: item,
                    onPressedPlay: () {
                      _player.playSong(
                        item.id,
                        _player.recentSongs,
                        _player.recentSongs.length,
                        null,
                      );
                    },
                  );
                },
              );
            }),
            Positioned(left: 0, right: 0, bottom: 0, child: MiniPlayer()),
          ],
        ),
      ),
    );
  }
}
