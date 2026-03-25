// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlaylistModel {
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
  final CreatorModel? creator; // 歌单创建者
  final int shareCount; // 歌单分享次数
  final int commentCount; // 歌单评论数量
  PlaylistModel({
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
    required this.creator,
    required this.shareCount,
    required this.commentCount,
  });

  PlaylistModel copyWith({
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
    CreatorModel? creator,
    int? shareCount,
    int? commentCount,
  }) {
    return PlaylistModel(
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
      creator: creator ?? this.creator,
      shareCount: shareCount ?? this.shareCount,
      commentCount: commentCount ?? this.commentCount,
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
      'creator': creator,
      'shareCount': shareCount,
      'commentCount': commentCount,
    };
  }

  factory PlaylistModel.fromMap(Map<String, dynamic> map) {
    return PlaylistModel(
      id: map['id'] as int,
      name: map['name'] as String,
      coverImgUrl: map['coverImgUrl'] as String,
      description: map['description'] as String? ?? '',
      trackCount: map['trackCount'] as int,
      playCount: map['playCount'] as int,
      subscribedCount: map['subscribedCount'] as int,
      userId: map['userId'] as int,
      createTime: map['createTime'] as int,
      updateTime: map['updateTime'] as int,
      creator: map['creator'] != null
          ? CreatorModel.fromMap(map['creator'] as Map<String, dynamic>)
          : null,
      shareCount: map['shareCount'] as int,
      commentCount: map['commentCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaylistModel.fromJson(String source) =>
      PlaylistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlaylistModel(id: $id, name: $name, coverImgUrl: $coverImgUrl, description: $description, trackCount: $trackCount, playCount: $playCount, subscribedCount: $subscribedCount, userId: $userId, createTime: $createTime, updateTime: $updateTime, creator: $creator, shareCount: $shareCount, commentCount: $commentCount)';
  }

  @override
  bool operator ==(covariant PlaylistModel other) {
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
        other.updateTime == updateTime &&
        other.creator == creator &&
        other.shareCount == shareCount &&
        other.commentCount == commentCount;
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
        updateTime.hashCode ^
        creator.hashCode ^
        shareCount.hashCode ^
        commentCount.hashCode;
  }
}

class CreatorModel {
  final int userId; // 用户ID
  final String nickname; // 昵称
  final String avatarUrl; // 头像URL
  CreatorModel({
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
  });

  CreatorModel copyWith({int? userId, String? nickname, String? avatarUrl}) {
    return CreatorModel(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'nickname': nickname,
      'avatarUrl': avatarUrl,
    };
  }

  factory CreatorModel.fromMap(Map<String, dynamic> map) {
    return CreatorModel(
      userId: map['userId'] as int,
      nickname: map['nickname'] as String,
      avatarUrl: map['avatarUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatorModel.fromJson(String source) =>
      CreatorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CreatorModel(userId: $userId, nickname: $nickname, avatarUrl: $avatarUrl)';

  @override
  bool operator ==(covariant CreatorModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.nickname == nickname &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => userId.hashCode ^ nickname.hashCode ^ avatarUrl.hashCode;
}
