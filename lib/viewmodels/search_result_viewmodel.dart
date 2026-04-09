import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/repositories/search_repository.dart';
import 'package:get/state_manager.dart';

class SearchResultViewmodel extends GetxController {
  final isLoading = false.obs; // 是否正在加载中

  // 搜索结果
  final songs = <SongModel>[].obs; // 歌曲列表
  final songTotalCount = 0.obs; // 歌曲总数
  final playlists = [].obs; // 歌单列表
  final albums = [].obs; // 专辑列表
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

  // 加载搜索结果歌曲的下一页
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
    currentKeywords = keywords;
    try {
      isLoading.value = true;
      final res = await SearchRepository.getSearchResult(
        keywords,
        limit: _limit,
        offset: offset,
        type: type,
      );
      songs.value = (res['songs'] as List)
          .map((e) => SongModel.fromType1Map(e))
          .toList();
      songTotalCount.value = res['songCount'] as int;
      print('搜索结果-歌曲列表: $songs');
      print('歌曲总数: $songTotalCount');
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
