import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:flutter_music_app/utils/count_util.dart';
import 'package:flutter_music_app/utils/netease_image_util.dart';
import 'package:flutter_music_app/utils/toast_util.dart';
import 'package:flutter_music_app/viewmodels/album_detail_viewmodel.dart';
import 'package:flutter_music_app/widgets/mini_player.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';
import 'package:flutter_music_app/widgets/palette_background.dart';
import 'package:flutter_music_app/widgets/playlist_song_cell.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AlbumDetailView extends StatefulWidget {
  const AlbumDetailView({super.key});

  @override
  State<AlbumDetailView> createState() => _AlbumDetailViewState();
}

class _AlbumDetailViewState extends State<AlbumDetailView> {
  late AlbumDetailViewmodel _albumDetailVM;
  final _player = Get.find<PlayerService>();

  @override
  void initState() {
    super.initState();
    _albumDetailVM = Get.put(
      AlbumDetailViewmodel(id: Get.arguments['id'] ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Obx(() {
        final album = _albumDetailVM.album.value;
        final songs = _albumDetailVM.songs;

        if (album == null || songs.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.bgPrimary, AppColors.bgCard],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  scrolledUnderElevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: Text(
                    "专辑",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz),
                    ),
                  ],
                ),
                // 歌单封面、歌单简介
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black87,
                          builder: (dialogContext) {
                            return Material(
                              color: Colors.transparent,
                              child: PaletteBackground(
                                imageProvider: NeteaseImageUtil.provider(
                                  album.picUrl,
                                ),
                                child: Column(
                                  spacing: 20,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        icon: const Icon(Icons.close),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                      ),
                                      child: Column(
                                        spacing: 20,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: NeteaseImage(
                                              url: album.picUrl,
                                              width: media.width * 0.6,
                                              height: media.width * 0.6,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          // 专辑名称
                                          Text(
                                            album.name,
                                            softWrap: false,
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          // 歌手
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '歌手: ',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textPrimary60,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: album.artistsName,
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textPrimary80,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // 发行时间
                                          Text(
                                            "发行时间: ${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(album.publishTime))}",
                                            style: TextStyle(
                                              color: AppColors.textPrimary60,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          // 专辑简介
                                          if (album.briefDesc != null &&
                                              album.briefDesc != '')
                                            Text(
                                              album.briefDesc!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.textPrimary60,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: SizedBox(
                        height: media.width * 0.3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 专辑封面
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: NeteaseImage(
                                url: album.picUrl,
                                width: media.width * 0.3,
                                height: media.width * 0.3,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 专辑名称
                                  Text(
                                    album.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // 歌手
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '歌手: ',
                                          style: TextStyle(
                                            color: AppColors.textPrimary60,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: album.artistsName,
                                          style: TextStyle(
                                            color: AppColors.textPrimary80,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 发行时间
                                  Text(
                                    "发行时间: ${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(album.publishTime))}",
                                    style: TextStyle(
                                      color: AppColors.textPrimary60,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // 专辑简介
                                  if (album.briefDesc != null &&
                                      album.briefDesc != '')
                                    Text(
                                      album.briefDesc!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.textPrimary60,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // 喜爱、评论、分享
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // 喜爱数量
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite,
                                color: AppColors.textSecondary,
                                size: 15,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                CountUtil.formatCount(album.likedCount),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 评论数量
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat,
                                color: AppColors.textSecondary,
                                size: 15,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                CountUtil.formatCount(album.commentCount),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 分享
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share,
                                color: AppColors.textSecondary,
                                size: 15,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                CountUtil.formatCount(album.shareCount),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 列表标题
                SliverPadding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "歌曲列表",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${album.size}首",
                          style: TextStyle(
                            color: AppColors.textPrimary80,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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
                    bottom: 80,
                  ),
                  sliver: SliverList.separated(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final item = songs[index];
                      return PlaylistSongCell(
                        index: index,
                        song: item,
                        onPressedPlay: () async {
                          final isAvailable = await _player.checkSong(item.id);
                          if (!isAvailable) {
                            ToastUtil.showToast('暂无版权');
                            return;
                          }
                          await _player.playSong(
                            item.id,
                            songs,
                            album.size,
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
              ],
            ),
            Positioned(left: 0, right: 0, bottom: 0, child: MiniPlayer()),
          ],
        );
      }),
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight * 0.5,
        color: Colors.black,
      ),
    );
  }
}
