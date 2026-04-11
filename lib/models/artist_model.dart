// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ArtistModel {
  final int id;
  final String name;
  final String img1v1Url; // 头像
  final List<String> alias; // 别名
  final int albumSize; // 专辑数
  final int musicSize; // 歌曲数
  final bool followed; // 是否关注
  final String? identityIconUrl; // 认证图标（可为null）
  ArtistModel({
    required this.id,
    required this.name,
    required this.img1v1Url,
    required this.alias,
    required this.albumSize,
    required this.musicSize,
    required this.followed,
    this.identityIconUrl,
  });

  ArtistModel copyWith({
    int? id,
    String? name,
    String? img1v1Url,
    List<String>? alias,
    int? albumSize,
    int? musicSize,
    bool? followed,
    String? identityIconUrl,
  }) {
    return ArtistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      img1v1Url: img1v1Url ?? this.img1v1Url,
      alias: alias ?? this.alias,
      albumSize: albumSize ?? this.albumSize,
      musicSize: musicSize ?? this.musicSize,
      followed: followed ?? this.followed,
      identityIconUrl: identityIconUrl ?? this.identityIconUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'img1v1Url': img1v1Url,
      'alias': alias,
      'albumSize': albumSize,
      'musicSize': musicSize,
      'followed': followed,
      'identityIconUrl': identityIconUrl,
    };
  }

  factory ArtistModel.fromMap(Map<String, dynamic> map) {
    return ArtistModel(
      id: map['id'] as int,
      name: map['name'] as String,
      img1v1Url: map['img1v1Url'] as String,
      alias: List<String>.from(map['alias'] as List),
      albumSize: map['albumSize'] as int,
      musicSize: map['musicSize'] as int,
      followed: map['followed'] as bool? ?? false,
      identityIconUrl: map['identityIconUrl'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArtistModel.fromJson(String source) =>
      ArtistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ArtistModel(id: $id, name: $name, img1v1Url: $img1v1Url, alias: $alias, albumSize: $albumSize, musicSize: $musicSize, followed: $followed, identityIconUrl: $identityIconUrl)';
  }

  @override
  bool operator ==(covariant ArtistModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.img1v1Url == img1v1Url &&
        listEquals(other.alias, alias) &&
        other.albumSize == albumSize &&
        other.musicSize == musicSize &&
        other.followed == followed &&
        other.identityIconUrl == identityIconUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        img1v1Url.hashCode ^
        alias.hashCode ^
        albumSize.hashCode ^
        musicSize.hashCode ^
        followed.hashCode ^
        identityIconUrl.hashCode;
  }
}
