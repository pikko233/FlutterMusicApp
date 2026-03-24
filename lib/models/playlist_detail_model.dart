// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlaylistDetailModel {
  final int id;
  final String name; // 歌单名称
  final String coverImgUrl; // 封面图片URL
  final String description; // 歌单简介
  final int trackCount; // 歌单内歌曲总数
  final int playCount; // 播放次数
  final int subscribedCount; // 收藏人数
  final int userId; // 创建者ID，可用来跳转主页
  final int
  createTime; // 歌单创建时间（毫秒时间戳，用 DateTime.fromMillisecondsSinceEpoch() 进行转换）
  final int updateTime; // 歌单最后更新时间
  PlaylistDetailModel({
    required this.id,
    required this.name,
    required this.coverImgUrl,
    required this.description,
    required this.trackCount,
    required this.playCount,
    required this.subscribedCount,
    required this.userId,
    required this.createTime,
    required this.updateTime,
  });

  PlaylistDetailModel copyWith({
    int? id,
    String? name,
    String? coverImgUrl,
    String? description,
    int? trackCount,
    int? playCount,
    int? subscribedCount,
    int? userId,
    int? createTime,
    int? updateTime,
  }) {
    return PlaylistDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      coverImgUrl: coverImgUrl ?? this.coverImgUrl,
      description: description ?? this.description,
      trackCount: trackCount ?? this.trackCount,
      playCount: playCount ?? this.playCount,
      subscribedCount: subscribedCount ?? this.subscribedCount,
      userId: userId ?? this.userId,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
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
      'subscribedCount': subscribedCount,
      'userId': userId,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }

  factory PlaylistDetailModel.fromMap(Map<String, dynamic> map) {
    return PlaylistDetailModel(
      id: map['id'] as int,
      name: map['name'] as String,
      coverImgUrl: map['coverImgUrl'] as String? ?? '',
      description: map['description'] as String? ?? '',
      trackCount: map['trackCount'] as int,
      playCount: map['playCount'] as int,
      subscribedCount: map['subscribedCount'] as int,
      userId: map['userId'] as int,
      createTime: map['createTime'] as int,
      updateTime: map['updateTime'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaylistDetailModel.fromJson(String source) =>
      PlaylistDetailModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlaylistDetailModel(id: $id, name: $name, coverImgUrl: $coverImgUrl, description: $description, trackCount: $trackCount, playCount: $playCount, subscribedCount: $subscribedCount, userId: $userId, createTime: $createTime, updateTime: $updateTime)';
  }

  @override
  bool operator ==(covariant PlaylistDetailModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.coverImgUrl == coverImgUrl &&
        other.description == description &&
        other.trackCount == trackCount &&
        other.playCount == playCount &&
        other.subscribedCount == subscribedCount &&
        other.userId == userId &&
        other.createTime == createTime &&
        other.updateTime == updateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        coverImgUrl.hashCode ^
        description.hashCode ^
        trackCount.hashCode ^
        playCount.hashCode ^
        subscribedCount.hashCode ^
        userId.hashCode ^
        createTime.hashCode ^
        updateTime.hashCode;
  }
}
