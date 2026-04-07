import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/viewmodels/search_viewmodel.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';
import 'package:get/get.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchVM = Get.put(SearchViewmodel());
  bool _showSuggestions = false; // 是否显示搜索建议
  final _focusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      // 搜索框失去焦点时隐藏列表
      if (!_focusNode.hasFocus) {
        setState(() {
          _showSuggestions = false;
        });
      } else {
        setState(() {
          _showSuggestions = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onSearchChange(String value) {
    // 搜索关键字变化
    // 防抖处理
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      await _searchVM.getSearchSuggest(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 搜索建议栏距离顶部的高度
    final suggestBarTop =
        kToolbarHeight * 1.2 + MediaQuery.paddingOf(context).top;
    return Obx(
      () => Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.bgCard,
                elevation: 0,
                scrolledUnderElevation: 0,
                title: TextField(
                  onChanged: _onSearchChange,
                  onSubmitted: (value) {
                    print('搜索框输入: $value');
                    if (value.trim() != '') {
                      Get.toNamed(
                        AppRoutes.searchResult,
                        arguments: {'keywords': value},
                      );
                    }
                  },
                  focusNode: _focusNode,
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0),
                    hintText: "搜索音乐、专辑、歌手、歌单",
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
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 20,
                    right: 20,
                    bottom: 80,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 热搜榜
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "热搜榜",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _searchVM.searchHot.isEmpty
                              ? const SizedBox(
                                  height: 600,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 15,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 3.9,
                                      ),
                                  itemCount: _searchVM.searchHot.length,
                                  itemBuilder: (context, index) {
                                    final item = _searchVM.searchHot[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          AppRoutes.searchResult,
                                          arguments: {
                                            'keywords': item.searchWord,
                                          },
                                        );
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 26,
                                            child: Text(
                                              "${index + 1}",
                                              style: TextStyle(
                                                color: index == 0
                                                    ? Color(0xFFF04444)
                                                    : index == 1
                                                    ? Color(0xFFFDA309)
                                                    : Color(0xFFA1A8B4),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        item.searchWord,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .textPrimary80,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    item.iconUrl == null ||
                                                            item.iconUrl == ''
                                                        ? const SizedBox.shrink()
                                                        : NeteaseImage(
                                                            url: item.iconUrl!,
                                                            width: 20,
                                                            height: 12,
                                                            fit: BoxFit.contain,
                                                          ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${item.score}',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "分类浏览",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 分类浏览
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.6,
                        ),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Stack(
                            alignment: Alignment.bottomLeft,
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
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black87,
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8.0,
                                  left: 8.0,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "漫游",
                                      style: TextStyle(
                                        color: AppColors.textPrimary80,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "多样频道无限畅听",
                                      style: TextStyle(
                                        color: AppColors.textPrimary60,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // 搜索建议
          _showSuggestions && _searchVM.searchSuggest.isNotEmpty
              ? Positioned(
                  top: suggestBarTop,
                  left: 10,
                  right: 10,
                  child: Material(
                    elevation: 8,
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 280),
                      child: ListView.builder(
                        itemCount: _searchVM.searchSuggest.length,
                        itemBuilder: (context, index) {
                          final word = _searchVM.searchSuggest[index];
                          return ListTile(
                            leading: Icon(
                              Icons.search,
                              color: AppColors.textHint,
                              size: 18,
                            ),
                            title: Text(
                              word,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: AppColors.textPrimary80),
                            ),
                            onTap: () {
                              _focusNode.unfocus();
                              Get.toNamed(
                                AppRoutes.searchResult,
                                arguments: {'keywords': word},
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
