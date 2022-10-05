import 'package:freezed_annotation/freezed_annotation.dart';

import '../creator/creator.dart';
import '../section/section.dart';

part 'note.freezed.dart';
part 'note.g.dart';

// @freezed define immutable class.
@freezed
class Note with _$Note {
  const factory Note({
    @JsonKey(name: '_id') String? id,
    String? title,
    List<Section?>? sections,
    String? category,
    Creator? creator,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
