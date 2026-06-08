class ActionConfig {
  // ── Trigger ──
  final String triggerTiming;
  final String triggerZone;
  final int holdMs;

  // ── Text ──
  final bool textEnabled;
  final String textKind;
  final String textStyle;
  final String textMode;
  final String textTemplate;
  final String textContent;
  final List<String> textTags;
  final String textTagPlayMode;
  final String textColor;
  final int textDuration;
  final String textEasing;
  final int textOpacity;
  final String textFontFamily;
  final String textWeight;
  final int textOutlineWidth;
  final String textShadow;
  final bool comboEnabled;
  final int comboWindowMs;
  final int textOffsetX;
  final int textOffsetY;
  final int fontSize;
  final bool textGradient;
  final String textGradientStart;
  final String textGradientEnd;
  final int textDelay;

  // ── Particle ──
  final bool particle;
  final int particleCount;
  final int particleSpread;
  final String particleStyle;
  final String particleDirection;
  final String particleColorMode;
  final int particleDuration;
  final int particleSize;
  final int particleOpacity;
  final List<String> particlePalette;
  final int particleGravity;
  final int particleWind;
  final int particleBounce;
  final bool particleTrail;
  final int particleDelay;
  final String particleMotionMode;
  final int orbitalCount;
  final int orbitalRadius;
  final int orbitalSpeed;

  // ── Ripple ──
  final bool ripple;
  final int rippleSize;
  final int rippleDuration;
  final String rippleStyle;
  final String rippleEasing;
  final int rippleLineWidth;
  final int rippleOpacity;
  final String rippleColor;
  final int rippleDelay;

  // ── Audio ──
  final bool sound;
  final String soundFile;
  final int volume;
  final int playbackRate;
  final int soundDelay;
  final int soundFadeOut;
  final String soundTriggerMode;
  final String soundBlendMode;

  // ── Animation ──
  final bool animationEnabled;
  final String animationStyle;
  final int animationDuration;
  final String animationEasing;
  final int animationScale;
  final int animationOpacity;
  final int animationOffsetX;
  final int animationOffsetY;
  final String animationColor;
  final bool animationGlow;
  final int animationDelay;

  // ── Image ──
  final bool imageEnabled;
  final String imageDataUrl;
  final int imageDuration;
  final int imageSize;
  final int imageOpacity;
  final int imageOffsetX;
  final int imageOffsetY;
  final int imageDelay;

  // ── Cursor Feedback ──
  final int shake;
  final String cursorOverride;
  final int cursorSize;
  final bool cursorTrailEnabled;
  final int cursorTrailCount;
  final int cursorTrailOpacity;
  final String cursorGlowColor;

  const ActionConfig({
    // Trigger
    this.triggerTiming = '抬起时',
    this.triggerZone = '当前页面可点击区域',
    this.holdMs = 0,
    // Text
    this.textEnabled = false,
    this.textKind = '数字飘字',
    this.textStyle = '阿拉伯数字 (1, 2, 3)',
    this.textMode = '默认模式 (+1)',
    this.textTemplate = r'${number}',
    this.textContent = '',
    this.textTags = const [],
    this.textTagPlayMode = '按顺序显示',
    this.textColor = '#B45309',
    this.textDuration = 1000,
    this.textEasing = '弹跳',
    this.textOpacity = 100,
    this.textFontFamily = '系统默认',
    this.textWeight = '加粗',
    this.textOutlineWidth = 0,
    this.textShadow = '柔和',
    this.comboEnabled = false,
    this.comboWindowMs = 900,
    this.textOffsetX = 0,
    this.textOffsetY = -28,
    this.fontSize = 24,
    this.textGradient = false,
    this.textGradientStart = '#FBBF24',
    this.textGradientEnd = '#EC4899',
    this.textDelay = 0,
    // Particle
    this.particle = false,
    this.particleCount = 22,
    this.particleSpread = 62,
    this.particleStyle = '点状粒子',
    this.particleDirection = '四周扩散',
    this.particleColorMode = '跟随主题',
    this.particleDuration = 780,
    this.particleSize = 14,
    this.particleOpacity = 88,
    this.particlePalette = const ['#FBBF24', '#F59E0B', '#FDE68A', '#FCD34D', '#FEF3C7'],
    this.particleGravity = 0,
    this.particleWind = 0,
    this.particleBounce = 0,
    this.particleTrail = false,
    this.particleDelay = 0,
    this.particleMotionMode = 'burst',
    this.orbitalCount = 6,
    this.orbitalRadius = 32,
    this.orbitalSpeed = 3,
    // Ripple
    this.ripple = false,
    this.rippleSize = 72,
    this.rippleDuration = 860,
    this.rippleStyle = '单环',
    this.rippleEasing = '缓出',
    this.rippleLineWidth = 2,
    this.rippleOpacity = 72,
    this.rippleColor = '#F59E0B',
    this.rippleDelay = 0,
    // Audio
    this.sound = false,
    this.soundFile = 'woodfish-soft.wav',
    this.volume = 72,
    this.playbackRate = 100,
    this.soundDelay = 0,
    this.soundFadeOut = 80,
    this.soundTriggerMode = '每次触发',
    this.soundBlendMode = '保持原音量',
    // Animation
    this.animationEnabled = false,
    this.animationStyle = '聚焦脉冲',
    this.animationDuration = 720,
    this.animationEasing = '缓出',
    this.animationScale = 100,
    this.animationOpacity = 100,
    this.animationOffsetX = 0,
    this.animationOffsetY = -10,
    this.animationColor = '#F59E0B',
    this.animationGlow = false,
    this.animationDelay = 0,
    // Image
    this.imageEnabled = false,
    this.imageDataUrl = '',
    this.imageDuration = 780,
    this.imageSize = 56,
    this.imageOpacity = 100,
    this.imageOffsetX = 0,
    this.imageOffsetY = -18,
    this.imageDelay = 0,
    // Cursor Feedback
    this.shake = 0,
    this.cursorOverride = '跟随当前状态',
    this.cursorSize = 48,
    this.cursorTrailEnabled = false,
    this.cursorTrailCount = 5,
    this.cursorTrailOpacity = 50,
    this.cursorGlowColor = '',
  });

  ActionConfig copyWith({
    String? triggerTiming,
    String? triggerZone,
    int? holdMs,
    bool? textEnabled,
    String? textKind,
    String? textStyle,
    String? textMode,
    String? textTemplate,
    String? textContent,
    List<String>? textTags,
    String? textTagPlayMode,
    String? textColor,
    int? textDuration,
    String? textEasing,
    int? textOpacity,
    String? textFontFamily,
    String? textWeight,
    int? textOutlineWidth,
    String? textShadow,
    bool? comboEnabled,
    int? comboWindowMs,
    int? textOffsetX,
    int? textOffsetY,
    int? fontSize,
    bool? textGradient,
    String? textGradientStart,
    String? textGradientEnd,
    int? textDelay,
    bool? particle,
    int? particleCount,
    int? particleSpread,
    String? particleStyle,
    String? particleDirection,
    String? particleColorMode,
    int? particleDuration,
    int? particleSize,
    int? particleOpacity,
    List<String>? particlePalette,
    int? particleGravity,
    int? particleWind,
    int? particleBounce,
    bool? particleTrail,
    int? particleDelay,
    String? particleMotionMode,
    int? orbitalCount,
    int? orbitalRadius,
    int? orbitalSpeed,
    bool? ripple,
    int? rippleSize,
    int? rippleDuration,
    String? rippleStyle,
    String? rippleEasing,
    int? rippleLineWidth,
    int? rippleOpacity,
    String? rippleColor,
    int? rippleDelay,
    bool? sound,
    String? soundFile,
    int? volume,
    int? playbackRate,
    int? soundDelay,
    int? soundFadeOut,
    String? soundTriggerMode,
    String? soundBlendMode,
    bool? animationEnabled,
    String? animationStyle,
    int? animationDuration,
    String? animationEasing,
    int? animationScale,
    int? animationOpacity,
    int? animationOffsetX,
    int? animationOffsetY,
    String? animationColor,
    bool? animationGlow,
    int? animationDelay,
    bool? imageEnabled,
    String? imageDataUrl,
    int? imageDuration,
    int? imageSize,
    int? imageOpacity,
    int? imageOffsetX,
    int? imageOffsetY,
    int? imageDelay,
    int? shake,
    String? cursorOverride,
    int? cursorSize,
    bool? cursorTrailEnabled,
    int? cursorTrailCount,
    int? cursorTrailOpacity,
    String? cursorGlowColor,
  }) {
    return ActionConfig(
      triggerTiming: triggerTiming ?? this.triggerTiming,
      triggerZone: triggerZone ?? this.triggerZone,
      holdMs: holdMs ?? this.holdMs,
      textEnabled: textEnabled ?? this.textEnabled,
      textKind: textKind ?? this.textKind,
      textStyle: textStyle ?? this.textStyle,
      textMode: textMode ?? this.textMode,
      textTemplate: textTemplate ?? this.textTemplate,
      textContent: textContent ?? this.textContent,
      textTags: textTags ?? this.textTags,
      textTagPlayMode: textTagPlayMode ?? this.textTagPlayMode,
      textColor: textColor ?? this.textColor,
      textDuration: textDuration ?? this.textDuration,
      textEasing: textEasing ?? this.textEasing,
      textOpacity: textOpacity ?? this.textOpacity,
      textFontFamily: textFontFamily ?? this.textFontFamily,
      textWeight: textWeight ?? this.textWeight,
      textOutlineWidth: textOutlineWidth ?? this.textOutlineWidth,
      textShadow: textShadow ?? this.textShadow,
      comboEnabled: comboEnabled ?? this.comboEnabled,
      comboWindowMs: comboWindowMs ?? this.comboWindowMs,
      textOffsetX: textOffsetX ?? this.textOffsetX,
      textOffsetY: textOffsetY ?? this.textOffsetY,
      fontSize: fontSize ?? this.fontSize,
      textGradient: textGradient ?? this.textGradient,
      textGradientStart: textGradientStart ?? this.textGradientStart,
      textGradientEnd: textGradientEnd ?? this.textGradientEnd,
      textDelay: textDelay ?? this.textDelay,
      particle: particle ?? this.particle,
      particleCount: particleCount ?? this.particleCount,
      particleSpread: particleSpread ?? this.particleSpread,
      particleStyle: particleStyle ?? this.particleStyle,
      particleDirection: particleDirection ?? this.particleDirection,
      particleColorMode: particleColorMode ?? this.particleColorMode,
      particleDuration: particleDuration ?? this.particleDuration,
      particleSize: particleSize ?? this.particleSize,
      particleOpacity: particleOpacity ?? this.particleOpacity,
      particlePalette: particlePalette ?? this.particlePalette,
      particleGravity: particleGravity ?? this.particleGravity,
      particleWind: particleWind ?? this.particleWind,
      particleBounce: particleBounce ?? this.particleBounce,
      particleTrail: particleTrail ?? this.particleTrail,
      particleDelay: particleDelay ?? this.particleDelay,
      particleMotionMode: particleMotionMode ?? this.particleMotionMode,
      orbitalCount: orbitalCount ?? this.orbitalCount,
      orbitalRadius: orbitalRadius ?? this.orbitalRadius,
      orbitalSpeed: orbitalSpeed ?? this.orbitalSpeed,
      ripple: ripple ?? this.ripple,
      rippleSize: rippleSize ?? this.rippleSize,
      rippleDuration: rippleDuration ?? this.rippleDuration,
      rippleStyle: rippleStyle ?? this.rippleStyle,
      rippleEasing: rippleEasing ?? this.rippleEasing,
      rippleLineWidth: rippleLineWidth ?? this.rippleLineWidth,
      rippleOpacity: rippleOpacity ?? this.rippleOpacity,
      rippleColor: rippleColor ?? this.rippleColor,
      rippleDelay: rippleDelay ?? this.rippleDelay,
      sound: sound ?? this.sound,
      soundFile: soundFile ?? this.soundFile,
      volume: volume ?? this.volume,
      playbackRate: playbackRate ?? this.playbackRate,
      soundDelay: soundDelay ?? this.soundDelay,
      soundFadeOut: soundFadeOut ?? this.soundFadeOut,
      soundTriggerMode: soundTriggerMode ?? this.soundTriggerMode,
      soundBlendMode: soundBlendMode ?? this.soundBlendMode,
      animationEnabled: animationEnabled ?? this.animationEnabled,
      animationStyle: animationStyle ?? this.animationStyle,
      animationDuration: animationDuration ?? this.animationDuration,
      animationEasing: animationEasing ?? this.animationEasing,
      animationScale: animationScale ?? this.animationScale,
      animationOpacity: animationOpacity ?? this.animationOpacity,
      animationOffsetX: animationOffsetX ?? this.animationOffsetX,
      animationOffsetY: animationOffsetY ?? this.animationOffsetY,
      animationColor: animationColor ?? this.animationColor,
      animationGlow: animationGlow ?? this.animationGlow,
      animationDelay: animationDelay ?? this.animationDelay,
      imageEnabled: imageEnabled ?? this.imageEnabled,
      imageDataUrl: imageDataUrl ?? this.imageDataUrl,
      imageDuration: imageDuration ?? this.imageDuration,
      imageSize: imageSize ?? this.imageSize,
      imageOpacity: imageOpacity ?? this.imageOpacity,
      imageOffsetX: imageOffsetX ?? this.imageOffsetX,
      imageOffsetY: imageOffsetY ?? this.imageOffsetY,
      imageDelay: imageDelay ?? this.imageDelay,
      shake: shake ?? this.shake,
      cursorOverride: cursorOverride ?? this.cursorOverride,
      cursorSize: cursorSize ?? this.cursorSize,
      cursorTrailEnabled: cursorTrailEnabled ?? this.cursorTrailEnabled,
      cursorTrailCount: cursorTrailCount ?? this.cursorTrailCount,
      cursorTrailOpacity: cursorTrailOpacity ?? this.cursorTrailOpacity,
      cursorGlowColor: cursorGlowColor ?? this.cursorGlowColor,
    );
  }

  Map<String, dynamic> toJson() => {
    'triggerTiming': triggerTiming,
    'triggerZone': triggerZone,
    'holdMs': holdMs,
    'textEnabled': textEnabled,
    'textKind': textKind,
    'textStyle': textStyle,
    'textMode': textMode,
    'textTemplate': textTemplate,
    'textContent': textContent,
    'textTags': textTags,
    'textTagPlayMode': textTagPlayMode,
    'textColor': textColor,
    'textDuration': textDuration,
    'textEasing': textEasing,
    'textOpacity': textOpacity,
    'textFontFamily': textFontFamily,
    'textWeight': textWeight,
    'textOutlineWidth': textOutlineWidth,
    'textShadow': textShadow,
    'comboEnabled': comboEnabled,
    'comboWindowMs': comboWindowMs,
    'textOffsetX': textOffsetX,
    'textOffsetY': textOffsetY,
    'fontSize': fontSize,
    'textGradient': textGradient,
    'textGradientStart': textGradientStart,
    'textGradientEnd': textGradientEnd,
    'textDelay': textDelay,
    'particle': particle,
    'particleCount': particleCount,
    'particleSpread': particleSpread,
    'particleStyle': particleStyle,
    'particleDirection': particleDirection,
    'particleColorMode': particleColorMode,
    'particleDuration': particleDuration,
    'particleSize': particleSize,
    'particleOpacity': particleOpacity,
    'particlePalette': particlePalette,
    'particleGravity': particleGravity,
    'particleWind': particleWind,
    'particleBounce': particleBounce,
    'particleTrail': particleTrail,
    'particleDelay': particleDelay,
    'particleMotionMode': particleMotionMode,
    'orbitalCount': orbitalCount,
    'orbitalRadius': orbitalRadius,
    'orbitalSpeed': orbitalSpeed,
    'ripple': ripple,
    'rippleSize': rippleSize,
    'rippleDuration': rippleDuration,
    'rippleStyle': rippleStyle,
    'rippleEasing': rippleEasing,
    'rippleLineWidth': rippleLineWidth,
    'rippleOpacity': rippleOpacity,
    'rippleColor': rippleColor,
    'rippleDelay': rippleDelay,
    'sound': sound,
    'soundFile': soundFile,
    'volume': volume,
    'playbackRate': playbackRate,
    'soundDelay': soundDelay,
    'soundFadeOut': soundFadeOut,
    'soundTriggerMode': soundTriggerMode,
    'soundBlendMode': soundBlendMode,
    'animationEnabled': animationEnabled,
    'animationStyle': animationStyle,
    'animationDuration': animationDuration,
    'animationEasing': animationEasing,
    'animationScale': animationScale,
    'animationOpacity': animationOpacity,
    'animationOffsetX': animationOffsetX,
    'animationOffsetY': animationOffsetY,
    'animationColor': animationColor,
    'animationGlow': animationGlow,
    'animationDelay': animationDelay,
    'imageEnabled': imageEnabled,
    'imageDataUrl': imageDataUrl,
    'imageDuration': imageDuration,
    'imageSize': imageSize,
    'imageOpacity': imageOpacity,
    'imageOffsetX': imageOffsetX,
    'imageOffsetY': imageOffsetY,
    'imageDelay': imageDelay,
    'shake': shake,
    'cursorOverride': cursorOverride,
    'cursorSize': cursorSize,
    'cursorTrailEnabled': cursorTrailEnabled,
    'cursorTrailCount': cursorTrailCount,
    'cursorTrailOpacity': cursorTrailOpacity,
    'cursorGlowColor': cursorGlowColor,
  };

  factory ActionConfig.fromJson(Map<String, dynamic> json) {
    return ActionConfig(
      triggerTiming: json['triggerTiming'] as String? ?? '抬起时',
      triggerZone: json['triggerZone'] as String? ?? '当前页面可点击区域',
      holdMs: json['holdMs'] as int? ?? 0,
      textEnabled: json['textEnabled'] as bool? ?? false,
      textKind: json['textKind'] as String? ?? '数字飘字',
      textStyle: json['textStyle'] as String? ?? '阿拉伯数字 (1, 2, 3)',
      textMode: json['textMode'] as String? ?? '默认模式 (+1)',
      textTemplate: json['textTemplate'] as String? ?? r'${number}',
      textContent: json['textContent'] as String? ?? '',
      textTags: json['textTags'] != null ? List<String>.from(json['textTags'] as List) : const [],
      textTagPlayMode: json['textTagPlayMode'] as String? ?? '按顺序显示',
      textColor: json['textColor'] as String? ?? '#B45309',
      textDuration: json['textDuration'] as int? ?? 1000,
      textEasing: json['textEasing'] as String? ?? '弹跳',
      textOpacity: json['textOpacity'] as int? ?? 100,
      textFontFamily: json['textFontFamily'] as String? ?? '系统默认',
      textWeight: json['textWeight'] as String? ?? '加粗',
      textOutlineWidth: json['textOutlineWidth'] as int? ?? 0,
      textShadow: json['textShadow'] as String? ?? '柔和',
      comboEnabled: json['comboEnabled'] as bool? ?? false,
      comboWindowMs: json['comboWindowMs'] as int? ?? 900,
      textOffsetX: json['textOffsetX'] as int? ?? 0,
      textOffsetY: json['textOffsetY'] as int? ?? -28,
      fontSize: json['fontSize'] as int? ?? 24,
      textGradient: json['textGradient'] as bool? ?? false,
      textGradientStart: json['textGradientStart'] as String? ?? '#FBBF24',
      textGradientEnd: json['textGradientEnd'] as String? ?? '#EC4899',
      textDelay: json['textDelay'] as int? ?? 0,
      particle: json['particle'] as bool? ?? false,
      particleCount: json['particleCount'] as int? ?? 22,
      particleSpread: json['particleSpread'] as int? ?? 62,
      particleStyle: json['particleStyle'] as String? ?? '点状粒子',
      particleDirection: json['particleDirection'] as String? ?? '四周扩散',
      particleColorMode: json['particleColorMode'] as String? ?? '跟随主题',
      particleDuration: json['particleDuration'] as int? ?? 780,
      particleSize: json['particleSize'] as int? ?? 14,
      particleOpacity: json['particleOpacity'] as int? ?? 88,
      particlePalette: json['particlePalette'] != null
          ? List<String>.from(json['particlePalette'] as List)
          : const ['#FBBF24', '#F59E0B', '#FDE68A', '#FCD34D', '#FEF3C7'],
      particleGravity: json['particleGravity'] as int? ?? 0,
      particleWind: json['particleWind'] as int? ?? 0,
      particleBounce: json['particleBounce'] as int? ?? 0,
      particleTrail: json['particleTrail'] as bool? ?? false,
      particleDelay: json['particleDelay'] as int? ?? 0,
      particleMotionMode: json['particleMotionMode'] as String? ?? 'burst',
      orbitalCount: json['orbitalCount'] as int? ?? 6,
      orbitalRadius: json['orbitalRadius'] as int? ?? 32,
      orbitalSpeed: json['orbitalSpeed'] as int? ?? 3,
      ripple: json['ripple'] as bool? ?? false,
      rippleSize: json['rippleSize'] as int? ?? 72,
      rippleDuration: json['rippleDuration'] as int? ?? 860,
      rippleStyle: json['rippleStyle'] as String? ?? '单环',
      rippleEasing: json['rippleEasing'] as String? ?? '缓出',
      rippleLineWidth: json['rippleLineWidth'] as int? ?? 2,
      rippleOpacity: json['rippleOpacity'] as int? ?? 72,
      rippleColor: json['rippleColor'] as String? ?? '#F59E0B',
      rippleDelay: json['rippleDelay'] as int? ?? 0,
      sound: json['sound'] as bool? ?? false,
      soundFile: json['soundFile'] as String? ?? 'woodfish-soft.wav',
      volume: json['volume'] as int? ?? 72,
      playbackRate: json['playbackRate'] as int? ?? 100,
      soundDelay: json['soundDelay'] as int? ?? 0,
      soundFadeOut: json['soundFadeOut'] as int? ?? 80,
      soundTriggerMode: json['soundTriggerMode'] as String? ?? '每次触发',
      soundBlendMode: json['soundBlendMode'] as String? ?? '保持原音量',
      animationEnabled: json['animationEnabled'] as bool? ?? false,
      animationStyle: json['animationStyle'] as String? ?? '聚焦脉冲',
      animationDuration: json['animationDuration'] as int? ?? 720,
      animationEasing: json['animationEasing'] as String? ?? '缓出',
      animationScale: json['animationScale'] as int? ?? 100,
      animationOpacity: json['animationOpacity'] as int? ?? 100,
      animationOffsetX: json['animationOffsetX'] as int? ?? 0,
      animationOffsetY: json['animationOffsetY'] as int? ?? -10,
      animationColor: json['animationColor'] as String? ?? '#F59E0B',
      animationGlow: json['animationGlow'] as bool? ?? false,
      animationDelay: json['animationDelay'] as int? ?? 0,
      imageEnabled: json['imageEnabled'] as bool? ?? false,
      imageDataUrl: json['imageDataUrl'] as String? ?? '',
      imageDuration: json['imageDuration'] as int? ?? 780,
      imageSize: json['imageSize'] as int? ?? 56,
      imageOpacity: json['imageOpacity'] as int? ?? 100,
      imageOffsetX: json['imageOffsetX'] as int? ?? 0,
      imageOffsetY: json['imageOffsetY'] as int? ?? -18,
      imageDelay: json['imageDelay'] as int? ?? 0,
      shake: json['shake'] as int? ?? 0,
      cursorOverride: json['cursorOverride'] as String? ?? '跟随当前状态',
      cursorSize: json['cursorSize'] as int? ?? 48,
      cursorTrailEnabled: json['cursorTrailEnabled'] as bool? ?? false,
      cursorTrailCount: json['cursorTrailCount'] as int? ?? 5,
      cursorTrailOpacity: json['cursorTrailOpacity'] as int? ?? 50,
      cursorGlowColor: json['cursorGlowColor'] as String? ?? '',
    );
  }

  @override
  String toString() => 'ActionConfig(${toJson()})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionConfig &&
          triggerTiming == other.triggerTiming &&
          triggerZone == other.triggerZone &&
          holdMs == other.holdMs &&
          textEnabled == other.textEnabled &&
          textKind == other.textKind &&
          textStyle == other.textStyle &&
          textMode == other.textMode &&
          textTemplate == other.textTemplate &&
          textContent == other.textContent &&
          _listEquals(textTags, other.textTags) &&
          textTagPlayMode == other.textTagPlayMode &&
          textColor == other.textColor &&
          textDuration == other.textDuration &&
          textEasing == other.textEasing &&
          textOpacity == other.textOpacity &&
          textFontFamily == other.textFontFamily &&
          textWeight == other.textWeight &&
          textOutlineWidth == other.textOutlineWidth &&
          textShadow == other.textShadow &&
          comboEnabled == other.comboEnabled &&
          comboWindowMs == other.comboWindowMs &&
          textOffsetX == other.textOffsetX &&
          textOffsetY == other.textOffsetY &&
          fontSize == other.fontSize &&
          textGradient == other.textGradient &&
          textGradientStart == other.textGradientStart &&
          textGradientEnd == other.textGradientEnd &&
          textDelay == other.textDelay &&
          particle == other.particle &&
          particleCount == other.particleCount &&
          particleSpread == other.particleSpread &&
          particleStyle == other.particleStyle &&
          particleDirection == other.particleDirection &&
          particleColorMode == other.particleColorMode &&
          particleDuration == other.particleDuration &&
          particleSize == other.particleSize &&
          particleOpacity == other.particleOpacity &&
          _listEquals(particlePalette, other.particlePalette) &&
          particleGravity == other.particleGravity &&
          particleWind == other.particleWind &&
          particleBounce == other.particleBounce &&
          particleTrail == other.particleTrail &&
          particleDelay == other.particleDelay &&
          particleMotionMode == other.particleMotionMode &&
          orbitalCount == other.orbitalCount &&
          orbitalRadius == other.orbitalRadius &&
          orbitalSpeed == other.orbitalSpeed &&
          ripple == other.ripple &&
          rippleSize == other.rippleSize &&
          rippleDuration == other.rippleDuration &&
          rippleStyle == other.rippleStyle &&
          rippleEasing == other.rippleEasing &&
          rippleLineWidth == other.rippleLineWidth &&
          rippleOpacity == other.rippleOpacity &&
          rippleColor == other.rippleColor &&
          rippleDelay == other.rippleDelay &&
          sound == other.sound &&
          soundFile == other.soundFile &&
          volume == other.volume &&
          playbackRate == other.playbackRate &&
          soundDelay == other.soundDelay &&
          soundFadeOut == other.soundFadeOut &&
          soundTriggerMode == other.soundTriggerMode &&
          soundBlendMode == other.soundBlendMode &&
          animationEnabled == other.animationEnabled &&
          animationStyle == other.animationStyle &&
          animationDuration == other.animationDuration &&
          animationEasing == other.animationEasing &&
          animationScale == other.animationScale &&
          animationOpacity == other.animationOpacity &&
          animationOffsetX == other.animationOffsetX &&
          animationOffsetY == other.animationOffsetY &&
          animationColor == other.animationColor &&
          animationGlow == other.animationGlow &&
          animationDelay == other.animationDelay &&
          imageEnabled == other.imageEnabled &&
          imageDataUrl == other.imageDataUrl &&
          imageDuration == other.imageDuration &&
          imageSize == other.imageSize &&
          imageOpacity == other.imageOpacity &&
          imageOffsetX == other.imageOffsetX &&
          imageOffsetY == other.imageOffsetY &&
          imageDelay == other.imageDelay &&
          shake == other.shake &&
          cursorOverride == other.cursorOverride &&
          cursorSize == other.cursorSize &&
          cursorTrailEnabled == other.cursorTrailEnabled &&
          cursorTrailCount == other.cursorTrailCount &&
          cursorTrailOpacity == other.cursorTrailOpacity &&
          cursorGlowColor == other.cursorGlowColor;

  @override
  int get hashCode => Object.hashAll([
    triggerTiming, triggerZone, holdMs,
    textEnabled, textKind, textStyle, textMode, textTemplate, textContent,
    Object.hashAll(textTags),
    textTagPlayMode, textColor, textDuration, textEasing, textOpacity,
    textFontFamily, textWeight, textOutlineWidth, textShadow,
    comboEnabled, comboWindowMs, textOffsetX, textOffsetY, fontSize,
    textGradient, textGradientStart, textGradientEnd, textDelay,
    particle, particleCount, particleSpread, particleStyle, particleDirection,
    particleColorMode, particleDuration, particleSize, particleOpacity,
    Object.hashAll(particlePalette),
    particleGravity, particleWind, particleBounce, particleTrail, particleDelay,
    particleMotionMode, orbitalCount, orbitalRadius, orbitalSpeed,
    ripple, rippleSize, rippleDuration, rippleStyle, rippleEasing,
    rippleLineWidth, rippleOpacity, rippleColor, rippleDelay,
    sound, soundFile, volume, playbackRate, soundDelay, soundFadeOut,
    soundTriggerMode, soundBlendMode,
    animationEnabled, animationStyle, animationDuration, animationEasing,
    animationScale, animationOpacity, animationOffsetX, animationOffsetY,
    animationColor, animationGlow, animationDelay,
    imageEnabled, imageDataUrl, imageDuration, imageSize, imageOpacity,
    imageOffsetX, imageOffsetY, imageDelay,
    shake, cursorOverride, cursorSize, cursorTrailEnabled, cursorTrailCount,
    cursorTrailOpacity, cursorGlowColor,
  ]);

  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null) return false;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
