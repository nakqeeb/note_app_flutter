import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

// @unfreezed define mutable class.
@unfreezed
class Category with _$Category {
  factory Category({
    @JsonKey(name: '_id') String? id,
    String? name,
    String? icon,
    String? color,
    String? creator,
    @Default(true) bool isSelected,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
