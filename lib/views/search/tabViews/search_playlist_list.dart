import 'package:flutter/material.dart';
import 'package:flutter_music_app/widgets/search_playlist_cell.dart';
import 'package:flutter_music_app/widgets/search_result_count.dart';
import 'package:flutter_music_app/widgets/search_singer_cell.dart';

class SearchPlaylistList extends StatelessWidget {
  const SearchPlaylistList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 搜索结果数量
        SliverToBoxAdapter(
          child: const SearchResultCount(count: 36, label: "位相关歌手"),
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
              return SearchPlaylistCell(
                image: "assets/images/ar_4.png",
                title: "周杰伦精选 • 最强华语",
                subtitle: "286首 • 播放量1.2亿",
                onPressed: () {
                  print("跳转至歌单详情页");
                },
                onPressedPlay: () {
                  print("播放歌单的第一首歌，并将歌单列表替换为当前播放列表");
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
