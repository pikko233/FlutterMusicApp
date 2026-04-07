import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/repositories/search_repository.dart';
import 'package:flutter_music_app/utils/count_util.dart';
import 'package:get/state_manager.dart';

class SearchResultViewmodel extends GetxController {
  final isLoading = false.obs; // 是否正在加载中

  // 搜索结果
  final songs = <SongModel>[].obs; // 歌曲列表
  final songTotalCount = 0.obs; // 歌曲总数
  final playlists = [].obs; // 歌单列表
  final albums = [].obs; // 专辑列表
  final artists = [].obs; // 歌手列表

  String _currentKeywords = ''; // 当前搜索关键词，用于分页加载

  // 为播放器提供的分页加载回调：加载搜索结果歌曲的下一页
  Future<List<SongModel>> loadMoreSongs(int offset) async {
    final res = await SearchRepository.getSearchResult(
      _currentKeywords,
      limit: 30,
      offset: offset,
      type: 1,
    );
    return (res['songs'] as List).map((e) => SongModel.fromMap(e)).toList();
  }

  // 获取搜索结果
  Future<void> getSearchResult(String keywords, {int? limit, int? type}) async {
    _currentKeywords = keywords;
    try {
      isLoading.value = true;
      final res = await SearchRepository.getSearchResult(
        keywords,
        limit: limit,
        type: type,
      );
      // print('搜索结果: $res');
      songs.value = (res['song']['songs'] as List)
          .map((e) => SongModel.fromMap(e))
          .toList();
      songTotalCount.value = CountUtil.getCountFromStriing(
        res['song']['moreText'],
      );
      print('搜索结果-歌曲列表: $songs');
      print('歌曲总数: $songTotalCount');
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
