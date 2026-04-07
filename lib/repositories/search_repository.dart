import 'package:flutter_music_app/models/search_hot_model.dart';
import 'package:flutter_music_app/utils/request.dart';

class SearchRepository {
  // 热搜列表
  static Future<List<SearchHotModel>> getSearchHot() async {
    final res = await Request.get('/search/hot/detail');
    return (res.data['data'] as List)
        .map((e) => SearchHotModel.fromMap(e))
        .toList();
  }

  // 搜索建议
  // 必选参数 : keywords : 关键词
  // 可选参数 : type : 如果传 'mobile' 则返回移动端数据
  static Future<List<String>> getSearchSuggest(
    String keywords, {
    String type = 'mobile',
  }) async {
    final res = await Request.get(
      '/search/suggest',
      params: {'keywords': keywords, 'type': type},
    );
    return ((res.data['result']['allMatch'] as List?) ?? [])
        .map((e) => e['keyword'] as String)
        .toList();
  }

  // 搜索
  // 必选参数 : keywords : 关键词
  // 可选参数 : limit : 返回数量 , 默认为 30 offset : 偏移数量，用于分页 , 如 : 如 :( 页数 -1)*30, 其中 30 为 limit 的值 , 默认为 0
  // type: 搜索类型；默认为 1 即单曲 , 取值意义 : 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频, 1018:综合, 2000:声音(搜索声音返回字段格式会不一样)
  static Future<dynamic> getSearchResult(
    String keywords, {
    int? limit,
    int? offset,
    int? type,
  }) async {
    final res = await Request.get(
      '/search',
      params: {
        'keywords': keywords,
        'limit': limit,
        'offset': offset,
        'type': type,
      },
    );
    return res.data['result'];
  }
}
