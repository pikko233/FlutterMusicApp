// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SongModel {
  final int id; // 歌曲ID
  final String name; // 歌曲名称
  final List<Artist> ar; // 歌手（可能有多个）
  final Album al; // 专辑
  final int dt; // 时长（毫秒）
  final int fee; // 付费类型：0=免费 1=VIP 8=数字专辑

  String get artistsName => ar.map((e) => e.name).join(' / ');
  String get picUrl => al.picUrl;

  SongModel({
    required this.id,
    required this.name,
    required this.ar,
    required this.al,
    required this.dt,
    required this.fee,
  });

  SongModel copyWith({
    int? id,
    String? name,
    List<Artist>? ar,
    Album? al,
    int? dt,
    int? fee,
  }) {
    return SongModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ar: ar ?? this.ar,
      al: al ?? this.al,
      dt: dt ?? this.dt,
      fee: fee ?? this.fee,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'ar': ar.map((x) => x.toMap()).toList(),
      'al': al.toMap(),
      'dt': dt,
      'fee': fee,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] as int,
      name: map['name'] as String,
      ar: List<Artist>.from(
        (map['ar'] as List<dynamic>).map<Artist>(
          (x) => Artist.fromMap(x as Map<String, dynamic>),
        ),
      ),
      al: Album.fromMap(map['al'] as Map<String, dynamic>),
      dt: map['dt'] as int,
      fee: map['fee'] as int? ?? 0,
    );
  }

  // 用于解析 /search?type=1 返回的歌曲格式
  // 与 type=1018 的区别：字段名不同（artists/duration/album），且 album 无 picUrl
  factory SongModel.fromType1Map(Map<String, dynamic> map) {
    final album = map['album'] as Map<String, dynamic>;
    return SongModel(
      id: map['id'] as int,
      name: map['name'] as String,
      ar: List<Artist>.from(
        (map['artists'] as List<dynamic>).map<Artist>(
          (x) => Artist.fromMap(x as Map<String, dynamic>),
        ),
      ),
      al: Album(
        id: album['id'] as int,
        name: album['name'] as String,
        picUrl: '', // type=1 无 picUrl，picId 无法直接转换为 URL
      ),
      dt: map['duration'] as int,
      fee: map['fee'] as int? ?? 0,
    );
  }

  // 用于解析专辑详情 /album?id=xxx 返回的歌曲格式
  // al 字段无 picUrl，需从外部传入专辑封面 URL
  factory SongModel.fromAlbumDetailMap(
    Map<String, dynamic> map,
    String albumPicUrl,
  ) {
    final al = map['al'] as Map<String, dynamic>;
    return SongModel(
      id: map['id'] as int,
      name: map['name'] as String,
      ar: List<Artist>.from(
        (map['ar'] as List<dynamic>).map<Artist>(
          (x) => Artist.fromMap(x as Map<String, dynamic>),
        ),
      ),
      al: Album(
        id: al['id'] as int,
        name: al['name'] as String,
        picUrl: albumPicUrl,
      ),
      dt: map['dt'] as int,
      fee: map['fee'] as int? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, name: $name, ar: $ar, al: $al, dt: $dt, fee: $fee)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        listEquals(other.ar, ar) &&
        other.al == al &&
        other.dt == dt &&
        other.fee == fee;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        ar.hashCode ^
        al.hashCode ^
        dt.hashCode ^
        fee.hashCode;
  }
}

// 艺术家（歌手）
class Artist {
  final int id;
  final String name;

  Artist({required this.id, required this.name});

  Artist copyWith({int? id, String? name}) {
    return Artist(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(id: map['id'] as int, name: map['name'] as String);
  }

  String toJson() => json.encode(toMap());

  factory Artist.fromJson(String source) =>
      Artist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Artist(id: $id, name: $name)';

  @override
  bool operator ==(covariant Artist other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

// 专辑
class Album {
  final int id;
  final String name; // 专辑名称
  final String picUrl; // 专辑封面
  Album({required this.id, required this.name, required this.picUrl});

  Album copyWith({int? id, String? name, String? picUrl}) {
    return Album(
      id: id ?? this.id,
      name: name ?? this.name,
      picUrl: picUrl ?? this.picUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'picUrl': picUrl};
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] as int,
      name: map['name'] as String,
      picUrl: map['picUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Album(id: $id, name: $name, picUrl: $picUrl)';

  @override
  bool operator ==(covariant Album other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.picUrl == picUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ picUrl.hashCode;
}
