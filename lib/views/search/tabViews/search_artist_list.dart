import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/utils/debounce_util.dart';
import 'package:flutter_music_app/viewmodels/search_result_viewmodel.dart';
import 'package:flutter_music_app/widgets/load_more_icon.dart';
import 'package:flutter_music_app/widgets/search_result_count.dart';
import 'package:flutter_music_app/widgets/search_artist_cell.dart';
import 'package:get/get.dart';

class SearchArtistList extends StatefulWidget {
  const SearchArtistList({super.key});

  @override
  State<SearchArtistList> createState() => _SearchArtistListState();
}

class _SearchArtistListState extends State<SearchArtistList> {
  final _searchResultVM = Get.find<SearchResultViewmodel>();
  final _scrollController = ScrollController();
  final _debounceUtil = DebounceUtil();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _debounceUtil.debounce(
          () async => await _searchResultVM.loadMoreArtists(),
        );
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
      if (_searchResultVM.artists.isEmpty) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Center(child: Text('暂无相关歌手')),
        );
      }
      final artists = _searchResultVM.artists;
      final artistTotalCount = _searchResultVM.artistTotalCount.value;
      return CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 搜索结果数量
          SliverToBoxAdapter(
            child: SearchResultCount(count: artistTotalCount, label: "位相关歌手"),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 0,
              left: 20,
              right: 20,
              bottom: 0,
            ),
            sliver: SliverList.separated(
              itemCount: artists.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = artists[index];
                return SearchArtistCell(
                  followed: item.followed,
                  image: item.img1v1Url,
                  title: item.name,
                  subtitle: "${item.musicSize}首歌曲",
                  onPressed: () {
                    Get.toNamed(AppRoutes.singerDetail);
                  },
                  onPressedSub: () {
                    print('点击关注歌手');
                  },
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: LoadMoreIcon(hasMore: artists.length < artistTotalCount),
          ),
        ],
      );
    });
  }
}
