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

_$CursorStateAssetImpl _$$CursorStateAssetImplFromJson(
  Map<String, dynamic> json,
) => _$CursorStateAssetImpl(
  imageDataUrl: json['imageDataUrl'] as String? ?? '',
  hotspotX: (json['hotspotX'] as num?)?.toInt() ?? 16,
  hotspotY: (json['hotspotY'] as num?)?.toInt() ?? 32,
  size: (json['size'] as num?)?.toInt() ?? 48,
);

Map<String, dynamic> _$$CursorStateAssetImplToJson(
  _$CursorStateAssetImpl instance,
) => <String, dynamic>{
  'imageDataUrl': instance.imageDataUrl,
  'hotspotX': instance.hotspotX,
  'hotspotY': instance.hotspotY,
  'size': instance.size,
};
