import 'package:flutter_music_app/models/high_quality_playlist_model.dart';
import 'package:flutter_music_app/models/recommend_playlist_model.dart';
import 'package:flutter_music_app/models/toplist_model.dart';
import 'package:flutter_music_app/repositories/playlist_repository.dart';
import 'package:get/get.dart';

class HomeViewmodel extends GetxController {
  final isLoading = false.obs; // 是否加载中
  final recommendPlaylist = <RecommendPlaylistModel>[].obs; // 推荐歌单列表
  final highQualityPlaylist = <HighQualityPlaylistModel>[].obs; // 精品歌单列表
  final toplist = <ToplistModel>[].obs; // 排行榜列表

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      Future.wait([
        _getRecommendPlaylist(),
        _getHighQualityPlaylist(0, limit: 30),
        _getToplist(),
      ]);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 获取推荐歌单
  Future<void> _getRecommendPlaylist() async {
    final res = await PlaylistRepository.getRecommendPlaylist(limit: 30);
    recommendPlaylist.value = res;
  }

  // 获取精品歌单
  Future<void> _getHighQualityPlaylist(
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

  // 获取所有榜单（排行榜）
  Future<void> _getToplist() async {
    final res = await PlaylistRepository.getToplist();
    toplist.value = res;
  }
}
