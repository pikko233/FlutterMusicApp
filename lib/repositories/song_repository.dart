import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/utils/request.dart';
import 'package:get/get.dart';

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
    print('音乐是否可用api: $res');
    if (!res.data['success']) {
      // 没有版权
      Get.snackbar(res.data['message'], '试试换一首歌吧～');
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
    print('获取音乐URL: $res');
    return res.data['data'][0]['url'];
  }
}
