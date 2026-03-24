// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_music_app/models/playlist_detail_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:get/get.dart';
import 'package:flutter_music_app/repositories/playlist_detail_repository.dart';

class PlaylistDetailViewmodel extends GetxController {
  final int id; // 歌单ID
  final int limit; // 条数
  int offset; // 页数
  PlaylistDetailViewmodel({required this.id, this.limit = 20, this.offset = 0});
  final playlistDetail = Rxn<PlaylistDetailModel>(); // 歌单详情信息
  final songList = <SongModel>[].obs; // 歌单内的所有歌曲

  @override
  void onInit() {
    super.onInit();
    getPlaylistDetail(id);
    getSongsInPlaylist(id);
  }

  // 获取歌单详情
  Future<void> getPlaylistDetail(int id) async {
    try {
      final res = await PlaylistDetailRepository.getPlaylistDetail(id);
      playlistDetail.value = res;
      print("歌单详情：$res");
    } catch (e) {
      print(e);
    }
  }

  // 获取歌单内的歌曲
  Future<void> getSongsInPlaylist(int id) async {
    try {
      final res = await PlaylistDetailRepository.getSongsInPlaylist(
        id,
        limit: limit,
        offset: offset,
      );
      print("获取歌单内的歌曲：$res");
      songList.value = res;
    } catch (e) {
      print(e);
    }
  }
}
