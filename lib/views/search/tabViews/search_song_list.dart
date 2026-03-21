import 'package:flutter/material.dart';
import 'package:flutter_music_app/widgets/search_result_count.dart';
import 'package:flutter_music_app/widgets/search_song_cell.dart';

class SearchSongList extends StatefulWidget {
  const SearchSongList({super.key});

  @override
  State<SearchSongList> createState() => _SearchSongListState();
}

class _SearchSongListState extends State<SearchSongList> {
  int _isPlayingIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 搜索结果数量
        SliverToBoxAdapter(
          child: const SearchResultCount(count: 1284, label: "首相关歌曲"),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            top: 0,
            left: 20,
            right: 20,
            bottom: 80,
          ),
          sliver: SliverList.separated(
            itemCount: 10,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return SearchSongCell(
                isPlaying: index == _isPlayingIndex,
                image: "assets/images/ar_4.png",
                title: "晴天",
                subtitle: "周杰伦 • 叶惠美 • 4:23",
                onPressedPlay: () {
                  setState(() {
                    _isPlayingIndex = index;
                  });
                },
                onPressedMore: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
