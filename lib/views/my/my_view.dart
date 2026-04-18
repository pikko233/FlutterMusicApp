import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:flutter_music_app/utils/user_storage.dart';
import 'package:flutter_music_app/widgets/playlist_song_cell.dart';
import 'package:flutter_music_app/widgets/recent_song_cell.dart';
import 'package:flutter_music_app/widgets/search_playlist_cell.dart';
import 'package:flutter_music_app/widgets/search_song_cell.dart';
import 'package:flutter_music_app/widgets/section_title.dart';
import 'package:get/get.dart';

class MyView extends StatefulWidget {
  const MyView({super.key});

  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  bool _isGuest = true; // 是否为游客
  bool _isLoggedIn = false; // 是否已登录

  // 如果是已登录的用户，应该去调api，但是网易把我的号风控了，所以只做了游客登录……
  List<SongModel> _recentSongs = []; // 最近播放歌曲-缓存中，游客的最近播放歌曲，

  final _player = Get.find<PlayerService>();

  @override
  void initState() {
    super.initState();
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    _isLoggedIn = await UserStorage.isLoggedIn();
    _isGuest = await UserStorage.isGuest();
    setState(() {});
  }

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
                Container(
                  width: media.width * 0.3,
                  height: media.width * 0.3,
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(media.width * 0.15),
                  ),
                  child: _isGuest
                      ? Icon(
                          Icons.person,
                          size: media.width * 0.15,
                          color: AppColors.textHint,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(
                            media.width * 0.15,
                          ),
                          child: Image.asset(
                            "assets/images/ar_4.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(height: 5),
                Text(
                  _isGuest ? "游客" : "pikko233",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _isGuest ? "未登录账号" : "音乐爱好者 • Lv6",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                if (_isGuest) ...[
                  ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.auth),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAuth,
                      overlayColor: Colors.white.withValues(alpha: 0.2),
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '登录账号，解锁完整功能',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ] else ...[
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
                          _statItem("247", "收藏"),
                          VerticalDivider(
                            width: 0.5,
                            thickness: 0.5,
                            color: AppColors.textPrimary.withValues(alpha: 0.1),
                          ),
                          _statItem("38", "关注"),
                          VerticalDivider(
                            width: 0.5,
                            thickness: 0.5,
                            color: AppColors.textPrimary.withValues(alpha: 0.1),
                          ),
                          _statItem("12", "粉丝"),
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
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return SearchPlaylistCell(
                        image: "assets/images/ar_2.png",
                        title: "我喜欢的音乐",
                        subtitle: "247 首歌曲",
                        onPressed: () => Get.toNamed(AppRoutes.playlistDetail),
                        onPressedPlay: () {},
                      );
                    },
                  ),
                ],
                SectionTitle(
                  title: "最近播放",
                  showMore: true,
                  showMoreLabel: "全部",
                  onPressed: () {
                    Get.toNamed(AppRoutes.recentPlay);
                  },
                ),
                Obx(() {
                  if (_player.recentSongs.isEmpty)
                    return const SizedBox.shrink();
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: _player.recentSongs.take(3).length,
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 收藏、粉丝、关注 - 小部件封装
  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
