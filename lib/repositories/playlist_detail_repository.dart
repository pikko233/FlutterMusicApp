import 'package:flutter_music_app/models/playlist_detail_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/utils/request.dart';

class PlaylistDetailRepository {
  // 获取歌单详情
  // id：必填，歌单id
  // s：选填，歌单最近的s个收藏者，默认为8
  static Future<PlaylistDetailModel> getPlaylistDetail(
    int id, {
    int s = 8,
  }) async {
    final res = await Request.get('/playlist/detail', params: {'id': id});
    return PlaylistDetailModel.fromMap(res.data['playlist']);
  }

  // 获取歌单内的歌曲
  // id：必填，歌单id
  // limit：选填，限制获取歌曲的数量，默认值为当前歌单的歌曲数量
  // offset：选填，默认值为0
  // 注：关于offset，你可以这样理解，假设你当前的歌单有200首歌
  // 你传入limit=50&offset=0等价于limit=50，你会得到第1-50首歌曲
  // 你传入limit=50&offset=50，你会得到第51-100首歌曲
  // 如果你设置limit=50&offset=100，你就会得到第101-150首歌曲
  static Future<List<SongModel>> getSongsInPlaylist(
    int id, {
    int? limit,
    int offset = 0,
  }) async {
    final res = await Request.get(
      '/playlist/track/all',
      params: {'id': id, 'limit': limit, 'offset': offset},
    );
    return (res.data['songs'] as List)
        .map((e) => SongModel.fromMap(e))
        .toList();
  }
}
