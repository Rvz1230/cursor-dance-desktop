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

CursorStateEntry _$CursorStateEntryFromJson(Map<String, dynamic> json) {
  return _CursorStateEntry.fromJson(json);
}

/// @nodoc
mixin _$CursorStateEntry {
  /// Relative path under cursordance/cursors/ (e.g. "arrow.png")
  String get imagePath => throw _privateConstructorUsedError;
  String get imageFormat => throw _privateConstructorUsedError;
  int get hotspotX => throw _privateConstructorUsedError;
  int get hotspotY => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  bool get isAnimated => throw _privateConstructorUsedError;
  int get frameCount => throw _privateConstructorUsedError;
  int get fps => throw _privateConstructorUsedError;

  /// Serializes this CursorStateEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CursorStateEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CursorStateEntryCopyWith<CursorStateEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CursorStateEntryCopyWith<$Res> {
  factory $CursorStateEntryCopyWith(
    CursorStateEntry value,
    $Res Function(CursorStateEntry) then,
  ) = _$CursorStateEntryCopyWithImpl<$Res, CursorStateEntry>;
  @useResult
  $Res call({
    String imagePath,
    String imageFormat,
    int hotspotX,
    int hotspotY,
    int size,
    bool isAnimated,
    int frameCount,
    int fps,
  });
}

/// @nodoc
class _$CursorStateEntryCopyWithImpl<$Res, $Val extends CursorStateEntry>
    implements $CursorStateEntryCopyWith<$Res> {
  _$CursorStateEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CursorStateEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = null,
    Object? imageFormat = null,
    Object? hotspotX = null,
    Object? hotspotY = null,
    Object? size = null,
    Object? isAnimated = null,
    Object? frameCount = null,
    Object? fps = null,
  }) {
    return _then(
      _value.copyWith(
            imagePath: null == imagePath
                ? _value.imagePath
                : imagePath // ignore: cast_nullable_to_non_nullable
                      as String,
            imageFormat: null == imageFormat
                ? _value.imageFormat
                : imageFormat // ignore: cast_nullable_to_non_nullable
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
            isAnimated: null == isAnimated
                ? _value.isAnimated
                : isAnimated // ignore: cast_nullable_to_non_nullable
                      as bool,
            frameCount: null == frameCount
                ? _value.frameCount
                : frameCount // ignore: cast_nullable_to_non_nullable
                      as int,
            fps: null == fps
                ? _value.fps
                : fps // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CursorStateEntryImplCopyWith<$Res>
    implements $CursorStateEntryCopyWith<$Res> {
  factory _$$CursorStateEntryImplCopyWith(
    _$CursorStateEntryImpl value,
    $Res Function(_$CursorStateEntryImpl) then,
  ) = __$$CursorStateEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String imagePath,
    String imageFormat,
    int hotspotX,
    int hotspotY,
    int size,
    bool isAnimated,
    int frameCount,
    int fps,
  });
}

/// @nodoc
class __$$CursorStateEntryImplCopyWithImpl<$Res>
    extends _$CursorStateEntryCopyWithImpl<$Res, _$CursorStateEntryImpl>
    implements _$$CursorStateEntryImplCopyWith<$Res> {
  __$$CursorStateEntryImplCopyWithImpl(
    _$CursorStateEntryImpl _value,
    $Res Function(_$CursorStateEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CursorStateEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = null,
    Object? imageFormat = null,
    Object? hotspotX = null,
    Object? hotspotY = null,
    Object? size = null,
    Object? isAnimated = null,
    Object? frameCount = null,
    Object? fps = null,
  }) {
    return _then(
      _$CursorStateEntryImpl(
        imagePath: null == imagePath
            ? _value.imagePath
            : imagePath // ignore: cast_nullable_to_non_nullable
                  as String,
        imageFormat: null == imageFormat
            ? _value.imageFormat
            : imageFormat // ignore: cast_nullable_to_non_nullable
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
        isAnimated: null == isAnimated
            ? _value.isAnimated
            : isAnimated // ignore: cast_nullable_to_non_nullable
                  as bool,
        frameCount: null == frameCount
            ? _value.frameCount
            : frameCount // ignore: cast_nullable_to_non_nullable
                  as int,
        fps: null == fps
            ? _value.fps
            : fps // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CursorStateEntryImpl implements _CursorStateEntry {
  const _$CursorStateEntryImpl({
    this.imagePath = '',
    this.imageFormat = '',
    this.hotspotX = 0,
    this.hotspotY = 0,
    this.size = 48,
    this.isAnimated = false,
    this.frameCount = 0,
    this.fps = 0,
  });

  factory _$CursorStateEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CursorStateEntryImplFromJson(json);

  /// Relative path under cursordance/cursors/ (e.g. "arrow.png")
  @override
  @JsonKey()
  final String imagePath;
  @override
  @JsonKey()
  final String imageFormat;
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
  @JsonKey()
  final bool isAnimated;
  @override
  @JsonKey()
  final int frameCount;
  @override
  @JsonKey()
  final int fps;

  @override
  String toString() {
    return 'CursorStateEntry(imagePath: $imagePath, imageFormat: $imageFormat, hotspotX: $hotspotX, hotspotY: $hotspotY, size: $size, isAnimated: $isAnimated, frameCount: $frameCount, fps: $fps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CursorStateEntryImpl &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.imageFormat, imageFormat) ||
                other.imageFormat == imageFormat) &&
            (identical(other.hotspotX, hotspotX) ||
                other.hotspotX == hotspotX) &&
            (identical(other.hotspotY, hotspotY) ||
                other.hotspotY == hotspotY) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.isAnimated, isAnimated) ||
                other.isAnimated == isAnimated) &&
            (identical(other.frameCount, frameCount) ||
                other.frameCount == frameCount) &&
            (identical(other.fps, fps) || other.fps == fps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    imagePath,
    imageFormat,
    hotspotX,
    hotspotY,
    size,
    isAnimated,
    frameCount,
    fps,
  );

  /// Create a copy of CursorStateEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CursorStateEntryImplCopyWith<_$CursorStateEntryImpl> get copyWith =>
      __$$CursorStateEntryImplCopyWithImpl<_$CursorStateEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CursorStateEntryImplToJson(this);
  }
}

abstract class _CursorStateEntry implements CursorStateEntry {
  const factory _CursorStateEntry({
    final String imagePath,
    final String imageFormat,
    final int hotspotX,
    final int hotspotY,
    final int size,
    final bool isAnimated,
    final int frameCount,
    final int fps,
  }) = _$CursorStateEntryImpl;

  factory _CursorStateEntry.fromJson(Map<String, dynamic> json) =
      _$CursorStateEntryImpl.fromJson;

  /// Relative path under cursordance/cursors/ (e.g. "arrow.png")
  @override
  String get imagePath;
  @override
  String get imageFormat;
  @override
  int get hotspotX;
  @override
  int get hotspotY;
  @override
  int get size;
  @override
  bool get isAnimated;
  @override
  int get frameCount;
  @override
  int get fps;

  /// Create a copy of CursorStateEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CursorStateEntryImplCopyWith<_$CursorStateEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
