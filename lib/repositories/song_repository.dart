import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/utils/request.dart';
import 'package:flutter_music_app/utils/toast_util.dart';

class SongRepository {
  // 获取歌曲详情
  static Future<SongModel> getSongDetail(int ids) async {
    final res = await Request.get('/song/detail', params: {'ids': ids});
    final songs = res.data['songs'] as List<dynamic>;
    return SongModel.fromMap(songs[0] as Map<String, dynamic>);
  }

  // 音乐是否可用（是否有版权）
  static Future<bool> checkSong(int id) async {
    final res = await Request.get('/check/music', params: {'id': id});
    // print('音乐是否可用api: $res');
    if (!res.data['success']) {
      // 没有版权
      ToastUtil.showToast(res.data['message']);
    }
    return res.data['success'];
  }

  // 获取歌曲URL
  // 必选参数 : id : 音乐 id
  // level: 播放音质等级, 分为 standard => 标准,higher => 较高, exhigh=>极高,  lossless=>无损, hires=>Hi-Res, jyeffect => 高清环绕声, sky => 沉浸环绕声, jymaster => 超清母带
  static Future<dynamic> getSongUrl(int id, {String level = 'standard'}) async {
    final res = await Request.get(
      '/song/url/v1',
      params: {'id': id, 'level': level},
    );
    return res.data['data'][0]['url'];
  }

  // 传入多个id，获取多个歌曲url
  static Future<List<dynamic>> getAllSongUrl(
    List<int> ids, {
    String level = 'standard',
  }) async {
    final res = await Request.get(
      '/song/url/v1',
      params: {'id': ids.join(','), 'level': level},
    );
    return res.data['data'];
  }

  // 获取歌曲逐字歌词
  // 必填参数：歌曲id
  // {"t":0,"c":[{"tx":"作曲: "},{"tx":"柳重言","li":"http://p1.music.126.net/Icj0IcaOjH2ZZpyAM-QGoQ==/6665239487822533.jpg","or":"orpheus://nm/artist/home?id=228547&type=artist"}]}
  // {"t":5403,"c":[{"tx":"编曲: "},{"tx":"Alex San","li":"http://p1.music.126.net/pSbvYkrzZ1RFKqoh-fA9AQ==/109951166352922615.jpg","or":"orpheus://nm/artist/home?id=28984845&type=artist"}]}
  // {"t":10806,"c":[{"tx":"制作人: "},{"tx":"王菲","li":"http://p1.music.126.net/1KQVD6XWbs5IAV0xOj1ZIA==/18764265441342019.jpg","or":"orpheus://nm/artist/home?id=9621&type=artist"},{"tx":"/"},{"tx":"梁荣骏","li":"http://p1.music.126.net/QrD8drwrRcegfKLPoiiG2Q==/109951166288436155.jpg","or":"orpheus://nm/artist/home?id=189294&type=artist"}]}
  // t : 数据显示开始时间戳 (毫秒)
  // c : 元数据list
  // tx: 文字段
  // li: 艺术家、歌手头像图url
  // or：云音乐app内路径；例中作用即打开艺术家主页
  static Future<dynamic> getSongLyric(int id) async {
    final res = await Request.get('/lyric/new', params: {'id': id});
    return res.data;
  }
}
