// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class HighQualityPlaylistModel {
  final int id; // 歌单ID
  final String name; // 歌单名称
  final String coverImgUrl; // 封面图
  final String description; // 歌单简介
  final List<String> tags; // 标签（如“欧美”、“摇滚”）
  final int trackCount; // 歌曲数量
  final int playCount; // 播放数量
  final int subscribedCount; // 收藏数
  final int shareCount; // 分享数
  final int commentCount; // 评论数
  final bool highQuality; // 是否为精品歌单标记
  final String copywritter; // 精品歌单推荐语（可能为空）
  final Creator creator; // 歌单创建者
  HighQualityPlaylistModel({
    required this.id,
    required this.name,
    required this.coverImgUrl,
    required this.description,
    required this.tags,
    required this.trackCount,
    required this.playCount,
    required this.subscribedCount,
    required this.shareCount,
    required this.commentCount,
    required this.highQuality,
    required this.copywritter,
    required this.creator,
  });

  HighQualityPlaylistModel copyWith({
    int? id,
    String? name,
    String? coverImgUrl,
    String? description,
    List<String>? tags,
    int? trackCount,
    int? playCount,
    int? subscribedCount,
    int? shareCount,
    int? commentCount,
    bool? highQuality,
    String? copywritter,
    Creator? creator,
  }) {
    return HighQualityPlaylistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      coverImgUrl: coverImgUrl ?? this.coverImgUrl,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      trackCount: trackCount ?? this.trackCount,
      playCount: playCount ?? this.playCount,
      subscribedCount: subscribedCount ?? this.subscribedCount,
      shareCount: shareCount ?? this.shareCount,
      commentCount: commentCount ?? this.commentCount,
      highQuality: highQuality ?? this.highQuality,
      copywritter: copywritter ?? this.copywritter,
      creator: creator ?? this.creator,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'coverImgUrl': coverImgUrl,
      'description': description,
      'tags': tags,
      'trackCount': trackCount,
      'playCount': playCount,
      'subscribedCount': subscribedCount,
      'shareCount': shareCount,
      'commentCount': commentCount,
      'highQuality': highQuality,
      'copywritter': copywritter,
      'creator': creator.toMap(),
    };
  }

  factory HighQualityPlaylistModel.fromMap(Map<String, dynamic> map) {
    return HighQualityPlaylistModel(
      id: map['id'] as int,
      name: map['name'] as String,
      coverImgUrl: map['coverImgUrl'] as String,
      description: map['description'] as String,
      tags: List<String>.from(map['tags']),
      trackCount: map['trackCount'] as int,
      playCount: map['playCount'] as int,
      subscribedCount: map['subscribedCount'] as int,
      shareCount: map['shareCount'] as int,
      commentCount: map['commentCount'] as int,
      highQuality: map['highQuality'] as bool,
      copywritter: map['copywriter'] as String? ?? '',
      creator: Creator.fromMap(map['creator'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory HighQualityPlaylistModel.fromJson(String source) =>
      HighQualityPlaylistModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'HighQualityPlaylistModel(name: $name, coverImgUrl: $coverImgUrl, description: $description, tags: $tags, trackCount: $trackCount, playCount: $playCount, subscribedCount: $subscribedCount, shareCount: $shareCount, commentCount: $commentCount, highQuality: $highQuality, copywritter: $copywritter, creator: $creator)';
  }

  @override
  bool operator ==(covariant HighQualityPlaylistModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.coverImgUrl == coverImgUrl &&
        other.description == description &&
        listEquals(other.tags, tags) &&
        other.trackCount == trackCount &&
        other.playCount == playCount &&
        other.subscribedCount == subscribedCount &&
        other.shareCount == shareCount &&
        other.commentCount == commentCount &&
        other.highQuality == highQuality &&
        other.copywritter == copywritter &&
        other.creator == creator;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        coverImgUrl.hashCode ^
        description.hashCode ^
        tags.hashCode ^
        trackCount.hashCode ^
        playCount.hashCode ^
        subscribedCount.hashCode ^
        shareCount.hashCode ^
        commentCount.hashCode ^
        highQuality.hashCode ^
        copywritter.hashCode ^
        creator.hashCode;
  }
}

class Creator {
  final String nickName; // 歌单创建者昵称
  final String avatarUrl; // 歌单创建者头像
  Creator({required this.nickName, required this.avatarUrl});

  Creator copyWith({String? nickName, String? avatarUrl}) {
    return Creator(
      nickName: nickName ?? this.nickName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'nickname': nickName, 'avatarUrl': avatarUrl};
  }

  factory Creator.fromMap(Map<String, dynamic> map) {
    return Creator(
      nickName: map['nickname'] as String,
      avatarUrl: map['avatarUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Creator.fromJson(String source) =>
      Creator.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Creator(nickName: $nickName, avatarUrl: $avatarUrl)';

  @override
  bool operator ==(covariant Creator other) {
    if (identical(this, other)) return true;

    return other.nickName == nickName && other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => nickName.hashCode ^ avatarUrl.hashCode;
}
