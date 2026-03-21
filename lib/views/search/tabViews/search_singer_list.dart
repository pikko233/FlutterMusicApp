import 'package:flutter/material.dart';
import 'package:flutter_music_app/widgets/search_result_count.dart';
import 'package:flutter_music_app/widgets/search_singer_cell.dart';

class SearchSingerList extends StatelessWidget {
  const SearchSingerList({super.key});

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
              return SearchSingerCell(
                isSubscribed: index == 0 ? true : false,
                image: "assets/images/ar_4.png",
                title: "周杰伦",
                subtitle: "歌手 • 1284首歌曲",
                onPressed: () {},
                onPressedSub: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
