import 'package:freezed_annotation/freezed_annotation.dart';

part 'creator.freezed.dart';
part 'creator.g.dart';

// @freezed define immutable class.
@freezed
class Creator with _$Creator {
  const factory Creator({
    @JsonKey(name: '_id') String? id,
    String? email,
    String? password,
  }) = _Creator;

  factory Creator.fromJson(Map<String, dynamic> json) =>
      _$CreatorFromJson(json);
}
