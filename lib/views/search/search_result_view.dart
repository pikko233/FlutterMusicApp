import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/utils/debounce_util.dart';
import 'package:flutter_music_app/viewmodels/search_result_viewmodel.dart';
import 'package:flutter_music_app/viewmodels/search_viewmodel.dart';
import 'package:flutter_music_app/views/search/tabViews/search_playlist_list.dart';
import 'package:flutter_music_app/widgets/mini_player.dart';
import 'package:flutter_music_app/views/search/tabViews/search_album_list.dart';
import 'package:flutter_music_app/views/search/tabViews/search_singer_list.dart';
import 'package:flutter_music_app/views/search/tabViews/search_song_list.dart';
import 'package:flutter_music_app/widgets/search_suggestion.dart';
import 'package:flutter_music_app/widgets/search_text_field.dart';
import 'package:get/get.dart';

class SearchResultView extends StatefulWidget {
  const SearchResultView({super.key});

  @override
  State<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView>
    with TickerProviderStateMixin {
  final TextEditingController _searchController =
      TextEditingController(); // 搜索框控制器
  late TabController _tabController;
  final _searchResultVM = Get.put(SearchResultViewmodel());
  final _searchVM = Get.find<SearchViewmodel>();
  bool _showSuggestions = false; // 是否显示搜索建议
  final _focusNode = FocusNode();
  final _debounceUtil = DebounceUtil();

  // 参数type对应tab的映射
  final Map<int, int> _typeMap = {
    0: 1, // 1-歌曲
    1: 10, // 2-专辑
    2: 100, // 3-歌手
    3: 1000, // 4-歌单
  };

  List<Widget> get _tabs {
    return const [
      Tab(text: "歌曲"),
      Tab(text: "专辑"),
      Tab(text: "歌手"),
      Tab(text: "歌单"),
    ];
  }

  List<Widget> get _tabViews {
    return [
      const SearchSongList(), // 歌曲页
      const SearchAlbumList(), // 专辑页
      const SearchSingerList(), // 歌手页
      const SearchPlaylistList(), // 歌单页
    ];
  }

  // 取消按钮
  void _cancelSearch() {
    _searchController.text = '';
    _focusNode.unfocus();
    _searchVM.searchSuggest.value = [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = Get.arguments['keywords'] ?? '';
    _searchVM.getSearchSuggest(_searchController.text);
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
    ); // 初始化tabController
    _search(); // 获取搜索结果

    // 监听搜索框是否失焦
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

    // 监听tab切换
    _tabController.addListener(() {
      if (_tabController.indexIsChanging && _searchController.text.isNotEmpty) {
        _search();
      }
    });
  }

  // 发送搜索请求，获取搜索结果
  void _search() {
    switch (_tabController.index) {
      case 0:
        // 加载歌曲的搜索结果
        _searchResultVM.getSearchResult(_searchController.text, type: 1);
        break;
      case 1:
        // 加载专辑的搜索结果
        _searchResultVM.getSearchResult(_searchController.text, type: 10);
        break;
      case 2:
        // 加载歌手的搜索结果
        _searchResultVM.getSearchResult(_searchController.text, type: 100);
        break;
      case 3:
        // 加载歌单的搜索结果
        _searchResultVM.getSearchResult(_searchController.text, type: 1000);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChange(String value) {
    // 搜索关键字变化
    // 防抖处理
    _debounceUtil.debounce(() async => await _searchVM.getSearchSuggest(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgCard,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        title: SearchTextField(
          controller: _searchController,
          hintText: "想听点啥～",
          focusNode: _focusNode,
          onChanged: _onSearchChange,
          onSubmitted: (word) {
            if (word.trim() != '') {
              _focusNode.unfocus();
              _search();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _cancelSearch();
            },
            child: Text(
              "取消",
              style: TextStyle(color: AppColors.textHint, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.bgPrimary, AppColors.bgCard],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Stack(
            children: [
              Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // tabs: 歌曲、歌手、专辑、歌单、视频
                        Container(
                          height: kToolbarHeight - 10,
                          color: AppColors.bgCard,
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            indicator: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            labelColor: AppColors.textPrimary,
                            unselectedLabelColor: AppColors.textHint,
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            tabs: _tabs,
                          ),
                        ),
                        // tabBarViews
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: _tabViews,
                          ),
                        ),
                      ],
                    ),
                    // mini player: 迷你播放器
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: MiniPlayer(),
                    ),
                  ],
                ),
              ),
              // Dart的&&是短路运算，
              // 如果当 _showSuggestions 为 false 时,后面的 _searchVM.searchSuggest.isNotEmpty 根本不会执行,
              // 于是 Obx 在这一帧内没有访问到任何 Rx 变量,就会抛出 "improper use of a GetX" 错误。
              // 显示搜索建议
              Obx(() {
                final hasSuggestions = _searchVM
                    .searchSuggest
                    .isNotEmpty; // 解决方法：把 Rx 的读取放到前面,确保每次都会被访问:
                if (!_showSuggestions || !hasSuggestions) {
                  return const SizedBox.shrink();
                }
                return SearchSuggestion(
                  top: 0,
                  suggestions: _searchVM.searchSuggest,
                  onPressed: (word) {
                    _focusNode.unfocus();
                    _searchController.text = word;
                    _search();
                  },
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight * 0.5,
        color: Colors.black,
      ),
    );
  }
}
