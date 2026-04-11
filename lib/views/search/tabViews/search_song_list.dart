import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:flutter_music_app/utils/debounce_util.dart';
import 'package:flutter_music_app/utils/time_util.dart';
import 'package:flutter_music_app/viewmodels/search_result_viewmodel.dart';
import 'package:flutter_music_app/widgets/load_more_icon.dart';
import 'package:flutter_music_app/widgets/search_result_count.dart';
import 'package:flutter_music_app/widgets/search_song_cell.dart';
import 'package:get/get.dart';

class SearchSongList extends StatefulWidget {
  const SearchSongList({super.key});

  @override
  State<SearchSongList> createState() => _SearchSongListState();
}

class _SearchSongListState extends State<SearchSongList> {
  final _searchResultVM = Get.find<SearchResultViewmodel>();
  final _player = Get.find<PlayerService>();
  final _scrollController = ScrollController();
  final _debounce = DebounceUtil();

  @override
  void initState() {
    super.initState();

    // 监听页面滚动触底
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _debounce.debounce(() => _searchResultVM.loadMoreSongs());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_searchResultVM.songs.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }
      // 在 itemBuilder 外读取，让 Obx 追踪到此变量，currentSongId 变化时整个列表才会重建
      final currentSongId = _player.currentSongId.value;
      return CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 搜索结果数量
          SliverToBoxAdapter(
            child: SearchResultCount(
              count: _searchResultVM.songTotalCount.value,
              label: "首相关歌曲",
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 0,
              left: 20,
              right: 20,
              bottom: 0,
            ),
            sliver: SliverList.separated(
              itemCount: _searchResultVM.songs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _searchResultVM.songs[index];
                return SearchSongCell(
                  isPlaying: item.id == currentSongId,
                  song: item,
                  // image: item.picUrl,
                  // title: item.name,
                  // subtitle:
                  //     "${item.singersName} - ${item.al.name} • ${TimeUtil.formatDuration(Duration(milliseconds: item.dt))}",
                  onPressedPlay: () async {
                    final res = await _player.checkSong(item.id);
                    if (!res) {
                      return;
                    }
                    _player.playSong(
                      item.id,
                      _searchResultVM.songs,
                      _searchResultVM.songTotalCount.value,
                      _searchResultVM.loadMoreSongsForPlayer,
                    );
                    Get.toNamed(AppRoutes.playerScreen);
                  },
                );
              },
            ),
          ),
          // 加载更多图标
          SliverToBoxAdapter(
            child: Obx(
              () => LoadMoreIcon(
                hasMore:
                    _searchResultVM.songs.length <
                    _searchResultVM.songTotalCount.value,
              ),
            ),
          ),
        ],
      );
    });
  }
}
