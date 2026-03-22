import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/views/search/tabViews/search_playlist_list.dart';
import 'package:flutter_music_app/widgets/mini_player.dart';
import 'package:flutter_music_app/views/search/tabViews/search_album_list.dart';
import 'package:flutter_music_app/views/search/tabViews/search_singer_list.dart';
import 'package:flutter_music_app/widgets/search_song_cell.dart';
import 'package:flutter_music_app/views/search/tabViews/search_song_list.dart';
import 'package:get/get.dart';

class SearchResultView extends StatefulWidget {
  const SearchResultView({super.key});

  @override
  State<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView>
    with TickerProviderStateMixin {
  late String _keyword; // 从上个页面带来的搜索参数
  final TextEditingController _searchController =
      TextEditingController(); // 搜索框控制器
  late TabController _tabController;
  var _isPlayingIndex = 0;

  List<Widget> get _tabs {
    return const [
      Tab(text: "歌曲"),
      Tab(text: "歌手"),
      Tab(text: "专辑"),
      Tab(text: "歌单"),
    ];
  }

  List<Widget> get _tabViews {
    return [
      const SearchSongList(), // 歌曲tabView
      const SearchSingerList(), // 歌手tabView
      const SearchAlbumList(), // 专辑tabView
      const SearchPlaylistList(), // 歌单tabView
    ];
  }

  // 取消搜索
  void _cancelSearch() {
    _searchController.text = '';
  }

  @override
  void initState() {
    super.initState();
    _keyword = Get.arguments['keyword'] ?? '';
    _searchController.text = _keyword;
    _tabController = TabController(length: _tabs.length, vsync: this);
    print('上一个页面带来的搜索参数: $_keyword');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgCard,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            hintText: "想听点啥～",
            hintStyle: TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.bgPrimary.withValues(alpha: 0.3),
            prefixIcon: Icon(Icons.search, color: AppColors.textHint),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _cancelSearch();
              setState(() {});
            },
            child: Text(
              "取消",
              style: TextStyle(color: AppColors.textHint, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.bgPrimary, AppColors.bgCard],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // tabs: 歌曲、歌手、专辑、歌单、视频
                    Container(
                      height: kToolbarHeight - 10,
                      color: AppColors.bgCard,
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        indicator: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: AppColors.textPrimary,
                        unselectedLabelColor: AppColors.textHint,
                        labelStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        tabs: _tabs,
                      ),
                    ),
                    // tabBarViews
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: _tabViews,
                      ),
                    ),
                  ],
                ),
                // mini player: 迷你播放器
                Positioned(left: 0, right: 0, bottom: 0, child: MiniPlayer()),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight * 0.5,
        color: Colors.black,
      ),
    );
  }
}
