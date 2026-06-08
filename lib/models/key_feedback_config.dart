class KeyFeedbackConfig {
  // ── 总开关 ──
  final bool enabled;

  // ── 动画形式 ──
  final String animationStyle; // 'bounce' | 'raindrop'

  // ── 弹出位置 ──
  final String originEdge;       // 'bottom' | 'top' | 'left' | 'right'
  final String originMapping;    // 'keyboardLayout' | 'center'
  final double globalOffsetX;    // 0~1, only when originMapping != 'keyboardLayout'
  final double globalOffsetY;    // 0~1

  // ── 字符样式 ──
  final int fontSize;            // 12~120
  final String fontWeight;       // '标准' | '中等' | '半粗' | '加粗'
  final String fontFamily;       // '系统默认' | 'SF Mono' | 'SF Pro Rounded'
  final String color;            // hex
  final int opacity;             // 0~100
  final bool uppercase;          // 强制大写

  // ── 动画参数 ──
  final int duration;            // ms
  final String easing;           // '弹跳' | '缓出' | '缓入' | '线性' | '弹性'
  final double scale;            // 0.5~3.0
  final int bounceHeight;        // px (bounce mode)
  final double gravity;          // 0~1 (raindrop mode)
  final double wind;             // -1~1 (raindrop mode)

  // ── 特效增强 ──
  final bool glow;
  final String glowColor;
  final double glowRadius;
  final bool trail;
  final int trailLength;         // 1~10
  final bool splash;             // 落地溅射 (raindrop mode)

  // ── 高级 ──
  final int cooldownMs;          // 冷却时间 ms
  final int maxSimultaneous;     // 最大同时显示数量
  final int delay;               // 延迟 ms

  const KeyFeedbackConfig({
    this.enabled = true,
    this.animationStyle = 'bounce',
    this.originEdge = 'bottom',
    this.originMapping = 'keyboardLayout',
    this.globalOffsetX = 0.5,
    this.globalOffsetY = 0.08,
    this.fontSize = 48,
    this.fontWeight = '加粗',
    this.fontFamily = '系统默认',
    this.color = '#F59E0B',
    this.opacity = 90,
    this.uppercase = false,
    this.duration = 900,
    this.easing = '弹跳',
    this.scale = 1.0,
    this.bounceHeight = 140,
    this.gravity = 0.3,
    this.wind = 0.0,
    this.glow = false,
    this.glowColor = '#FBBF24',
    this.glowRadius = 8.0,
    this.trail = false,
    this.trailLength = 3,
    this.splash = false,
    this.cooldownMs = 50,
    this.maxSimultaneous = 20,
    this.delay = 0,
  });

  KeyFeedbackConfig copyWith({
    bool? enabled,
    String? animationStyle,
    String? originEdge,
    String? originMapping,
    double? globalOffsetX,
    double? globalOffsetY,
    int? fontSize,
    String? fontWeight,
    String? fontFamily,
    String? color,
    int? opacity,
    bool? uppercase,
    int? duration,
    String? easing,
    double? scale,
    int? bounceHeight,
    double? gravity,
    double? wind,
    bool? glow,
    String? glowColor,
    double? glowRadius,
    bool? trail,
    int? trailLength,
    bool? splash,
    int? cooldownMs,
    int? maxSimultaneous,
    int? delay,
  }) {
    return KeyFeedbackConfig(
      enabled: enabled ?? this.enabled,
      animationStyle: animationStyle ?? this.animationStyle,
      originEdge: originEdge ?? this.originEdge,
      originMapping: originMapping ?? this.originMapping,
      globalOffsetX: globalOffsetX ?? this.globalOffsetX,
      globalOffsetY: globalOffsetY ?? this.globalOffsetY,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      fontFamily: fontFamily ?? this.fontFamily,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      uppercase: uppercase ?? this.uppercase,
      duration: duration ?? this.duration,
      easing: easing ?? this.easing,
      scale: scale ?? this.scale,
      bounceHeight: bounceHeight ?? this.bounceHeight,
      gravity: gravity ?? this.gravity,
      wind: wind ?? this.wind,
      glow: glow ?? this.glow,
      glowColor: glowColor ?? this.glowColor,
      glowRadius: glowRadius ?? this.glowRadius,
      trail: trail ?? this.trail,
      trailLength: trailLength ?? this.trailLength,
      splash: splash ?? this.splash,
      cooldownMs: cooldownMs ?? this.cooldownMs,
      maxSimultaneous: maxSimultaneous ?? this.maxSimultaneous,
      delay: delay ?? this.delay,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'animationStyle': animationStyle,
    'originEdge': originEdge,
    'originMapping': originMapping,
    'globalOffsetX': globalOffsetX,
    'globalOffsetY': globalOffsetY,
    'fontSize': fontSize,
    'fontWeight': fontWeight,
    'fontFamily': fontFamily,
    'color': color,
    'opacity': opacity,
    'uppercase': uppercase,
    'duration': duration,
    'easing': easing,
    'scale': scale,
    'bounceHeight': bounceHeight,
    'gravity': gravity,
    'wind': wind,
    'glow': glow,
    'glowColor': glowColor,
    'glowRadius': glowRadius,
    'trail': trail,
    'trailLength': trailLength,
    'splash': splash,
    'cooldownMs': cooldownMs,
    'maxSimultaneous': maxSimultaneous,
    'delay': delay,
  };

  factory KeyFeedbackConfig.fromJson(Map<String, dynamic> json) {
    return KeyFeedbackConfig(
      enabled: json['enabled'] as bool? ?? false,
      animationStyle: json['animationStyle'] as String? ?? 'bounce',
      originEdge: json['originEdge'] as String? ?? 'bottom',
      originMapping: json['originMapping'] as String? ?? 'keyboardLayout',
      globalOffsetX: (json['globalOffsetX'] as num?)?.toDouble() ?? 0.5,
      globalOffsetY: (json['globalOffsetY'] as num?)?.toDouble() ?? 0.08,
      fontSize: json['fontSize'] as int? ?? 48,
      fontWeight: json['fontWeight'] as String? ?? '加粗',
      fontFamily: json['fontFamily'] as String? ?? '系统默认',
      color: json['color'] as String? ?? '#F59E0B',
      opacity: json['opacity'] as int? ?? 90,
      uppercase: json['uppercase'] as bool? ?? false,
      duration: json['duration'] as int? ?? 900,
      easing: json['easing'] as String? ?? '弹跳',
      scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
      bounceHeight: json['bounceHeight'] as int? ?? 140,
      gravity: (json['gravity'] as num?)?.toDouble() ?? 0.3,
      wind: (json['wind'] as num?)?.toDouble() ?? 0.0,
      glow: json['glow'] as bool? ?? false,
      glowColor: json['glowColor'] as String? ?? '#FBBF24',
      glowRadius: (json['glowRadius'] as num?)?.toDouble() ?? 8.0,
      trail: json['trail'] as bool? ?? false,
      trailLength: json['trailLength'] as int? ?? 3,
      splash: json['splash'] as bool? ?? false,
      cooldownMs: json['cooldownMs'] as int? ?? 50,
      maxSimultaneous: json['maxSimultaneous'] as int? ?? 20,
      delay: json['delay'] as int? ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeyFeedbackConfig &&
          enabled == other.enabled &&
          animationStyle == other.animationStyle &&
          originEdge == other.originEdge &&
          originMapping == other.originMapping &&
          globalOffsetX == other.globalOffsetX &&
          globalOffsetY == other.globalOffsetY &&
          fontSize == other.fontSize &&
          fontWeight == other.fontWeight &&
          fontFamily == other.fontFamily &&
          color == other.color &&
          opacity == other.opacity &&
          uppercase == other.uppercase &&
          duration == other.duration &&
          easing == other.easing &&
          scale == other.scale &&
          bounceHeight == other.bounceHeight &&
          gravity == other.gravity &&
          wind == other.wind &&
          glow == other.glow &&
          glowColor == other.glowColor &&
          glowRadius == other.glowRadius &&
          trail == other.trail &&
          trailLength == other.trailLength &&
          splash == other.splash &&
          cooldownMs == other.cooldownMs &&
          maxSimultaneous == other.maxSimultaneous &&
          delay == other.delay;

  @override
  int get hashCode => Object.hashAll([
    enabled, animationStyle, originEdge, originMapping,
    globalOffsetX, globalOffsetY,
    fontSize, fontWeight, fontFamily, color, opacity, uppercase,
    duration, easing, scale, bounceHeight, gravity, wind,
    glow, glowColor, glowRadius, trail, trailLength, splash,
    cooldownMs, maxSimultaneous, delay,
  ]);

  @override
  String toString() => 'KeyFeedbackConfig(${toJson()})';
}
