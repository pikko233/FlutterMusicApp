import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/widgets/recent_song_cell.dart';
import 'package:flutter_music_app/widgets/search_playlist_cell.dart';
import 'package:flutter_music_app/widgets/section_title.dart';
import 'package:get/get.dart';

class MyView extends StatefulWidget {
  const MyView({super.key});

  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Text(
            "个人主页",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
            bottom: 80,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                // 头像
                ClipRRect(
                  borderRadius: BorderRadius.circular(media.width * 0.15),
                  child: Image.asset(
                    "assets/images/ar_4.png",
                    width: media.width * 0.3,
                    height: media.width * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                // 用户名
                Text(
                  "pikko233",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                // 等级、勋章之类的
                Text(
                  "音乐爱好者 • Lv6",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                // 收藏、关注、粉丝
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "247",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "收藏",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        VerticalDivider(
                          width: 0.5,
                          thickness: 0.5,
                          color: AppColors.textPrimary.withValues(alpha: 0.1),
                        ),
                        Column(
                          children: [
                            Text(
                              "38",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "关注",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        VerticalDivider(
                          width: 0.5,
                          thickness: 0.5,
                          color: AppColors.textPrimary.withValues(alpha: 0.1),
                        ),
                        Column(
                          children: [
                            Text(
                              "12",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "粉丝",
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
                ),
                SectionTitle(
                  title: "我的歌单",
                  showMore: true,
                  showMoreLabel: "全部",
                  onPressed: () {},
                ),
                // 歌单列表
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return SearchPlaylistCell(
                      image: "assets/images/ar_2.png",
                      title: "我喜欢的音乐",
                      subtitle: "247 首歌曲",
                      onPressed: () {
                        print("跳转至歌单详情页");
                        Get.toNamed(AppRoutes.playlistDetail);
                      },
                      onPressedPlay: () {
                        print("播放歌单的第一首歌，并将其歌单列表替换为当前播放列表");
                      },
                    );
                  },
                ),
                SectionTitle(
                  title: "最近播放",
                  showMore: true,
                  showMoreLabel: "全部",
                  onPressed: () {},
                ),
                // 最近播放列表
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return RecentSongCell(
                      image: "assets/images/ar_2.png",
                      title: "我喜欢的音乐",
                      subtitle: "247 首歌曲",
                      duration: Duration(milliseconds: 200000),
                      onPressed: () {
                        print("当前播放歌曲改为此首");
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
