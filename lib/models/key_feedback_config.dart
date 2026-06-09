import 'package:freezed_annotation/freezed_annotation.dart';

part 'key_feedback_config.freezed.dart';
part 'key_feedback_config.g.dart';

@freezed
class KeyFeedbackConfig with _$KeyFeedbackConfig {
  const factory KeyFeedbackConfig({
    // ── 总开关 ──
    @Default(true) bool enabled,

    // ── 动画形式 ──
    @Default('bounce') String animationStyle,

    // ── 弹出位置 ──
    @Default('bottom') String originEdge,
    @Default('keyboardLayout') String originMapping,
    @Default(0.5) double globalOffsetX,
    @Default(0.08) double globalOffsetY,

    // ── 字符样式 ──
    @Default(48) int fontSize,
    @Default('加粗') String fontWeight,
    @Default('系统默认') String fontFamily,
    @Default('#F59E0B') String color,
    @Default(90) int opacity,
    @Default(false) bool uppercase,

    // ── 动画参数 ──
    @Default(900) int duration,
    @Default('弹跳') String easing,
    @Default(1.0) double scale,
    @Default(140) int bounceHeight,
    @Default(0.3) double gravity,
    @Default(0.0) double wind,

    // ── 特效增强 ──
    @Default(false) bool glow,
    @Default('#FBBF24') String glowColor,
    @Default(8.0) double glowRadius,
    @Default(false) bool trail,
    @Default(3) int trailLength,
    @Default(false) bool splash,

    // ── 高级 ──
    @Default(50) int cooldownMs,
    @Default(20) int maxSimultaneous,
    @Default(0) int delay,
  }) = _KeyFeedbackConfig;

  factory KeyFeedbackConfig.fromJson(Map<String, dynamic> json) =>
      _$KeyFeedbackConfigFromJson(json);
}
