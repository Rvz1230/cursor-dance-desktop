// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AtmosphereConfigImpl _$$AtmosphereConfigImplFromJson(
  Map<String, dynamic> json,
) => _$AtmosphereConfigImpl(mode: json['mode'] as String? ?? 'none');

Map<String, dynamic> _$$AtmosphereConfigImplToJson(
  _$AtmosphereConfigImpl instance,
) => <String, dynamic>{'mode': instance.mode};

_$CursorStateEntryImpl _$$CursorStateEntryImplFromJson(
  Map<String, dynamic> json,
) => _$CursorStateEntryImpl(
  imagePath: json['imagePath'] as String? ?? '',
  imageFormat: json['imageFormat'] as String? ?? '',
  hotspotX: (json['hotspotX'] as num?)?.toInt() ?? 0,
  hotspotY: (json['hotspotY'] as num?)?.toInt() ?? 0,
  size: (json['size'] as num?)?.toInt() ?? 48,
  isAnimated: json['isAnimated'] as bool? ?? false,
  frameCount: (json['frameCount'] as num?)?.toInt() ?? 0,
  fps: (json['fps'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$CursorStateEntryImplToJson(
  _$CursorStateEntryImpl instance,
) => <String, dynamic>{
  'imagePath': instance.imagePath,
  'imageFormat': instance.imageFormat,
  'hotspotX': instance.hotspotX,
  'hotspotY': instance.hotspotY,
  'size': instance.size,
  'isAnimated': instance.isAnimated,
  'frameCount': instance.frameCount,
  'fps': instance.fps,
};
