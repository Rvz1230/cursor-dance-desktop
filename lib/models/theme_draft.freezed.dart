// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AtmosphereConfig _$AtmosphereConfigFromJson(Map<String, dynamic> json) {
  return _AtmosphereConfig.fromJson(json);
}

/// @nodoc
mixin _$AtmosphereConfig {
  String get mode => throw _privateConstructorUsedError;

  /// Serializes this AtmosphereConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AtmosphereConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AtmosphereConfigCopyWith<AtmosphereConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AtmosphereConfigCopyWith<$Res> {
  factory $AtmosphereConfigCopyWith(
    AtmosphereConfig value,
    $Res Function(AtmosphereConfig) then,
  ) = _$AtmosphereConfigCopyWithImpl<$Res, AtmosphereConfig>;
  @useResult
  $Res call({String mode});
}

/// @nodoc
class _$AtmosphereConfigCopyWithImpl<$Res, $Val extends AtmosphereConfig>
    implements $AtmosphereConfigCopyWith<$Res> {
  _$AtmosphereConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AtmosphereConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mode = null}) {
    return _then(
      _value.copyWith(
            mode: null == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AtmosphereConfigImplCopyWith<$Res>
    implements $AtmosphereConfigCopyWith<$Res> {
  factory _$$AtmosphereConfigImplCopyWith(
    _$AtmosphereConfigImpl value,
    $Res Function(_$AtmosphereConfigImpl) then,
  ) = __$$AtmosphereConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String mode});
}

/// @nodoc
class __$$AtmosphereConfigImplCopyWithImpl<$Res>
    extends _$AtmosphereConfigCopyWithImpl<$Res, _$AtmosphereConfigImpl>
    implements _$$AtmosphereConfigImplCopyWith<$Res> {
  __$$AtmosphereConfigImplCopyWithImpl(
    _$AtmosphereConfigImpl _value,
    $Res Function(_$AtmosphereConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AtmosphereConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mode = null}) {
    return _then(
      _$AtmosphereConfigImpl(
        mode: null == mode
            ? _value.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AtmosphereConfigImpl implements _AtmosphereConfig {
  const _$AtmosphereConfigImpl({this.mode = 'none'});

  factory _$AtmosphereConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AtmosphereConfigImplFromJson(json);

  @override
  @JsonKey()
  final String mode;

  @override
  String toString() {
    return 'AtmosphereConfig(mode: $mode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AtmosphereConfigImpl &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mode);

  /// Create a copy of AtmosphereConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AtmosphereConfigImplCopyWith<_$AtmosphereConfigImpl> get copyWith =>
      __$$AtmosphereConfigImplCopyWithImpl<_$AtmosphereConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AtmosphereConfigImplToJson(this);
  }
}

abstract class _AtmosphereConfig implements AtmosphereConfig {
  const factory _AtmosphereConfig({final String mode}) = _$AtmosphereConfigImpl;

  factory _AtmosphereConfig.fromJson(Map<String, dynamic> json) =
      _$AtmosphereConfigImpl.fromJson;

  @override
  String get mode;

  /// Create a copy of AtmosphereConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AtmosphereConfigImplCopyWith<_$AtmosphereConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CursorStateAsset _$CursorStateAssetFromJson(Map<String, dynamic> json) {
  return _CursorStateAsset.fromJson(json);
}

/// @nodoc
mixin _$CursorStateAsset {
  String get imageDataUrl => throw _privateConstructorUsedError;
  int get hotspotX => throw _privateConstructorUsedError;
  int get hotspotY => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;

  /// Serializes this CursorStateAsset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CursorStateAsset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CursorStateAssetCopyWith<CursorStateAsset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CursorStateAssetCopyWith<$Res> {
  factory $CursorStateAssetCopyWith(
    CursorStateAsset value,
    $Res Function(CursorStateAsset) then,
  ) = _$CursorStateAssetCopyWithImpl<$Res, CursorStateAsset>;
  @useResult
  $Res call({String imageDataUrl, int hotspotX, int hotspotY, int size});
}

/// @nodoc
class _$CursorStateAssetCopyWithImpl<$Res, $Val extends CursorStateAsset>
    implements $CursorStateAssetCopyWith<$Res> {
  _$CursorStateAssetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CursorStateAsset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageDataUrl = null,
    Object? hotspotX = null,
    Object? hotspotY = null,
    Object? size = null,
  }) {
    return _then(
      _value.copyWith(
            imageDataUrl: null == imageDataUrl
                ? _value.imageDataUrl
                : imageDataUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            hotspotX: null == hotspotX
                ? _value.hotspotX
                : hotspotX // ignore: cast_nullable_to_non_nullable
                      as int,
            hotspotY: null == hotspotY
                ? _value.hotspotY
                : hotspotY // ignore: cast_nullable_to_non_nullable
                      as int,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CursorStateAssetImplCopyWith<$Res>
    implements $CursorStateAssetCopyWith<$Res> {
  factory _$$CursorStateAssetImplCopyWith(
    _$CursorStateAssetImpl value,
    $Res Function(_$CursorStateAssetImpl) then,
  ) = __$$CursorStateAssetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String imageDataUrl, int hotspotX, int hotspotY, int size});
}

/// @nodoc
class __$$CursorStateAssetImplCopyWithImpl<$Res>
    extends _$CursorStateAssetCopyWithImpl<$Res, _$CursorStateAssetImpl>
    implements _$$CursorStateAssetImplCopyWith<$Res> {
  __$$CursorStateAssetImplCopyWithImpl(
    _$CursorStateAssetImpl _value,
    $Res Function(_$CursorStateAssetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CursorStateAsset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageDataUrl = null,
    Object? hotspotX = null,
    Object? hotspotY = null,
    Object? size = null,
  }) {
    return _then(
      _$CursorStateAssetImpl(
        imageDataUrl: null == imageDataUrl
            ? _value.imageDataUrl
            : imageDataUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        hotspotX: null == hotspotX
            ? _value.hotspotX
            : hotspotX // ignore: cast_nullable_to_non_nullable
                  as int,
        hotspotY: null == hotspotY
            ? _value.hotspotY
            : hotspotY // ignore: cast_nullable_to_non_nullable
                  as int,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CursorStateAssetImpl implements _CursorStateAsset {
  const _$CursorStateAssetImpl({
    this.imageDataUrl = '',
    this.hotspotX = 16,
    this.hotspotY = 32,
    this.size = 48,
  });

  factory _$CursorStateAssetImpl.fromJson(Map<String, dynamic> json) =>
      _$$CursorStateAssetImplFromJson(json);

  @override
  @JsonKey()
  final String imageDataUrl;
  @override
  @JsonKey()
  final int hotspotX;
  @override
  @JsonKey()
  final int hotspotY;
  @override
  @JsonKey()
  final int size;

  @override
  String toString() {
    return 'CursorStateAsset(imageDataUrl: $imageDataUrl, hotspotX: $hotspotX, hotspotY: $hotspotY, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CursorStateAssetImpl &&
            (identical(other.imageDataUrl, imageDataUrl) ||
                other.imageDataUrl == imageDataUrl) &&
            (identical(other.hotspotX, hotspotX) ||
                other.hotspotX == hotspotX) &&
            (identical(other.hotspotY, hotspotY) ||
                other.hotspotY == hotspotY) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, imageDataUrl, hotspotX, hotspotY, size);

  /// Create a copy of CursorStateAsset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CursorStateAssetImplCopyWith<_$CursorStateAssetImpl> get copyWith =>
      __$$CursorStateAssetImplCopyWithImpl<_$CursorStateAssetImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CursorStateAssetImplToJson(this);
  }
}

abstract class _CursorStateAsset implements CursorStateAsset {
  const factory _CursorStateAsset({
    final String imageDataUrl,
    final int hotspotX,
    final int hotspotY,
    final int size,
  }) = _$CursorStateAssetImpl;

  factory _CursorStateAsset.fromJson(Map<String, dynamic> json) =
      _$CursorStateAssetImpl.fromJson;

  @override
  String get imageDataUrl;
  @override
  int get hotspotX;
  @override
  int get hotspotY;
  @override
  int get size;

  /// Create a copy of CursorStateAsset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CursorStateAssetImplCopyWith<_$CursorStateAssetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
