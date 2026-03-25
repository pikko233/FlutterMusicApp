// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// 推荐歌单model
class RecommendPlaylistModel {
  final int id;
  final String name; // 歌单名称
  final String picUrl; // 歌单封面图片
  final int playCount; // 播放量
  final int trackCount; // 歌单内歌曲数量
  RecommendPlaylistModel({
    required this.id,
    required this.name,
    required this.picUrl,
    required this.playCount,
    required this.trackCount,
  });

  RecommendPlaylistModel copyWith({
    int? id,
    String? name,
    String? picUrl,
    int? playCount,
    int? trackCount,
  }) {
    return RecommendPlaylistModel(
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

  factory RecommendPlaylistModel.fromMap(Map<String, dynamic> map) {
    return RecommendPlaylistModel(
      id: map['id'] as int,
      name: map['name'] as String,
      picUrl: map['picUrl'] as String,
      playCount: map['playCount'] as int,
      trackCount: map['trackCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecommendPlaylistModel.fromJson(String source) =>
      RecommendPlaylistModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'RecommendPlaylistModel(id: $id, name: $name, picUrl: $picUrl, playCount: $playCount, trackCount: $trackCount)';
  }

  @override
  bool operator ==(covariant RecommendPlaylistModel other) {
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
