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

  // 获取歌手全部歌曲
  // order : hot ,time 按照热门或者时间排序
  // limit: 取出歌单数量 , 默认为 50
  // offset: 偏移数量 , 用于分页 , 如 :( 评论页数 -1)*50, 其中 50 为 limit 的值
  static Future<dynamic> getArtistSongs(
    int id, {
    String? order,
    int? limit,
    int? offset,
  }) async {
    final res = await Request.get(
      '/artist/songs',
      params: {'id': id, 'order': order, 'limit': limit, 'offset': offset},
    );
    return res.data;
  }

  // 获取相似歌手
  static Future<dynamic> getSimilarArtists(int id) async {
    final res = await Request.get('/simi/artist', params: {'id': id});
    return res.data['artists'];
  }
}
