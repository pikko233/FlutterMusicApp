import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:flutter_music_app/utils/toast_util.dart';
import 'package:flutter_music_app/viewmodels/artist_detail_viewmodel.dart';
import 'package:flutter_music_app/widgets/mini_player.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';
import 'package:flutter_music_app/widgets/playlist_song_cell.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ArtistDetailView extends StatefulWidget {
  const ArtistDetailView({super.key});

  @override
  State<ArtistDetailView> createState() => _ArtistDetailViewState();
}

class _ArtistDetailViewState extends State<ArtistDetailView> {
  late ArtistDetailViewmodel _artistDetailVM;
  final _player = Get.find<PlayerService>();

  void initState() {
    super.initState();

    _artistDetailVM = Get.put(
      ArtistDetailViewmodel(id: Get.arguments['id'] ?? 0),
    );
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
              if (_artistDetailVM.artist.value == null ||
                  _artistDetailVM.topSongs.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              final artist = _artistDetailVM.artist.value!;
              final topSongs = _artistDetailVM.topSongs;
              return CustomScrollView(
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
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.more_horiz),
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              media.width * 0.15,
                            ),
                            child: NeteaseImage(
                              url: artist.cover!,
                              width: media.width * 0.3,
                              height: media.width * 0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            artist.name,
                            style: TextStyle(
                              color: AppColors.textPrimary80,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (artist.transNames!.isNotEmpty)
                            Column(
                              children: [
                                Text(
                                  artist.transNames!.join(', '),
                                  style: TextStyle(
                                    color: AppColors.textPrimary60,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          Text(
                            "专辑 ${NumberFormat.decimalPattern().format(artist.albumSize)} 张 • 歌曲 ${NumberFormat.decimalPattern().format(artist.musicSize)} 首",
                            style: TextStyle(
                              color: AppColors.textPrimary60,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // 播放全部、随机播放按钮
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 30,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    print('关注歌手');
                                  },
                                  label: Text(
                                    '关注',
                                    style: TextStyle(
                                      color: AppColors.textPrimary80,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.add,
                                    color: AppColors.textPrimary80,
                                    size: 20,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    overlayColor: Colors.white.withValues(
                                      alpha: 0.2,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 歌曲列表
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton.filled(
                            onPressed: () async {
                              // print('播放热门歌曲');
                              final res = await _player.checkSong(
                                topSongs[0].id,
                              );
                              if (!res) {
                                ToastUtil.showToast('暂无版权');
                                return;
                              }
                              await _player.playSong(
                                topSongs[0].id,
                                topSongs,
                                topSongs.length,
                                null,
                              );
                              Get.toNamed(AppRoutes.playerScreen);
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              color: AppColors.textPrimary80,
                              size: 18,
                            ),
                            visualDensity: VisualDensity.compact,

                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "播放热门歌曲",
                              style: TextStyle(
                                color: AppColors.textPrimary80,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            "50首",
                            style: TextStyle(
                              color: AppColors.textPrimary80,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    sliver: SliverList.separated(
                      itemCount: topSongs.length,
                      itemBuilder: (context, index) {
                        final item = topSongs[index];
                        return PlaylistSongCell(
                          index: index,
                          song: item,
                          onPressedPlay: () async {
                            final res = await _player.checkSong(item.id);
                            if (!res) {
                              ToastUtil.showToast('暂无版权');
                              return;
                            }
                            await _player.playSong(
                              item.id,
                              topSongs,
                              topSongs.length,
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
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Get.toNamed(
                              AppRoutes.artistSongs,
                              arguments: {'id': artist.id},
                            ),
                            child: Text(
                              '查看全部歌曲',
                              style: TextStyle(
                                color: AppColors.textPrimary60,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textPrimary60,
                            size: 15,
                          ),
                        ],
                      ),
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
