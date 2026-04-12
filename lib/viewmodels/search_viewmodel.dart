import 'package:flutter_music_app/models/search_hot_model.dart';
import 'package:flutter_music_app/repositories/search_repository.dart';
import 'package:get/get.dart';

class SearchViewmodel extends GetxController {
  final isLoading = false.obs; // 是否正在加载中
  final searchHot = <SearchHotModel>[].obs; // 热搜列表
  final searchSuggest = <String>[].obs; // 搜索建议

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      await Future.wait([_getSearchHot()]);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = true;
    }
  }

  // 获取热搜列表
  Future<void> _getSearchHot() async {
    final res = await SearchRepository.getSearchHot();
    searchHot.value = res;
  }

  // 获取搜索建议
  Future<void> getSearchSuggest(
    String keywords, {
    String type = 'mobile',
  }) async {
    if (keywords.isEmpty) {
      searchSuggest.value = [];
      return;
    }
    final res = await SearchRepository.getSearchSuggest(keywords, type: type);
    searchSuggest.value = res.length > 10 ? res.sublist(0, 10) : res;
  }
}
