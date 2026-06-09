import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_config.freezed.dart';
part 'action_config.g.dart';

/// ~85 字段平铺配置，覆盖 8 大类效果 + 触发器 + 光标反馈。
/// 字段分组见下面的注释块。
///
/// 注意：所有 List/String/int/bool 都有默认值，
/// 因此 fromJson 中缺失的字段会被自动填充为默认值。
@freezed
class ActionConfig with _$ActionConfig {
  const factory ActionConfig({
    // ── Trigger ──
    @Default('抬起时') String triggerTiming,
    @Default('当前页面可点击区域') String triggerZone,
    @Default(0) int holdMs,

    // ── Text ──
    @Default(false) bool textEnabled,
    @Default('数字飘字') String textKind,
    @Default('阿拉伯数字 (1, 2, 3)') String textStyle,
    @Default('默认模式 (+1)') String textMode,
    @Default(r'${number}') String textTemplate,
    @Default('') String textContent,
    @Default([]) List<String> textTags,
    @Default('按顺序显示') String textTagPlayMode,
    @Default('#B45309') String textColor,
    @Default(1000) int textDuration,
    @Default('弹跳') String textEasing,
    @Default(100) int textOpacity,
    @Default('系统默认') String textFontFamily,
    @Default('加粗') String textWeight,
    @Default(0) int textOutlineWidth,
    @Default('柔和') String textShadow,
    @Default(false) bool comboEnabled,
    @Default(900) int comboWindowMs,
    @Default(0) int textOffsetX,
    @Default(-28) int textOffsetY,
    @Default(24) int fontSize,
    @Default(false) bool textGradient,
    @Default('#FBBF24') String textGradientStart,
    @Default('#EC4899') String textGradientEnd,
    @Default(0) int textDelay,

    // ── Particle ──
    @Default(false) bool particle,
    @Default(22) int particleCount,
    @Default(62) int particleSpread,
    @Default('点状粒子') String particleStyle,
    @Default('四周扩散') String particleDirection,
    @Default('跟随主题') String particleColorMode,
    @Default(780) int particleDuration,
    @Default(14) int particleSize,
    @Default(88) int particleOpacity,
    @Default(['#FBBF24', '#F59E0B', '#FDE68A', '#FCD34D', '#FEF3C7'])
    List<String> particlePalette,
    @Default(0) int particleGravity,
    @Default(0) int particleWind,
    @Default(0) int particleBounce,
    @Default(false) bool particleTrail,
    @Default(0) int particleDelay,
    @Default('burst') String particleMotionMode,
    @Default(6) int orbitalCount,
    @Default(32) int orbitalRadius,
    @Default(3) int orbitalSpeed,

    // ── Ripple ──
    @Default(false) bool ripple,
    @Default(72) int rippleSize,
    @Default(860) int rippleDuration,
    @Default('单环') String rippleStyle,
    @Default('缓出') String rippleEasing,
    @Default(2) int rippleLineWidth,
    @Default(72) int rippleOpacity,
    @Default('#F59E0B') String rippleColor,
    @Default(0) int rippleDelay,

    // ── Audio ──
    @Default(false) bool sound,
    @Default('woodfish-soft.wav') String soundFile,
    @Default(72) int volume,
    @Default(100) int playbackRate,
    @Default(0) int soundDelay,
    @Default(80) int soundFadeOut,
    @Default('每次触发') String soundTriggerMode,
    @Default('保持原音量') String soundBlendMode,

    // ── Animation ──
    @Default(false) bool animationEnabled,
    @Default('聚焦脉冲') String animationStyle,
    @Default(720) int animationDuration,
    @Default('缓出') String animationEasing,
    @Default(100) int animationScale,
    @Default(100) int animationOpacity,
    @Default(0) int animationOffsetX,
    @Default(-10) int animationOffsetY,
    @Default('#F59E0B') String animationColor,
    @Default(false) bool animationGlow,
    @Default(0) int animationDelay,

    // ── Image ──
    @Default(false) bool imageEnabled,
    @Default('') String imageDataUrl,
    @Default(780) int imageDuration,
    @Default(56) int imageSize,
    @Default(100) int imageOpacity,
    @Default(0) int imageOffsetX,
    @Default(-18) int imageOffsetY,
    @Default(0) int imageDelay,

    // ── Cursor Feedback ──
    @Default(0) int shake,
    @Default('跟随当前状态') String cursorOverride,
    @Default(48) int cursorSize,
    @Default(false) bool cursorTrailEnabled,
    @Default(5) int cursorTrailCount,
    @Default(50) int cursorTrailOpacity,
    @Default('') String cursorGlowColor,
  }) = _ActionConfig;

  factory ActionConfig.fromJson(Map<String, dynamic> json) =>
      _$ActionConfigFromJson(json);
}
