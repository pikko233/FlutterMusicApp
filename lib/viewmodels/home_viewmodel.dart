import 'package:flutter_music_app/models/recommend_playlist_model.dart';
import 'package:flutter_music_app/repositories/playlist_repository.dart';
import 'package:get/get.dart';

class HomeViewmodel extends GetxController {
  final recommendPlaylist = <RecommendPlaylistModel>[].obs; // 推荐歌单
  final isLoading = false.obs; // 是否加载中

  @override
  void onInit() {
    super.onInit();
    getRecommendPlaylist();
  }

  Future<void> getRecommendPlaylist() async {
    try {
      isLoading.value = true;
      final res = await PlaylistRepository.getRecommendPlaylist(limit: 30);
      recommendPlaylist.value = res;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
