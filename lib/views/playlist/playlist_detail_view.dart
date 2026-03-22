import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/widgets/mini_player.dart';
import 'package:flutter_music_app/widgets/playlist_song_cell.dart';
import 'package:get/get.dart';

class PlaylistDetailView extends StatefulWidget {
  const PlaylistDetailView({super.key});

  @override
  State<PlaylistDetailView> createState() => _PlaylistDetailViewState();
}

class _PlaylistDetailViewState extends State<PlaylistDetailView> {
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
            CustomScrollView(
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
                    IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            "assets/images/ar_4.png",
                            width: media.width * 0.5,
                            height: media.width * 0.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "周杰伦精选 • 最强华语",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "by 网易云音乐 • 286首 • 播放量 1.2 亿",
                          style: TextStyle(
                            color: AppColors.textPrimary60,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "精选周杰伦历年最受欢迎的歌曲，带你回味经典……",
                          style: TextStyle(
                            color: AppColors.textPrimary40,
                            fontSize: 11,
                          ),
                        ),
                        // 播放全部、随机播放按钮
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.play_arrow, size: 20),
                                      Text(
                                        "播放全部",
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgPrimary,
                                    borderRadius: BorderRadius.circular(20),
                                    border: BoxBorder.all(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.sync_alt,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                      Text(
                                        "随机播放",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
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
                              Row(
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
                                    "2.4万",
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              // 评论数量
                              Row(
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
                                    "8,392",
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              // 分享
                              Row(
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
                                    "分享",
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
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
                          "286首",
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
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                    bottom: 80,
                  ),
                  sliver: SliverList.separated(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return PlaylistSongCell(
                        index: index,
                        image: "assets/images/ar_4.png",
                        title: "晴天",
                        subtitle: "周杰伦 • 4:29",
                        onPressedPlay: () {},
                        onPressedMore: () {},
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
        ),
      ),
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight * 0.5,
        color: Colors.black,
      ),
    );
  }
}
