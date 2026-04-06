// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HighQualityTagModel {
  final int id;
  final String name;
  final int type;
  final int category;
  final bool hot;
  HighQualityTagModel({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.hot,
  });

  HighQualityTagModel copyWith({
    int? id,
    String? name,
    int? type,
    int? category,
    bool? hot,
  }) {
    return HighQualityTagModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      category: category ?? this.category,
      hot: hot ?? this.hot,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'category': category,
      'hot': hot,
    };
  }

  factory HighQualityTagModel.fromMap(Map<String, dynamic> map) {
    return HighQualityTagModel(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as int,
      category: map['category'] as int,
      hot: map['hot'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory HighQualityTagModel.fromJson(String source) =>
      HighQualityTagModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HighQualityTagModel(id: $id, name: $name, type: $type, category: $category, hot: $hot)';
  }

  @override
  bool operator ==(covariant HighQualityTagModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.type == type &&
        other.category == category &&
        other.hot == hot;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        category.hashCode ^
        hot.hashCode;
  }
}
