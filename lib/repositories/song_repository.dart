import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/utils/request.dart';

class SongRepository {
  // 获取歌曲详情
  static Future<SongModel> getSongDetail(int ids) async {
    final res = await Request.get('/song/detail', params: {'ids': ids});
    final songs = res.data['songs'] as List<dynamic>;
    return SongModel.fromMap(songs[0] as Map<String, dynamic>);
  }
}
