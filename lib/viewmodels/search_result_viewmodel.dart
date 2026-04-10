import 'package:flutter_music_app/models/album_model.dart';
import 'package:flutter_music_app/models/playlist_model.dart';
import 'package:flutter_music_app/models/song_model.dart' hide AlbumModel;
import 'package:flutter_music_app/repositories/search_repository.dart';
import 'package:get/state_manager.dart';

class SearchResultViewmodel extends GetxController {
  final isLoading = false.obs; // 是否正在加载中

  // 搜索结果
  final songs = <SongModel>[].obs; // 歌曲列表
  final songTotalCount = 0.obs; // 歌曲总数
  final playlists = <PlaylistModel>[].obs; // 歌单列表
  final playlistTotalCount = 0.obs; // 歌单总数
  final albums = <AlbumModel>[].obs; // 专辑列表
  final albumTotalCount = 0.obs;
  final artists = [].obs; // 歌手列表
  final int _limit = 30; // 每页数量

  String currentKeywords = ''; // 当前搜索关键词，用于分页加载

  // 为播放器提供的分页加载回调：加载搜索结果歌曲的下一页
  Future<List<SongModel>> loadMoreSongsForPlayer(int offset) async {
    if (songs.length >= songTotalCount.value) {
      return [];
    }
    final res = await SearchRepository.getSearchResult(
      currentKeywords,
      limit: _limit,
      offset: offset,
      type: 1,
    );
    final rawSongs = res['songs'];
    if (rawSongs == null) return [];
    return (rawSongs as List).map((e) => SongModel.fromType1Map(e)).toList();
  }

  // 加载搜索结果 - 歌曲的下一页
  Future<void> loadMoreSongs() async {
    if (songs.length >= songTotalCount.value) {
      return;
    }
    final res = await SearchRepository.getSearchResult(
      currentKeywords,
      limit: _limit,
      offset: songs.length,
      type: 1,
    );
    final rawSongs = res['songs'];
    if (rawSongs == null) return;
    final newSongs = (rawSongs as List)
        .map((e) => SongModel.fromType1Map(e))
        .toList();
    final remaining = songTotalCount.value - songs.length;
    songs.addAll(newSongs.take(remaining));
  }

  // 加载搜索结果 - 专辑的下一页
  Future<void> loadMoreAlbums() async {
    if (albums.length >= albumTotalCount.value) {
      return;
    }
    final res = await SearchRepository.getSearchResult(
      currentKeywords,
      limit: _limit,
      offset: albums.length,
      type: 10,
    );
    final rawAlbums = res['albums'];
    if (rawAlbums == null) return;
    final newAlbums = (rawAlbums as List)
        .map((e) => AlbumModel.fromMap(e))
        .toList();
    final remaining = albumTotalCount.value - albums.length;
    albums.addAll(newAlbums.take(remaining));
  }

  // 加载搜索结果 - 歌单的下一页
  Future<void> loadMorePlaylists() async {
    if (playlists.length >= playlistTotalCount.value) {
      return;
    }
    final res = await SearchRepository.getSearchResult(
      currentKeywords,
      limit: _limit,
      offset: playlists.length,
      type: 1000,
    );
    final rawPlaylist = res['playlists'];
    if (rawPlaylist == null) return;
    final newPlaylists = (rawPlaylist as List)
        .map((e) => PlaylistModel.fromMap(e))
        .toList();
    final remaining = playlistTotalCount.value - playlists.length;
    playlists.addAll(newPlaylists.take(remaining));
  }

  // 获取搜索结果
  Future<void> getSearchResult(
    String keywords, {
    int? limit,
    int? offset,
    int? type,
  }) async {
    if (isLoading.value) {
      return;
    }
    try {
      isLoading.value = true;
      currentKeywords = keywords;
      switch (type) {
        case 1:
          songs.value = [];
          break;
        case 10:
          albums.value = [];
          break;
        case 100:
          artists.value = [];
          break;
        case 1000:
          playlists.value = [];
          break;
        default:
          break;
      }
      final res = await SearchRepository.getSearchResult(
        keywords,
        limit: _limit,
        offset: offset,
        type: type,
      );
      if (res == null) return;
      if (type == 1) {
        // 歌曲
        songs.value = ((res['songs'] as List?) ?? [])
            .map((e) => SongModel.fromType1Map(e))
            .toList();
        songTotalCount.value = (res['songCount'] as int?) ?? 0;
      } else if (type == 10) {
        // 专辑
        print('搜索结果-专辑: $res');
        albums.value = ((res['albums'] as List?) ?? [])
            .map((e) => AlbumModel.fromMap(e))
            .toList();
        albumTotalCount.value = (res['albumCount'] as int?) ?? 0;
      } else if (type == 100) {
        // 歌手
        print('搜索结果-歌手: $res');
      } else if (type == 1000) {
        // 歌单
        playlists.value = ((res['playlists'] as List?) ?? [])
            .map((e) => PlaylistModel.fromMap(e))
            .toList();
        playlistTotalCount.value = (res['playlistCount'] as int?) ?? 0;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
