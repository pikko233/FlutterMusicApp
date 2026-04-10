import 'package:flutter/material.dart';
import 'package:flutter_music_app/utils/debounce_util.dart';
import 'package:flutter_music_app/viewmodels/search_result_viewmodel.dart';
import 'package:flutter_music_app/widgets/load_more_icon.dart';
import 'package:flutter_music_app/widgets/search_album_cell.dart';
import 'package:flutter_music_app/widgets/search_result_count.dart';
import 'package:get/get.dart';

class SearchAlbumList extends StatefulWidget {
  const SearchAlbumList({super.key});

  @override
  State<SearchAlbumList> createState() => _SearchAlbumListState();
}

class _SearchAlbumListState extends State<SearchAlbumList> {
  final _searchResultVM = Get.find<SearchResultViewmodel>();
  final _scrollController = ScrollController();
  final _debounceUtil = DebounceUtil();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _debounceUtil.debounce(() => _searchResultVM.loadMoreAlbums());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_searchResultVM.albums.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }
      return CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 搜索结果数量
          SliverToBoxAdapter(
            child: SearchResultCount(
              count: _searchResultVM.albumTotalCount.value,
              label: "张相关专辑",
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 0,
              left: 20,
              right: 20,
              bottom: 0,
            ),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.8,
              ),
              itemCount: _searchResultVM.albums.length,
              itemBuilder: (context, index) {
                final item = _searchResultVM.albums[index];
                return SearchAlbumCell(
                  image: item.picUrl,
                  title: item.name,
                  subtitle:
                      "${item.artistsName} • ${DateTime.fromMillisecondsSinceEpoch(item.publishTime).year} • ${item.size}首",
                  onPressed: () {
                    print("点击了专辑: $index");
                  },
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: LoadMoreIcon(
              hasMore:
                  _searchResultVM.albums.length <
                  _searchResultVM.albumTotalCount.value,
            ),
          ),
        ],
      );
    });
  }
}
