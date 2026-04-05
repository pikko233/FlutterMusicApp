// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_music_app/models/playlist_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:get/get.dart';
import 'package:flutter_music_app/repositories/playlist_repository.dart';

class PlaylistDetailViewmodel extends GetxController {
  final int id; // 歌单ID
  PlaylistDetailViewmodel({required this.id});
  final offset = 0.obs; // 页码
  final limit = 50.obs; // 每一页加载的歌曲数量
  bool get hasMore =>
      songList.length < (playlistDetail.value?.trackCount ?? 0); // 是否还有更多歌曲未加载
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
      await Future.wait([
        _getPlaylistDetail(id),
        _getPlaylistSongs(id, limit: limit.value, offset: offset.value),
      ]);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore) return;
    try {
      isLoading.value = true;
      await _getNextPlaylistSongs();
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

  // 获取歌单内的歌曲
  // 必选参数 : id : 歌单 id
  // 可选参数 : limit : 限制获取歌曲的数量，默认值为当前歌单的歌曲数量
  // 可选参数 : offset : 默认值为0
  // 接口地址 : /playlist/track/all
  // 调用例子 : /playlist/track/all?id=24381616&limit=10&offset=1
  // 注：关于offset，你可以这样理解，假设你当前的歌单有200首歌
  // 你传入limit=50&offset=0等价于limit=50，你会得到第1-50首歌曲
  // 你传入limit=50&offset=50，你会得到第51-100首歌曲
  // 如果你设置limit=50&offset=100，你就会得到第101-150首歌曲
  Future<void> _getPlaylistSongs(int id, {int? limit, int offset = 0}) async {
    final res = await PlaylistRepository.getSongsInPlaylist(
      id,
      limit: limit,
      offset: offset,
    );
    songList.value = res;
  }

  Future<void> _getNextPlaylistSongs() async {
    offset.value += limit.value;
    final res = await PlaylistRepository.getSongsInPlaylist(
      id,
      limit: limit.value,
      offset: offset.value,
    );
    songList.addAll(res);
  }
}
