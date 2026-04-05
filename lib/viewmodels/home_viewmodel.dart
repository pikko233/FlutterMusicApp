import 'package:flutter_music_app/models/high_quality_playlist_model.dart';
import 'package:flutter_music_app/models/recommend_playlist_model.dart';
import 'package:flutter_music_app/repositories/playlist_repository.dart';
import 'package:get/get.dart';

class HomeViewmodel extends GetxController {
  final isLoading = false.obs; // 是否加载中
  final recommendPlaylist = <RecommendPlaylistModel>[].obs; // 推荐歌单列表
  final highQualityPlaylist = <HighQualityPlaylistModel>[].obs; // 精品歌单列表

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      Future.wait([
        getRecommendPlaylist(),
        getHighQualityTags(),
        getHighQualityPlaylist(0),
      ]);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 获取推荐歌单
  Future<void> getRecommendPlaylist() async {
    final res = await PlaylistRepository.getRecommendPlaylist(limit: 30);
    recommendPlaylist.value = res;
  }

  // 获取精品歌单标签
  Future<void> getHighQualityTags() async {
    final res = await PlaylistRepository.getHighQualityTags();
    print('精品标签: $res');
  }

  // 获取精品歌单
  Future<void> getHighQualityPlaylist(
    int before, {
    String? cat,
    int limit = 50,
  }) async {
    final res = await PlaylistRepository.getHighQualityPlaylist(
      before,
      cat: cat,
      limit: limit,
    );
    highQualityPlaylist.value = res;
  }
}
