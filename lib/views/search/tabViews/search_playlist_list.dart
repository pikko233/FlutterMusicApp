import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/repositories/playlist_repository.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:flutter_music_app/utils/count_util.dart';
import 'package:flutter_music_app/utils/debounce_util.dart';
import 'package:flutter_music_app/viewmodels/search_result_viewmodel.dart';
import 'package:flutter_music_app/widgets/load_more_icon.dart';
import 'package:flutter_music_app/widgets/search_playlist_cell.dart';
import 'package:flutter_music_app/widgets/search_result_count.dart';
import 'package:get/get.dart';

class SearchPlaylistList extends StatefulWidget {
  const SearchPlaylistList({super.key});

  @override
  State<SearchPlaylistList> createState() => _SearchPlaylistListState();
}

class _SearchPlaylistListState extends State<SearchPlaylistList> {
  final _searchResultVM = Get.find<SearchResultViewmodel>();
  final _player = Get.find<PlayerService>();
  final _scrollController = ScrollController();
  final _debounceUtil = DebounceUtil();

  @override
  void initState() {
    super.initState();

    // 监听页面滚动
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        // 页面触底加载歌单下一页数据
        _debounceUtil.debounce(() => _searchResultVM.loadMorePlaylists());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_searchResultVM.isLoading.value) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (_searchResultVM.playlists.isEmpty) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Center(child: Text('暂无相关歌单')),
        );
      }
      return CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 搜索结果数量
          SliverToBoxAdapter(
            child: SearchResultCount(
              count: _searchResultVM.playlistTotalCount.value,
              label: "位相关歌单",
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
              itemCount: _searchResultVM.playlists.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _searchResultVM.playlists[index];
                return SearchPlaylistCell(
                  image: item.coverImgUrl,
                  title: item.name,
                  subtitle:
                      "${item.trackCount}首 • 播放量${CountUtil.formatCount(item.playCount)}",
                  onPressed: () {
                    Get.toNamed(
                      AppRoutes.playlistDetail,
                      arguments: {'id': item.id},
                    );
                  },
                  onPressedPlay: () async {
                    final songs = await PlaylistRepository.getSongsInPlaylist(
                      item.id,
                    );
                    await _player.playSong(
                      songs[0].id,
                      songs,
                      _searchResultVM.playlistTotalCount.value,
                      (offset) => PlaylistRepository.getSongsInPlaylist(
                        item.id,
                        limit: 50,
                        offset: offset,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: LoadMoreIcon(
              hasMore:
                  _searchResultVM.playlists.length <
                  _searchResultVM.playlistTotalCount.value,
            ),
          ),
        ],
      );
    });
  }
}
