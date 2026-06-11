// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_feedback_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KeyFeedbackConfigImpl _$$KeyFeedbackConfigImplFromJson(
  Map<String, dynamic> json,
) => _$KeyFeedbackConfigImpl(
  enabled: json['enabled'] as bool? ?? false,
  animationStyle: json['animationStyle'] as String? ?? 'bounce',
  originEdge: json['originEdge'] as String? ?? 'bottom',
  originMapping: json['originMapping'] as String? ?? 'qwerty',
  globalOffsetX: (json['globalOffsetX'] as num?)?.toDouble() ?? 0.0,
  globalOffsetY: (json['globalOffsetY'] as num?)?.toDouble() ?? -20.0,
  fontSize: (json['fontSize'] as num?)?.toInt() ?? 16,
  fontWeight: json['fontWeight'] as String? ?? 'medium',
  fontFamily: json['fontFamily'] as String? ?? '',
  color: json['color'] as String? ?? '#F59E0B',
  opacity: (json['opacity'] as num?)?.toInt() ?? 100,
  uppercase: json['uppercase'] as bool? ?? true,
  duration: (json['duration'] as num?)?.toInt() ?? 800,
  easing: json['easing'] as String? ?? '弹性',
  scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
  bounceHeight: (json['bounceHeight'] as num?)?.toInt() ?? 60,
  gravity: (json['gravity'] as num?)?.toDouble() ?? 0.5,
  wind: (json['wind'] as num?)?.toDouble() ?? 0.0,
  glow: json['glow'] as bool? ?? false,
  glowColor: json['glowColor'] as String? ?? '#F59E0B',
  glowRadius: (json['glowRadius'] as num?)?.toDouble() ?? 8.0,
  trail: json['trail'] as bool? ?? false,
  trailLength: (json['trailLength'] as num?)?.toInt() ?? 3,
  splash: json['splash'] as bool? ?? false,
  cooldownMs: (json['cooldownMs'] as num?)?.toInt() ?? 50,
  maxSimultaneous: (json['maxSimultaneous'] as num?)?.toInt() ?? 20,
  delay: (json['delay'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$KeyFeedbackConfigImplToJson(
  _$KeyFeedbackConfigImpl instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'animationStyle': instance.animationStyle,
  'originEdge': instance.originEdge,
  'originMapping': instance.originMapping,
  'globalOffsetX': instance.globalOffsetX,
  'globalOffsetY': instance.globalOffsetY,
  'fontSize': instance.fontSize,
  'fontWeight': instance.fontWeight,
  'fontFamily': instance.fontFamily,
  'color': instance.color,
  'opacity': instance.opacity,
  'uppercase': instance.uppercase,
  'duration': instance.duration,
  'easing': instance.easing,
  'scale': instance.scale,
  'bounceHeight': instance.bounceHeight,
  'gravity': instance.gravity,
  'wind': instance.wind,
  'glow': instance.glow,
  'glowColor': instance.glowColor,
  'glowRadius': instance.glowRadius,
  'trail': instance.trail,
  'trailLength': instance.trailLength,
  'splash': instance.splash,
  'cooldownMs': instance.cooldownMs,
  'maxSimultaneous': instance.maxSimultaneous,
  'delay': instance.delay,
};
