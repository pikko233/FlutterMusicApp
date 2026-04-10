// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AlbumModel {
  final int id; // 专辑ID
  final String name; // 专辑名称
  final String picUrl; // 封面图URL
  final String? type; // 专辑类型 Single/专辑/精选集
  final int size; // 歌单内歌曲数量
  final int publishTime; // 发布时间（毫秒时间戳）
  final String? companyName; // 发行公司
  final List<Artist> artists; // 艺人列表

  String get artistsName => artists.map((e) => e.name).join(' / ');

  AlbumModel({
    required this.id,
    required this.name,
    required this.picUrl,
    required this.type,
    required this.size,
    required this.publishTime,
    required this.companyName,
    required this.artists,
  });

  AlbumModel copyWith({
    int? id,
    String? name,
    String? picUrl,
    String? type,
    int? size,
    int? publishTime,
    String? companyName,
    List<Artist>? artists,
  }) {
    return AlbumModel(
      id: id ?? this.id,
      name: name ?? this.name,
      picUrl: picUrl ?? this.picUrl,
      type: type ?? this.type,
      size: size ?? this.size,
      publishTime: publishTime ?? this.publishTime,
      companyName: companyName ?? this.companyName,
      artists: artists ?? this.artists,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'picUrl': picUrl,
      'type': type,
      'size': size,
      'publishTime': publishTime,
      'companyName': companyName,
      'artists': artists.map((x) => x.toMap()).toList(),
    };
  }

  factory AlbumModel.fromMap(Map<String, dynamic> map) {
    return AlbumModel(
      id: map['id'] as int,
      name: map['name'] as String,
      picUrl: map['picUrl'] as String,
      type: map['type'] as String,
      size: map['size'] as int,
      publishTime: map['publishTime'] as int,
      companyName: map['companyName'] as String?,
      artists: List<Artist>.from(
        (map['artists'] as List).map<Artist>(
          (x) => Artist.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AlbumModel.fromJson(String source) =>
      AlbumModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AlbumModel(id: $id, name: $name, picUrl: $picUrl, type: $type, size: $size, publishTime: $publishTime, artists: $artists)';
  }

  @override
  bool operator ==(covariant AlbumModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.picUrl == picUrl &&
        other.type == type &&
        other.size == size &&
        other.publishTime == publishTime &&
        listEquals(other.artists, artists);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        picUrl.hashCode ^
        type.hashCode ^
        size.hashCode ^
        publishTime.hashCode ^
        artists.hashCode;
  }
}

class Artist {
  final int id; // 艺人ID
  final String name; // 艺人名称
  final String img1v1Url; // 艺人头像
  Artist({required this.id, required this.name, required this.img1v1Url});

  Artist copyWith({int? id, String? name, String? img1v1Url}) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      img1v1Url: img1v1Url ?? this.img1v1Url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'img1v1Url': img1v1Url};
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      id: map['id'] as int,
      name: map['name'] as String,
      img1v1Url: map['img1v1Url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Artist.fromJson(String source) =>
      Artist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Artist(id: $id, name: $name, img1v1Url: $img1v1Url)';

  @override
  bool operator ==(covariant Artist other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.img1v1Url == img1v1Url;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ img1v1Url.hashCode;
}
