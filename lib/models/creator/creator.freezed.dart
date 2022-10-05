// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'creator.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Creator _$CreatorFromJson(Map<String, dynamic> json) {
  return _Creator.fromJson(json);
}

/// @nodoc
mixin _$Creator {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreatorCopyWith<Creator> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatorCopyWith<$Res> {
  factory $CreatorCopyWith(Creator value, $Res Function(Creator) then) =
      _$CreatorCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: '_id') String? id, String? email, String? password});
}

/// @nodoc
class _$CreatorCopyWithImpl<$Res> implements $CreatorCopyWith<$Res> {
  _$CreatorCopyWithImpl(this._value, this._then);

  final Creator _value;
  // ignore: unused_field
  final $Res Function(Creator) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? password = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_CreatorCopyWith<$Res> implements $CreatorCopyWith<$Res> {
  factory _$$_CreatorCopyWith(
          _$_Creator value, $Res Function(_$_Creator) then) =
      __$$_CreatorCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: '_id') String? id, String? email, String? password});
}

/// @nodoc
class __$$_CreatorCopyWithImpl<$Res> extends _$CreatorCopyWithImpl<$Res>
    implements _$$_CreatorCopyWith<$Res> {
  __$$_CreatorCopyWithImpl(_$_Creator _value, $Res Function(_$_Creator) _then)
      : super(_value, (v) => _then(v as _$_Creator));

  @override
  _$_Creator get _value => super._value as _$_Creator;

  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? password = freezed,
  }) {
    return _then(_$_Creator(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Creator implements _Creator {
  const _$_Creator({@JsonKey(name: '_id') this.id, this.email, this.password});

  factory _$_Creator.fromJson(Map<String, dynamic> json) =>
      _$$_CreatorFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? email;
  @override
  final String? password;

  @override
  String toString() {
    return 'Creator(id: $id, email: $email, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Creator &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.password, password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(password));

  @JsonKey(ignore: true)
  @override
  _$$_CreatorCopyWith<_$_Creator> get copyWith =>
      __$$_CreatorCopyWithImpl<_$_Creator>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CreatorToJson(
      this,
    );
  }
}

abstract class _Creator implements Creator {
  const factory _Creator(
      {@JsonKey(name: '_id') final String? id,
      final String? email,
      final String? password}) = _$_Creator;

  factory _Creator.fromJson(Map<String, dynamic> json) = _$_Creator.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get email;
  @override
  String? get password;
  @override
  @JsonKey(ignore: true)
  _$$_CreatorCopyWith<_$_Creator> get copyWith =>
      throw _privateConstructorUsedError;
}
