import 'package:flutter/material.dart';
import 'package:flutter_music_app/widgets/search_album_cell.dart';
import 'package:flutter_music_app/widgets/search_result_count.dart';

class SearchAlbumList extends StatelessWidget {
  const SearchAlbumList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 搜索结果数量
        SliverToBoxAdapter(
          child: const SearchResultCount(count: 12, label: "张相关专辑"),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            top: 0,
            left: 20,
            right: 20,
            bottom: 80,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.8,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return SearchAlbumCell(
                image: "assets/images/ar_2.png",
                title: "叶惠美",
                subtitle: "周杰伦 • 2003 • 10首",
                onPressed: () {
                  print("点击了专辑: $index");
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
