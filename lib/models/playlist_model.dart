// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlaylistModel {
  final int id;
  final String name; // 歌单名称
  final String picUrl; // 歌单封面图片
  final int playCount; // 播放量
  final int trackCount; // 歌单内歌曲数量
  PlaylistModel({
    required this.id,
    required this.name,
    required this.picUrl,
    required this.playCount,
    required this.trackCount,
  });

  PlaylistModel copyWith({
    int? id,
    String? name,
    String? picUrl,
    int? playCount,
    int? trackCount,
  }) {
    return PlaylistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      picUrl: picUrl ?? this.picUrl,
      playCount: playCount ?? this.playCount,
      trackCount: trackCount ?? this.trackCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'picUrl': picUrl,
      'playCount': playCount,
      'trackCount': trackCount,
    };
  }

  factory PlaylistModel.fromMap(Map<String, dynamic> map) {
    return PlaylistModel(
      id: map['id'] as int,
      name: map['name'] as String,
      picUrl: map['picUrl'] as String,
      playCount: map['playCount'] as int,
      trackCount: map['trackCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaylistModel.fromJson(String source) =>
      PlaylistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlaylistModel(id: $id, name: $name, picUrl: $picUrl, playCount: $playCount, trackCount: $trackCount)';
  }

  @override
  bool operator ==(covariant PlaylistModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.picUrl == picUrl &&
        other.playCount == playCount &&
        other.trackCount == trackCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        picUrl.hashCode ^
        playCount.hashCode ^
        trackCount.hashCode;
  }
}
