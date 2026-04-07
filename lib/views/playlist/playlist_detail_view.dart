import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:flutter_music_app/utils/count_util.dart';
import 'package:flutter_music_app/viewmodels/playlist_detail_viewmodel.dart';
import 'package:flutter_music_app/widgets/mini_player.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';
import 'package:flutter_music_app/widgets/playlist_song_cell.dart';
import 'package:get/get.dart';

class PlaylistDetailView extends StatefulWidget {
  const PlaylistDetailView({super.key});

  @override
  State<PlaylistDetailView> createState() => _PlaylistDetailViewState();
}

class _PlaylistDetailViewState extends State<PlaylistDetailView> {
  final _scrollController = ScrollController();
  late PlaylistDetailViewmodel _playlistDetailVM;
  bool _descExpanded = false; // 是否展开歌单简介
  final _player = Get.find<PlayerService>();

  @override
  void initState() {
    super.initState();
    print('页面传参id:${Get.arguments['id'] ?? 0}');
    _playlistDetailVM = Get.put(
      PlaylistDetailViewmodel(id: Get.arguments['id'] ?? 0),
    );

    // 监听页面滚动
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (!_playlistDetailVM.hasMore || _playlistDetailVM.isLoading.value) {
          return;
        }
        // 触底加载更多歌曲
        _playlistDetailVM.loadMore();
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
            colors: [AppColors.bgPrimary, AppColors.bgCard],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: [
            Obx(() {
              if (_playlistDetailVM.songList.isEmpty ||
                  _playlistDetailVM.playlistDetail.value == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final playlist = _playlistDetailVM.playlistDetail.value!;
              final songList = _playlistDetailVM.songList;
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    scrolledUnderElevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    title: Text(
                      "歌单详情",
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
                  // 歌单封面、歌单简介、播放全部按钮、收藏歌单按钮
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // 歌单封面
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: NeteaseImage(
                              url: playlist.coverImgUrl,
                              width: media.width * 0.5,
                              height: media.width * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 歌单名称
                          Text(
                            playlist.name,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // 歌曲数量、播放量
                          Text(
                            "by ${playlist.creator?.nickname ?? '网易云音乐'} • ${playlist.trackCount}首 • 播放量 ${CountUtil.formatCount(playlist.playCount)}",
                            style: TextStyle(
                              color: AppColors.textPrimary60,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // 歌单简介
                          playlist.description.isEmpty
                              ? const SizedBox.shrink()
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _descExpanded = !_descExpanded;
                                    });
                                  },
                                  child: Text(
                                    playlist.description,
                                    maxLines: _descExpanded ? null : 2,
                                    overflow: _descExpanded
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textPrimary40,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                          // 播放全部、随机播放按钮
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    clipBehavior: Clip.antiAlias,
                                    onPressed: () {
                                      _player.playSong(
                                        songList[0].id,
                                        songList,
                                        playlist.trackCount,
                                        _playlistDetailVM.loadMoreSongsForPlayer,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: AppColors.textPrimary,
                                    ),
                                    label: Text(
                                      "全部播放",
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      overlayColor: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.add_box_outlined,
                                      color: AppColors.primary,
                                    ),
                                    label: Text(
                                      "收藏歌单",
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.bgCard,
                                      overlayColor: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 喜爱、评论、分享
                          Padding(
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
                                        CountUtil.formatCount(
                                          playlist.subscribedCount,
                                        ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat,
                                        color: AppColors.textSecondary,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        CountUtil.formatCount(
                                          playlist.commentCount,
                                        ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.share,
                                        color: AppColors.textSecondary,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        CountUtil.formatCount(
                                          playlist.shareCount,
                                        ),
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
                        ],
                      ),
                    ),
                  ),
                  // 列表标题
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
                          Text(
                            "歌曲列表",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${playlist.trackCount}首",
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
                      itemCount: songList.length,
                      itemBuilder: (context, index) {
                        final item = songList[index];
                        return PlaylistSongCell(
                          index: index,
                          song: item,
                          // image: item.picUrl,
                          // title: item.name,
                          // subtitle:
                          //     "${item.singersName} • ${TimeUtil.formatDuration(Duration(milliseconds: item.dt))}",
                          onPressedPlay: () async {
                            // 先判断一下音乐是否有版权
                            final isAvailable = await _player.checkSong(
                              item.id,
                            );
                            if (isAvailable) {
                              // 如果音乐有版权，则跳转播放播放
                              _player.playSong(
                                item.id,
                                songList,
                                playlist.trackCount,
                                _playlistDetailVM.loadMoreSongsForPlayer,
                              );
                              Get.toNamed(AppRoutes.playerScreen);
                            }
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                    ),
                  ),
                ],
              );
            }),
            Positioned(left: 0, right: 0, bottom: 0, child: MiniPlayer()),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight * 0.5,
        color: Colors.black,
      ),
    );
  }
}
