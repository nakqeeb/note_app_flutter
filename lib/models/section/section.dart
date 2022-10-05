import 'package:freezed_annotation/freezed_annotation.dart';

part 'section.freezed.dart';
part 'section.g.dart';

// @freezed define immutable class.
@freezed
class Section with _$Section {
  const factory Section({
    @JsonKey(name: '_id') String? id,
    String? sectionTitle,
    String? content,
  }) = _Section;

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);
}
