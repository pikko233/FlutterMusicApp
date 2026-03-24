import 'package:flutter_music_app/models/playlist_model.dart';
import 'package:flutter_music_app/utils/request.dart';

class HomeRepository {
  // 获取首页推荐歌单
  static Future<List<PlaylistModel>> getRecommendPlaylist({
    int limit = 30,
  }) async {
    final res = await Request.get("/personalized", params: {"limit": limit});
    return (res.data['result'] as List)
        .map((e) => PlaylistModel.fromMap(e))
        .toList();
  }
}
