import 'package:flutter_music_app/utils/request.dart';

class AlbumRepository {
  // 获取专辑内容
  static Future<dynamic> getAlbumDetail(int id) async {
    final res = await Request.get('/album', params: {'id': id});
    return res.data;
  }
}
