import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/widgets/song_card.dart';
import 'package:flutter_music_app/widgets/section_title.dart';
import 'package:flutter_music_app/widgets/playlist_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          toolbarHeight: kToolbarHeight * 1.5,
          backgroundColor: AppColors.bgPrimary,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.accent4,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Align(
                        child: Text(
                          "Z",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "晚上好 👋",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                // 今日推荐
                SectionTitle(title: "今日推荐", onPressed: () {}),
                const SizedBox(height: 10),
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
                          image: "assets/images/ar_1.png",
                          title: "SongName",
                          subtitle: "Singer",
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                // 最近播放
                SectionTitle(title: "推荐电台", onPressed: () {}),
                const SizedBox(height: 10),
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
                          image: "assets/images/ar_2.png",
                          title: "SongName",
                          subtitle: "Singer",
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                // 最近播放
                SectionTitle(
                  title: "最近播放",
                  onPressed: () {},
                  showSeeAll: false,
                ),
                const SizedBox(height: 10),
                Column(
                  spacing: 10,
                  children: List.generate(3, (context) {
                    return SongCard(
                      image: "assets/images/ar_4.png",
                      title: "As It Was",
                      subtitle: "Harry Styles · 2:47",
                      onPressed: () {},
                    );
                  }),
                ),
                const SizedBox(height: 20),
                // 为你打造
                SectionTitle(title: "为你打造", onPressed: () {}),
                const SizedBox(height: 10),
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
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20),
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
                        iconSize: 60,
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
