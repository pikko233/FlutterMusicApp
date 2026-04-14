import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/repositories/artist_repository.dart';
import 'package:get/get.dart';

class ArtistSongsViewmodel extends GetxController {
  final int id;
  ArtistSongsViewmodel({required this.id});
  final isLoading = false.obs;
  final songs = <SongModel>[].obs; // 歌曲列表
  final songTotalCount = 0.obs; // 歌曲总数
  final _order = 'hot'.obs; // 请求参数 - hot/time
  final _limit = 50.obs; //

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      await Future.wait([_getArtistSongs()]);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 获取歌手的全部歌曲 - 首页加载
  Future<void> _getArtistSongs() async {
    final res = await ArtistRepository.getArtistSongs(
      id,
      order: _order.value,
      limit: _limit.value,
      offset: 0,
    );
    songs.value = (res['songs'] as List)
        .map((e) => SongModel.fromArtistSongsMap(e))
        .toList();
    songTotalCount.value = res['total'];
  }

  // 获取歌手的全部歌曲 - 触底加载
  Future<void> getMoreArtistSongs() async {
    if (songs.length >= songTotalCount.value) return;
    final res = await ArtistRepository.getArtistSongs(
      id,
      order: _order.value,
      limit: _limit.value,
      offset: songs.length,
    );
    songs.addAll(
      (res['songs'] as List)
          .map((e) => SongModel.fromArtistSongsMap(e))
          .toList(),
    );
  }
}
