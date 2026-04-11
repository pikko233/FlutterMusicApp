import 'package:flutter_music_app/models/album_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/repositories/album_repository.dart';
import 'package:get/get.dart';

class AlbumDetailViewmodel extends GetxController {
  final int id;
  AlbumDetailViewmodel({required this.id});
  final album = Rxn<AlbumModel>(); // 专辑详情信息
  final songs = <SongModel>[].obs; // 专辑中的歌曲列表
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      await Future.wait([_getAlbumDetail(id)]);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 获取专辑详情
  Future<void> _getAlbumDetail(int id) async {
    final res = await AlbumRepository.getAlbumDetail(id);
    album.value = AlbumModel.fromMap(res['album'] as Map<String, dynamic>);
    final albumPicUrl = res['album']['picUrl'] as String;
    songs.value = (res['songs'] as List)
        .map((e) => SongModel.fromAlbumDetailMap(e, albumPicUrl))
        .toList();
  }
}
