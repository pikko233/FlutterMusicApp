import 'package:flutter_music_app/models/high_quality_playlist_model.dart';
import 'package:flutter_music_app/models/high_quality_tag_model.dart';
import 'package:flutter_music_app/models/playlist_model.dart';
import 'package:flutter_music_app/models/recommend_playlist_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/models/toplist_model.dart';
import 'package:flutter_music_app/utils/request.dart';

class PlaylistRepository {
  // 获取首页推荐歌单
  static Future<List<RecommendPlaylistModel>> getRecommendPlaylist({
    int limit = 30,
  }) async {
    final res = await Request.get("/personalized", params: {"limit": limit});
    return (res.data['result'] as List)
        .map((e) => RecommendPlaylistModel.fromMap(e))
        .toList();
  }

  // 获取歌单详情
  // id：必填，歌单id
  // s：选填，歌单最近的s个收藏者，默认为8
  static Future<PlaylistModel> getPlaylistDetail(int id, {int s = 8}) async {
    final res = await Request.get('/playlist/detail', params: {'id': id});
    return PlaylistModel.fromMap(res.data['playlist']);
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

  // 精品歌单标签列表
  static Future<List<HighQualityTagModel>> getHighQualityTags() async {
    final res = await Request.get('/playlist/highquality/tags');
    return (res.data['tags'] as List)
        .map((e) => HighQualityTagModel.fromMap(e))
        .toList();
  }

  // 获取精品歌单
  // 可选参数 : cat: tag, 比如 " 华语 "、" 古风 " 、" 欧美 "、" 流行 ", 默认为 "全部",可从精品歌单标签列表接口获取(/playlist/highquality/tags)
  // limit: 取出歌单数量 , 默认为 50
  // before: 分页参数,取上一页最后一个歌单的 updateTime 获取
  static Future<List<HighQualityPlaylistModel>> getHighQualityPlaylist(
    int before, {
    String? cat,
    int limit = 50,
  }) async {
    final res = await Request.get(
      '/top/playlist/highquality',
      params: {'before': before, 'cat': cat, 'limit': limit},
    );

    return (res.data['playlists'] as List)
        .map((e) => HighQualityPlaylistModel.fromMap(e))
        .toList();
  }

  // 获取所有榜单（排行榜），排行榜详情用歌单详情的接口
  static Future<List<ToplistModel>> getToplist() async {
    final res = await Request.get('/toplist');
    return (res.data['list'] as List)
        .map((e) => ToplistModel.fromMap(e))
        .toList();
  }
}
