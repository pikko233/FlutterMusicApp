import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.bgPrimary,
          title: Row(
            children: [
              Text(
                "搜索",
                style: TextStyle(color: AppColors.textPrimary, fontSize: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  onSubmitted: (value) {
                    print(value);
                  },
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: "搜索音乐、视频、博客、歌词",
                    hintStyle: TextStyle(color: AppColors.textHint),
                    filled: true,
                    fillColor: AppColors.bgCard,
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
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.menu),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.6,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/images/ar_2.png",
                      width: double.maxFinite,
                      height: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(8),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         colors: [
                  //           Colors.transparent,
                  //           AppColors.bgCard.withValues(alpha: 0.6),
                  //           AppColors.bgCard,
                  //         ],
                  //         begin: Alignment.centerLeft,
                  //         end: Alignment.centerRight,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "漫游",
                        style: TextStyle(
                          color: AppColors.textPrimary80,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "多样频道无限畅听",
                        style: TextStyle(
                          color: AppColors.textPrimary40,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
