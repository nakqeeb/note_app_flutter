// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Note _$$_NoteFromJson(Map<String, dynamic> json) => _$_Note(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : Section.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String?,
      creator: json['creator'] == null
          ? null
          : Creator.fromJson(json['creator'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$_NoteToJson(_$_Note instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'sections': instance.sections,
      'category': instance.category,
      'creator': instance.creator,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
