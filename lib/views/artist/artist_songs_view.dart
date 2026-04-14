import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:flutter_music_app/utils/throttle_util.dart';
import 'package:flutter_music_app/utils/toast_util.dart';
import 'package:flutter_music_app/viewmodels/artist_songs_viewmodel.dart';
import 'package:flutter_music_app/widgets/load_more_icon.dart';
import 'package:flutter_music_app/widgets/mini_player.dart';
import 'package:flutter_music_app/widgets/playlist_song_cell.dart';
import 'package:get/get.dart';

class ArtistSongsView extends StatefulWidget {
  const ArtistSongsView({super.key});

  @override
  State<ArtistSongsView> createState() => _ArtistSongsViewState();
}

class _ArtistSongsViewState extends State<ArtistSongsView> {
  final _player = Get.find<PlayerService>();
  final _scrollController = ScrollController();
  final _throttleUtil = ThrottleUtil();
  late ArtistSongsViewmodel _artistSongsVM;

  void initState() {
    super.initState();

    _artistSongsVM = Get.put(
      ArtistSongsViewmodel(id: Get.arguments['id'] ?? 0),
    );

    // 监听页面滚动
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _throttleUtil.throttle(() => _artistSongsVM.getMoreArtistSongs());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return Scaffold(
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
              if (_artistSongsVM.songs.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              final songs = _artistSongsVM.songs;
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    scrolledUnderElevation: 0,
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    title: Text(
                      '全部歌曲',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.more_horiz),
                      ),
                    ],
                  ),
                  // 歌曲列表
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                      bottom: 0,
                    ),
                    sliver: SliverList.separated(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final item = songs[index];
                        return PlaylistSongCell(
                          index: index,
                          song: item,
                          showImage: false,
                          onPressedPlay: () async {
                            final res = await _player.checkSong(item.id);
                            if (!res) {
                              ToastUtil.showToast('暂无版权');
                              return;
                            }
                            await _player.playSong(
                              item.id,
                              songs,
                              songs.length,
                              null,
                            );
                            Get.toNamed(AppRoutes.playerScreen);
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: LoadMoreIcon(
                      hasMore:
                          songs.length < _artistSongsVM.songTotalCount.value,
                    ),
                  ),
                ],
              );
            }),
            Positioned(left: 0, right: 0, bottom: 0, child: MiniPlayer()),
          ],
        ),
      ),
    );
  }
}
