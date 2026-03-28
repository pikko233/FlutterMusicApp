// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_music_app/models/playlist_model.dart';
import 'package:flutter_music_app/models/playlist_song_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:get/get.dart';
import 'package:flutter_music_app/repositories/playlist_repository.dart';

class PlaylistDetailViewmodel extends GetxController {
  final int id; // 歌单ID
  PlaylistDetailViewmodel({required this.id});
  final isLoading = false.obs; // 首次加载
  final playlistDetail = Rxn<PlaylistModel>(); // 歌单详情信息
  final songList = <SongModel>[].obs; // 歌单内的所有歌曲

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      await Future.wait([_getPlaylistDetail(id), _getAllSongsInPlaylist(id)]);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 获取歌单详情
  Future<void> _getPlaylistDetail(int id) async {
    final res = await PlaylistRepository.getPlaylistDetail(id);
    playlistDetail.value = res;
  }

  // 获取歌单内的所有歌曲
  Future<void> _getAllSongsInPlaylist(int id) async {
    final res = await PlaylistRepository.getSongsInPlaylist(id);
    songList.value = res;
  }
}
