import 'package:flutter_music_app/utils/request.dart';

class ArtistRepository {
  // 获取歌手详情
  static Future<dynamic> getArtistDetail(int id) async {
    final res = await Request.get('/artist/detail', params: {'id': id});
    return res.data['data'];
  }

  // 获取歌手热门50首歌曲
  static Future<dynamic> getArtistTopSong(int id) async {
    final res = await Request.get('/artist/top/song', params: {'id': id});
    return res.data['songs'];
  }
}
