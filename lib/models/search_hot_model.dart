// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SearchHotModel {
  final String searchWord; // 热搜关键词，点击后直接触发搜索
  final int score; // 热度分数，数值越高越热门
  final String content; // 热搜副标题/描述，可能为空字符串
  final int iconType; // 标签类型：0=无标签 4=第一名(火焰) 5=推荐
  final String? iconUrl; // 标签图片 URL，iconType=0 时为 null

  SearchHotModel({
    required this.searchWord,
    required this.score,
    required this.content,
    required this.iconType,
    required this.iconUrl,
  });

  factory SearchHotModel.fromMap(Map<String, dynamic> map) {
    return SearchHotModel(
      searchWord: map['searchWord'] as String,
      score: map['score'] as int,
      content: map['content'] as String? ?? '',
      iconType: map['iconType'] as int,
      iconUrl: map['iconUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'searchWord': searchWord,
      'score': score,
      'content': content,
      'iconType': iconType,
      'iconUrl': iconUrl,
    };
  }

  String toJson() => json.encode(toMap());

  factory SearchHotModel.fromJson(String source) =>
      SearchHotModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SearchHotModel(searchWord: $searchWord, score: $score, '
        'content: $content, iconType: $iconType, iconUrl: $iconUrl)';
  }

  @override
  bool operator ==(covariant SearchHotModel other) {
    if (identical(this, other)) return true;
    return other.searchWord == searchWord;
  }

  @override
  int get hashCode => searchWord.hashCode;
}
