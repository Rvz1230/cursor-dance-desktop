import 'package:freezed_annotation/freezed_annotation.dart';

part 'key_feedback_config.freezed.dart';
part 'key_feedback_config.g.dart';

@freezed
class KeyFeedbackConfig with _$KeyFeedbackConfig {
  const factory KeyFeedbackConfig({
    @Default(false) bool enabled,
    @Default('bounce') String animationStyle,
    @Default('bottom') String originEdge,
    @Default('qwerty') String originMapping,
    @Default(0.0) double globalOffsetX,
    @Default(-20.0) double globalOffsetY,
    @Default(16) int fontSize,
    @Default('medium') String fontWeight,
    @Default('') String fontFamily,
    @Default('#F59E0B') String color,
    @Default(100) int opacity,
    @Default(true) bool uppercase,
    @Default(800) int duration,
    @Default('弹性') String easing,
    @Default(1.0) double scale,
    @Default(60) int bounceHeight,
    @Default(0.5) double gravity,
    @Default(0.0) double wind,
    @Default(false) bool glow,
    @Default('#F59E0B') String glowColor,
    @Default(8.0) double glowRadius,
    @Default(false) bool trail,
    @Default(3) int trailLength,
    @Default(false) bool splash,
    @Default(50) int cooldownMs,
    @Default(20) int maxSimultaneous,
    @Default(0) int delay,
  }) = _KeyFeedbackConfig;

  factory KeyFeedbackConfig.fromJson(Map<String, dynamic> json) =>
      _$KeyFeedbackConfigFromJson(json);
}
