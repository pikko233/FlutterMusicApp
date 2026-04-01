import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/utils/count_util.dart';
import 'package:flutter_music_app/viewmodels/home_viewmodel.dart';
import 'package:flutter_music_app/widgets/search_song_cell.dart';
import 'package:flutter_music_app/widgets/section_title.dart';
import 'package:flutter_music_app/widgets/playlist_card.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeVM = Get.put(HomeViewmodel());
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          toolbarHeight: kToolbarHeight * 1.2,
          backgroundColor: AppColors.bgCard,
          elevation: 0,
          scrolledUnderElevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.accent4,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Align(
                        child: Text(
                          "Z",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "晚上好~",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "你想听点什么？",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: 80,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                // 今日推荐
                // SectionTitle(title: "推荐歌单", onPressed: () {}),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Obx(
                    () => homeVM.isLoading.value
                        ? const SizedBox(
                            height: 160,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              homeVM.recommendPlaylist.length,
                              (index) {
                                final item = homeVM.recommendPlaylist[index];
                                return Padding(
                                  padding:
                                      index !=
                                          homeVM.recommendPlaylist.length - 1
                                      ? const EdgeInsets.only(right: 10)
                                      : const EdgeInsets.all(0),
                                  child: PlaylistCard(
                                    id: item.id,
                                    image: item.picUrl,
                                    title: item.name,
                                    subtitle:
                                        '播放量 ${CountUtil.formatCount(item.playCount)}',
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),
                // 推荐电台
                SectionTitle(title: "推荐电台", onPressed: () {}),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: index != 4
                            ? const EdgeInsets.only(right: 10)
                            : const EdgeInsets.all(0),
                        child: PlaylistCard(
                          id: 0,
                          image: "assets/images/ar_2.png",
                          title: "SongName",
                          subtitle: "Singer",
                        ),
                      );
                    }),
                  ),
                ),
                // 排行榜
                SectionTitle(title: "排行榜", onPressed: () {}),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: index != 4
                            ? const EdgeInsets.only(right: 10)
                            : const EdgeInsets.all(0),
                        child: PlaylistCard(
                          id: 0,
                          image: "assets/images/ar_2.png",
                          title: "SongName",
                          subtitle: "Singer",
                        ),
                      );
                    }),
                  ),
                ),
                // 最近播放
                SectionTitle(title: "最近常听", onPressed: () {}, showMore: false),
                Column(
                  spacing: 10,
                  children: List.generate(3, (context) {
                    return SearchSongCell(
                      image: "assets/images/ar_4.png",
                      title: "晴天",
                      subtitle: "周杰伦 • 4:29",
                      onPressedPlay: () {},
                      onPressedMore: () {},
                    );
                  }),
                ),
                // 为你打造
                SectionTitle(title: "为你打造", onPressed: () {}),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          "assets/images/ar_2.png",
                          width: 68,
                          height: 68,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          spacing: 6,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Daily Mix 1",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "基于你最近播放的推荐歌曲",
                              style: TextStyle(
                                color: AppColors.textPrimary40,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              "48 首歌曲 · 3 小时 12 分钟",
                              style: TextStyle(
                                color: AppColors.textPrimary40,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        iconSize: 50,
                        icon: Icon(Icons.play_circle_fill_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
