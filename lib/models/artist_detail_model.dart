// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ArtistDetailModel {
  final int id;
  final String name;
  final String avatar; // 头像
  final String? cover; // 封面大图
  final List<String> alias; // 别名
  final List<String>? transNames; // 翻译名
  final int albumSize; // 专辑数
  final int musicSize; // 歌曲数
  final int? mvSize; // MV数量
  final int? videoCount; // 视频数量
  final String? briefDesc; // 简介
  ArtistDetailModel({
    required this.id,
    required this.name,
    required this.avatar,
    this.cover,
    required this.alias,
    this.transNames,
    required this.albumSize,
    required this.musicSize,
    this.mvSize,
    this.videoCount,
    this.briefDesc,
  });

  ArtistDetailModel copyWith({
    int? id,
    String? name,
    String? avatar,
    String? cover,
    List<String>? alias,
    List<String>? transNames,
    int? albumSize,
    int? musicSize,
    int? mvSize,
    int? videoCount,
    String? briefDesc,
  }) {
    return ArtistDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      cover: cover ?? this.cover,
      alias: alias ?? this.alias,
      transNames: transNames ?? this.transNames,
      albumSize: albumSize ?? this.albumSize,
      musicSize: musicSize ?? this.musicSize,
      mvSize: mvSize ?? this.mvSize,
      videoCount: videoCount ?? this.videoCount,
      briefDesc: briefDesc ?? this.briefDesc,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatar': avatar,
      'cover': cover,
      'alias': alias,
      'transNames': transNames,
      'albumSize': albumSize,
      'musicSize': musicSize,
      'mvSize': mvSize,
      'videoCount': videoCount,
      'briefDesc': briefDesc,
    };
  }

  /// 从歌手详情接口解析，接收 data.artist 对象和 data.videoCount
  factory ArtistDetailModel.fromMap(
    Map<String, dynamic> artist, {
    int? videoCount,
  }) {
    return ArtistDetailModel(
      id: artist['id'] as int,
      name: artist['name'] as String,
      avatar: artist['avatar'] as String,
      cover: artist['cover'] as String?,
      alias: artist['alias'] != null
          ? List<String>.from(artist['alias'] as List)
          : [],
      transNames: artist['transNames'] != null
          ? List<String>.from(artist['transNames'] as List)
          : null,
      albumSize: artist['albumSize'] as int,
      musicSize: artist['musicSize'] as int,
      mvSize: artist['mvSize'] as int?,
      videoCount: videoCount,
      briefDesc: artist['briefDesc'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ArtistDetailModel(id: $id, name: $name, avatar: $avatar, cover: $cover, alias: $alias, transNames: $transNames, albumSize: $albumSize, musicSize: $musicSize, mvSize: $mvSize, videoCount: $videoCount, briefDesc: $briefDesc)';
  }

  @override
  bool operator ==(covariant ArtistDetailModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.avatar == avatar &&
        other.cover == cover &&
        listEquals(other.alias, alias) &&
        listEquals(other.transNames, transNames) &&
        other.albumSize == albumSize &&
        other.musicSize == musicSize &&
        other.mvSize == mvSize &&
        other.videoCount == videoCount &&
        other.briefDesc == briefDesc;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        avatar.hashCode ^
        cover.hashCode ^
        alias.hashCode ^
        transNames.hashCode ^
        albumSize.hashCode ^
        musicSize.hashCode ^
        mvSize.hashCode ^
        videoCount.hashCode ^
        briefDesc.hashCode;
  }
}
