// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ThemeItem _$ThemeItemFromJson(Map<String, dynamic> json) {
  return _ThemeItem.fromJson(json);
}

/// @nodoc
mixin _$ThemeItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get kind => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this ThemeItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ThemeItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ThemeItemCopyWith<ThemeItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeItemCopyWith<$Res> {
  factory $ThemeItemCopyWith(ThemeItem value, $Res Function(ThemeItem) then) =
      _$ThemeItemCopyWithImpl<$Res, ThemeItem>;
  @useResult
  $Res call({
    String id,
    String name,
    String kind,
    String icon,
    String summary,
    String description,
  });
}

/// @nodoc
class _$ThemeItemCopyWithImpl<$Res, $Val extends ThemeItem>
    implements $ThemeItemCopyWith<$Res> {
  _$ThemeItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ThemeItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? kind = null,
    Object? icon = null,
    Object? summary = null,
    Object? description = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            kind: null == kind
                ? _value.kind
                : kind // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ThemeItemImplCopyWith<$Res>
    implements $ThemeItemCopyWith<$Res> {
  factory _$$ThemeItemImplCopyWith(
    _$ThemeItemImpl value,
    $Res Function(_$ThemeItemImpl) then,
  ) = __$$ThemeItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String kind,
    String icon,
    String summary,
    String description,
  });
}

/// @nodoc
class __$$ThemeItemImplCopyWithImpl<$Res>
    extends _$ThemeItemCopyWithImpl<$Res, _$ThemeItemImpl>
    implements _$$ThemeItemImplCopyWith<$Res> {
  __$$ThemeItemImplCopyWithImpl(
    _$ThemeItemImpl _value,
    $Res Function(_$ThemeItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ThemeItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? kind = null,
    Object? icon = null,
    Object? summary = null,
    Object? description = null,
  }) {
    return _then(
      _$ThemeItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        kind: null == kind
            ? _value.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ThemeItemImpl implements _ThemeItem {
  const _$ThemeItemImpl({
    required this.id,
    required this.name,
    this.kind = '内置',
    this.icon = 'Wand2',
    this.summary = '',
    this.description = '',
  });

  factory _$ThemeItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThemeItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String kind;
  @override
  @JsonKey()
  final String icon;
  @override
  @JsonKey()
  final String summary;
  @override
  @JsonKey()
  final String description;

  @override
  String toString() {
    return 'ThemeItem(id: $id, name: $name, kind: $kind, icon: $icon, summary: $summary, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, kind, icon, summary, description);

  /// Create a copy of ThemeItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeItemImplCopyWith<_$ThemeItemImpl> get copyWith =>
      __$$ThemeItemImplCopyWithImpl<_$ThemeItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThemeItemImplToJson(this);
  }
}

abstract class _ThemeItem implements ThemeItem {
  const factory _ThemeItem({
    required final String id,
    required final String name,
    final String kind,
    final String icon,
    final String summary,
    final String description,
  }) = _$ThemeItemImpl;

  factory _ThemeItem.fromJson(Map<String, dynamic> json) =
      _$ThemeItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get kind;
  @override
  String get icon;
  @override
  String get summary;
  @override
  String get description;

  /// Create a copy of ThemeItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ThemeItemImplCopyWith<_$ThemeItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
