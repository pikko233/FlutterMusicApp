import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/widgets/mini_player.dart';
import 'package:flutter_music_app/widgets/playlist_song_cell.dart';
import 'package:get/get.dart';

class SingerDetailView extends StatefulWidget {
  const SingerDetailView({super.key});

  @override
  State<SingerDetailView> createState() => _SingerDetailViewState();
}

class _SingerDetailViewState extends State<SingerDetailView> {
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
                    "歌手主页",
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
                          borderRadius: BorderRadius.circular(
                            media.width * 0.15,
                          ),
                          child: Image.asset(
                            "assets/images/ar_4.png",
                            width: media.width * 0.3,
                            height: media.width * 0.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "周杰伦",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "粉丝 4,823万 • 歌曲 1,284首",
                          style: TextStyle(
                            color: AppColors.textPrimary60,
                            fontSize: 12,
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
                                      Icon(Icons.add, size: 20),
                                      Text(
                                        "关注",
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
                                        Icons.play_arrow,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                      Text(
                                        "播放",
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
                      return ListTile(
                        // TODO 需要补一下PlaylistSongCell
                        title: Text('先占位，后面再补'),
                      );
                      // return PlaylistSongCell(
                      //   index: index,
                      //   song: SongModel(id: 1, name: name, ar: ar, al: al, dt: dt),
                      //   // image: "assets/images/ar_4.png",
                      //   // title: "晴天",
                      //   // subtitle: "周杰伦 • 4:29",
                      //   onPressedPlay: () {},
                      // );
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
