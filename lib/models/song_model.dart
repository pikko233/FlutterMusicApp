// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SongModel {
  final int id; // 歌曲ID
  final String name; // 歌曲名称
  final List<ArtistModel> ar; // 歌手（可能有多个）
  final AlbumModel al; // 专辑
  final int dt; // 时长（毫秒）
  final int fee; // 付费类型：0=免费 1=VIP 8=数字专辑

  String get singersName => ar.map((e) => e.name).join(' / ');
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
    List<ArtistModel>? ar,
    AlbumModel? al,
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
      ar: List<ArtistModel>.from(
        (map['ar'] as List<dynamic>).map<ArtistModel>(
          (x) => ArtistModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      al: AlbumModel.fromMap(map['al'] as Map<String, dynamic>),
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
class ArtistModel {
  final int id;
  final String name;

  ArtistModel({required this.id, required this.name});

  ArtistModel copyWith({int? id, String? name}) {
    return ArtistModel(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory ArtistModel.fromMap(Map<String, dynamic> map) {
    return ArtistModel(id: map['id'] as int, name: map['name'] as String);
  }

  String toJson() => json.encode(toMap());

  factory ArtistModel.fromJson(String source) =>
      ArtistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ArtistModel(id: $id, name: $name)';

  @override
  bool operator ==(covariant ArtistModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

// 专辑
class AlbumModel {
  final int id;
  final String name; // 专辑名称
  final String picUrl; // 专辑封面
  AlbumModel({required this.id, required this.name, required this.picUrl});

  AlbumModel copyWith({int? id, String? name, String? picUrl}) {
    return AlbumModel(
      id: id ?? this.id,
      name: name ?? this.name,
      picUrl: picUrl ?? this.picUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'picUrl': picUrl};
  }

  factory AlbumModel.fromMap(Map<String, dynamic> map) {
    return AlbumModel(
      id: map['id'] as int,
      name: map['name'] as String,
      picUrl: map['picUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlbumModel.fromJson(String source) =>
      AlbumModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AlbumModel(id: $id, name: $name, picUrl: $picUrl)';

  @override
  bool operator ==(covariant AlbumModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.picUrl == picUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ picUrl.hashCode;
}
