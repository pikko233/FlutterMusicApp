// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ToplistModel {
  final int id; // 榜单 ID
  final String name; // 榜单名称
  final String coverImgUrl; // 封面图片 URL
  final String description; // 榜单简介
  final int trackCount; // 歌曲总数
  final int playCount; // 播放量
  final int updateTime; // 最后更新时间（毫秒时间戳）
  final String updateFrequency; // 更新频率，如"刚刚更新"、"每周四更新"
  final int subscribedCount; // 收藏人数
  final String? toplistType; // 榜单类型标识，官方榜有值（如 "S"飙升/"N"新歌），第三方榜为 null

  ToplistModel({
    required this.id,
    required this.name,
    required this.coverImgUrl,
    required this.description,
    required this.trackCount,
    required this.playCount,
    required this.updateTime,
    required this.updateFrequency,
    required this.subscribedCount,
    required this.toplistType,
  });

  factory ToplistModel.fromMap(Map<String, dynamic> map) {
    return ToplistModel(
      id: map['id'] as int,
      name: map['name'] as String,
      coverImgUrl: map['coverImgUrl'] as String,
      description: map['description'] as String? ?? '',
      trackCount: map['trackCount'] as int,
      playCount: map['playCount'] as int,
      updateTime: map['updateTime'] as int,
      updateFrequency: map['updateFrequency'] as String? ?? '',
      subscribedCount: map['subscribedCount'] as int,
      toplistType: map['ToplistType'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'coverImgUrl': coverImgUrl,
      'description': description,
      'trackCount': trackCount,
      'playCount': playCount,
      'updateTime': updateTime,
      'updateFrequency': updateFrequency,
      'subscribedCount': subscribedCount,
      'ToplistType': toplistType,
    };
  }

  String toJson() => json.encode(toMap());

  factory ToplistModel.fromJson(String source) =>
      ToplistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ToplistModel(id: $id, name: $name, coverImgUrl: $coverImgUrl, '
        'trackCount: $trackCount, playCount: $playCount, updateFrequency: $updateFrequency)';
  }

  @override
  bool operator ==(covariant ToplistModel other) {
    if (identical(this, other)) return true;
    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
