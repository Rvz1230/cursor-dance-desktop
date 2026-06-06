import 'action_config.dart';

// ═══════════════════════════════════════════════════════════════
// Option Lists
// ═══════════════════════════════════════════════════════════════

const kTriggerOptions = {
  'leftClick': {
    'timing': ['按下时', '抬起时'],
    'zones': ['当前页面可点击区域', '仅按钮和链接', '全部可交互元素'],
  },
  'rightClick': {
    'timing': ['按下时', '菜单弹出前'],
    'zones': ['右键菜单前', '可交互元素', '空白区域'],
  },
  'doubleClick': {
    'timing': ['第二次按下时', '第二次抬起后'],
    'zones': ['双击命中区域', '主操作按钮', '内容卡片'],
  },
  'longPress': {
    'timing': ['按住达到阈值', '松开后触发'],
    'zones': ['按住后释放', '长按可交互元素', '全局长按区'],
  },
  'wheel': {
    'timing': ['滚动开始时', '连续滚动中'],
    'zones': ['向上 / 向下滚轮', '仅向上滚动', '仅向下滚动'],
  },
  'hover': {
    'timing': ['进入时', '停留后'],
    'zones': ['进入可交互元素', '仅按钮和链接', '全页面 hover'],
  },
};

const kSoundFileOptions = [
  'woodfish-soft.wav',
  'woodfish-deep.wav',
  'tick-light.wav',
  'chime-bright.wav',
  'pop-soft.wav',
  'swipe-whoosh.wav',
];

const kCursorOverrideOptions = [
  '跟随当前状态',
  '木鱼（继承默认）',
  '木鱼（增强态）',
  '木鱼（按压态）',
  '切换到 pointer',
];

const kTextKindOptions = ['数字飘字', '文本飘字'];
const kNumberStyleOptions = [
  '阿拉伯数字 (1, 2, 3)',
  '中文数字 (一, 二, 三)',
  '英文单词 (one, two, three)',
];
const kTextModeOptions = ['默认模式 (+1)', '模板模式'];
const kTextTagPlayOptions = ['按顺序显示', '随机显示'];
const kTextEasingOptions = ['线性', '缓入', '缓出', '缓入缓出', '弹跳', '弹性'];
const kTextWeightOptions = ['常规', '中等', '加粗'];
const kTextShadowOptions = ['无', '柔和', '清晰'];
const kTextFontPresets = [
  '系统默认',
  '苹方 / 微软雅黑',
  '宋体',
  '黑体',
  '楷体',
  '等宽字体',
  '自定义',
];

const kParticleStyleOptions = [
  '点状粒子',
  '碎屑粒子',
  '火花',
  '星光',
  '钻石',
  '心形',
  '方块',
  '三角',
];
const kParticleDirectionOptions = ['四周扩散', '旋转扫射', '向上喷发', '随机散射'];
const kParticleColorModeOptions = ['跟随主题', '跟随飘字色', '随机轻变化'];
const kParticleMotionModeOptions = [
  {'value': 'burst', 'label': '喷射扩散'},
  {'value': 'orbital', 'label': '轨道呼吸'},
];

const kRippleStyleOptions = [
  '单环',
  '双环',
  '柔和面波',
  '脉冲波纹',
  '回声环',
  '能量脉冲',
];
const kRippleEasingOptions = ['线性', '缓出', '缓入缓出', '弹性'];

const kAudioTriggerOptions = ['每次触发', '连击叠加', '节流播放'];
const kAudioBlendOptions = ['保持原音量', '压低页面音频', '仅插件音效'];

const kCursorSizeOptions = ['32 × 32', '40 × 40', '48 × 48', '56 × 56', '64 × 64'];
const kCursorHotspotOptions = ['0, 0', '8, 8', '12, 12', '16, 16', '16, 32', '24, 24'];

const kAnimationStyleOptions = [
  '聚焦脉冲',
  '斜切闪片',
  '弹跳徽记',
  '漩涡旋转',
  '星光闪耀',
  '轨道环绕',
  '螺旋上升',
];
const kAnimationEasingOptions = ['线性', '缓出', '缓入缓出', '弹性'];

const kParticlePhysicsPresetOptions = [
  '无',
  '重力飘落',
  '风场漂移',
  '弹跳迸发',
  '旋转扩散',
];

const kParticlePhysicsPresetValues = {
  '无': {'particleGravity': 0, 'particleWind': 0, 'particleBounce': 0, 'particleTrail': false},
  '重力飘落': {
    'particleGravity': 24,
    'particleWind': 4,
    'particleBounce': 6,
    'particleTrail': false,
  },
  '风场漂移': {
    'particleGravity': 6,
    'particleWind': 22,
    'particleBounce': 0,
    'particleTrail': false,
  },
  '弹跳迸发': {
    'particleGravity': 14,
    'particleWind': 0,
    'particleBounce': 36,
    'particleTrail': true,
  },
  '旋转扩散': {
    'particleGravity': -8,
    'particleWind': 8,
    'particleBounce': 0,
    'particleTrail': true,
  },
};

const kParticlePalettePresets = {
  '暖金': ['#FBBF24', '#F59E0B', '#FDE68A', '#FCD34D', '#FEF3C7'],
  '青绿': ['#14B8A6', '#0F766E', '#5EEAD4', '#99F6E4', '#CCFBF1'],
  '紫韵': ['#A78BFA', '#7C3AED', '#C4B5FD', '#DDD6FE', '#EDE9FE'],
  '水墨': ['#334155', '#475569', '#64748B', '#94A3B8', '#CBD5E1'],
  '糖果': ['#F43F5E', '#FB923C', '#FACC15', '#34D399', '#60A5FA', '#C084FC'],
  '樱花': ['#FDA4AF', '#F9A8D4', '#FBCFE8', '#FCE7F3', '#FDF2F8'],
  '霓虹': ['#06B6D4', '#22D3EE', '#818CF8', '#A78BFA', '#38BDF8'],
  '日落': ['#F97316', '#FB923C', '#FBBF24', '#F59E0B', '#FCD34D'],
  '森林': ['#14532D', '#166534', '#22C55E', '#86EFAC', '#DCFCE7'],
  '海洋': ['#1E3A5F', '#1E40AF', '#3B82F6', '#93C5FD', '#DBEAFE'],
  '暮光': ['#4C1D95', '#7C3AED', '#C084FC', '#F59E0B', '#FDE68A'],
};

// ═══════════════════════════════════════════════════════════════
// Per-Action Presets
// ═══════════════════════════════════════════════════════════════

ActionConfig _leftClickPreset() => ActionConfig(
      textKind: '数字飘字',
      textEnabled: true,
      textContent: '+1',
      textTags: ['功德 +1', '继续点击', '已触发'],
      textColor: '#B45309',
      textDuration: 1000,
      textEasing: '弹跳',
      textWeight: '加粗',
      textShadow: '柔和',
      comboEnabled: true,
      textOffsetY: -28,
      particle: true,
      particleCount: 22,
      particleSpread: 62,
      particleStyle: '火花',
      particleDirection: '四周扩散',
      particleDuration: 780,
      particleSize: 14,
      particleOpacity: 88,
      particleGravity: 8,
      particleBounce: 14,
      ripple: true,
      rippleSize: 72,
      rippleDuration: 860,
      rippleStyle: '回声环',
      rippleEasing: '缓出',
      rippleOpacity: 72,
      sound: true,
      fontSize: 24,
      volume: 72,
      soundFadeOut: 80,
      soundTriggerMode: '每次触发',
      shake: 48,
      cursorOverride: '木鱼（继承默认）',
      cursorSize: 48,
      cursorTrailEnabled: true,
      cursorTrailCount: 4,
      cursorTrailOpacity: 36,
      cursorGlowColor: '#F59E0B',
      imageEnabled: false,
      triggerTiming: '抬起时',
      triggerZone: '当前页面可点击区域',
      holdMs: 0,
      soundFile: 'woodfish-soft.wav',
    );

ActionConfig _rightClickPreset() => ActionConfig(
      textKind: '文本飘字',
      textEnabled: false,
      textContent: 'menu',
      textTags: ['展开菜单', '右键操作', '更多选项'],
      textColor: '#475569',
      textDuration: 820,
      textEasing: '缓出',
      textWeight: '中等',
      textShadow: '无',
      textOffsetY: -18,
      particle: true,
      particleCount: 14,
      particleSpread: 40,
      particleDirection: '四周扩散',
      particleDuration: 560,
      particleSize: 10,
      particleOpacity: 72,
      ripple: true,
      rippleSize: 50,
      rippleDuration: 560,
      rippleStyle: '双环',
      rippleEasing: '缓出',
      rippleOpacity: 62,
      sound: false,
      fontSize: 18,
      volume: 60,
      soundFadeOut: 40,
      soundTriggerMode: '节流播放',
      shake: 22,
      cursorOverride: '跟随当前状态',
      cursorSize: 44,
      imageEnabled: false,
      triggerTiming: '菜单弹出前',
      triggerZone: '右键菜单前',
      holdMs: 0,
      soundFile: 'tick-light.wav',
    );

ActionConfig _doubleClickPreset() => ActionConfig(
      textKind: '数字飘字',
      textStyle: '英文单词 (one, two, three)',
      textMode: '模板模式',
      textTemplate: 'combo \${number}',
      textEnabled: true,
      textContent: 'combo',
      textTags: ['双击完成', '连击命中', 'combo'],
      textTagPlayMode: '随机显示',
      textColor: '#0F766E',
      textDuration: 1100,
      textEasing: '弹性',
      textWeight: '加粗',
      textOutlineWidth: 1,
      textShadow: '柔和',
      comboEnabled: true,
      textOffsetY: -30,
      particle: true,
      particleCount: 26,
      particleSpread: 74,
      particleStyle: '火花',
      particleDirection: '四周扩散',
      particleColorMode: '随机轻变化',
      particlePalette: ['#14B8A6', '#0F766E', '#5EEAD4', '#99F6E4', '#CCFBF1'],
      particleDuration: 980,
      particleSize: 16,
      particleOpacity: 96,
      ripple: true,
      rippleSize: 84,
      rippleDuration: 940,
      rippleStyle: '双环',
      rippleEasing: '弹性',
      rippleLineWidth: 3,
      rippleOpacity: 84,
      rippleColor: '#14B8A6',
      sound: true,
      fontSize: 24,
      volume: 80,
      playbackRate: 104,
      soundFadeOut: 90,
      soundTriggerMode: '连击叠加',
      soundBlendMode: '压低页面音频',
      shake: 52,
      cursorOverride: '木鱼（增强态）',
      cursorSize: 52,
      cursorTrailEnabled: true,
      cursorTrailCount: 5,
      cursorTrailOpacity: 42,
      cursorGlowColor: '#14B8A6',
      imageEnabled: false,
      triggerTiming: '第二次抬起后',
      triggerZone: '双击命中区域',
      holdMs: 320,
      soundFile: 'woodfish-deep.wav',
    );

ActionConfig _longPressPreset() => ActionConfig(
      textKind: '文本飘字',
      textStyle: '中文数字 (一, 二, 三)',
      textEnabled: false,
      textContent: '蓄',
      textTags: ['按住中', '蓄力完成', '松开触发'],
      textColor: '#7C3AED',
      textDuration: 900,
      textEasing: '缓入缓出',
      textOpacity: 94,
      textWeight: '中等',
      textShadow: '柔和',
      textOffsetY: -22,
      particle: true,
      particleCount: 16,
      particleSpread: 48,
      particleStyle: '碎屑粒子',
      particleDirection: '向上喷发',
      particlePalette: ['#A78BFA', '#7C3AED', '#C4B5FD', '#DDD6FE', '#EDE9FE'],
      particleDuration: 740,
      particleSize: 12,
      particleOpacity: 78,
      ripple: true,
      rippleSize: 62,
      rippleDuration: 780,
      rippleStyle: '柔和面波',
      rippleEasing: '缓入缓出',
      rippleOpacity: 56,
      rippleColor: '#A78BFA',
      sound: true,
      fontSize: 20,
      volume: 72,
      playbackRate: 92,
      soundDelay: 60,
      soundFadeOut: 120,
      soundTriggerMode: '每次触发',
      soundBlendMode: '压低页面音频',
      shake: 58,
      cursorOverride: '木鱼（按压态）',
      cursorSize: 50,
      imageEnabled: false,
      triggerTiming: '松开后触发',
      triggerZone: '按住后释放',
      holdMs: 560,
      soundFile: 'woodfish-deep.wav',
    );

ActionConfig _wheelPreset() => ActionConfig(
      textKind: '文本飘字',
      textEnabled: false,
      textContent: 'roll',
      textTags: ['向上滚动', '向下滚动', '继续滚动'],
      textTagPlayMode: '随机显示',
      textColor: '#0284C7',
      textDuration: 700,
      textEasing: '线性',
      textOpacity: 90,
      textWeight: '常规',
      textShadow: '无',
      textOffsetY: -14,
      particle: true,
      particleCount: 10,
      particleSpread: 36,
      particleDirection: '四周扩散',
      particleColorMode: '跟随飘字色',
      particleDuration: 460,
      particleSize: 10,
      particleOpacity: 72,
      ripple: true,
      rippleSize: 38,
      rippleDuration: 500,
      rippleStyle: '单环',
      rippleEasing: '线性',
      rippleLineWidth: 1,
      rippleOpacity: 46,
      rippleColor: '#0284C7',
      sound: false,
      fontSize: 16,
      volume: 40,
      playbackRate: 110,
      soundFadeOut: 30,
      soundTriggerMode: '节流播放',
      shake: 16,
      cursorOverride: '跟随当前状态',
      cursorSize: 44,
      imageEnabled: false,
      triggerTiming: '连续滚动中',
      triggerZone: '向上 / 向下滚轮',
      holdMs: 180,
      soundFile: 'tick-light.wav',
    );

ActionConfig _hoverPreset() => ActionConfig(
      textKind: '文本飘字',
      textEnabled: false,
      textContent: 'hover',
      textTags: ['已聚焦', '经过目标', '可点击'],
      textTagPlayMode: '随机显示',
      textColor: '#475569',
      textDuration: 680,
      textEasing: '缓入缓出',
      textOpacity: 88,
      textWeight: '常规',
      textShadow: '无',
      textOffsetY: -12,
      particle: false,
      particleCount: 8,
      particleSpread: 24,
      particleDirection: '向上喷发',
      particleDuration: 420,
      particleSize: 8,
      particleOpacity: 60,
      ripple: true,
      rippleSize: 34,
      rippleDuration: 440,
      rippleStyle: '柔和面波',
      rippleEasing: '缓入缓出',
      rippleLineWidth: 1,
      rippleOpacity: 32,
      rippleColor: '#94A3B8',
      sound: false,
      fontSize: 16,
      volume: 0,
      soundFadeOut: 0,
      soundTriggerMode: '节流播放',
      shake: 0,
      cursorOverride: '切换到 pointer',
      cursorSize: 44,
      imageEnabled: false,
      triggerTiming: '停留后',
      triggerZone: '进入可交互元素',
      holdMs: 220,
      soundFile: 'tick-light.wav',
    );

// ═══════════════════════════════════════════════════════════════
// Theme Action Overrides
// ═══════════════════════════════════════════════════════════════

typedef ActionConfigUpdater = ActionConfig Function(ActionConfig);

const kActionIds = [
  'leftClick',
  'rightClick',
  'doubleClick',
  'longPress',
  'wheel',
  'hover',
];

const kActionLabels = {
  'leftClick': '左键单击',
  'rightClick': '右键单击',
  'doubleClick': '双击',
  'longPress': '长按',
  'wheel': '滚轮',
  'hover': '悬停',
};

const kActionHints = {
  'leftClick': '最常用的触发入口',
  'rightClick': '适合菜单或次要动作',
  'doubleClick': '更强的强调反馈',
  'longPress': '按住蓄力后触发',
  'wheel': '轻反馈和页面尾迹',
  'hover': '切状态或轻提示',
};

ActionConfig presetForAction(String actionId) {
  switch (actionId) {
    case 'leftClick':
      return _leftClickPreset();
    case 'rightClick':
      return _rightClickPreset();
    case 'doubleClick':
      return _doubleClickPreset();
    case 'longPress':
      return _longPressPreset();
    case 'wheel':
      return _wheelPreset();
    case 'hover':
      return _hoverPreset();
    default:
      return ActionConfig();
  }
}

// ═══════════════════════════════════════════════════════════════
// Theme-level action overrides
// ═══════════════════════════════════════════════════════════════

ActionConfig _applyThemeOverrides(ActionConfig base, String themeId, String actionId) {
  // We store overrides as copyWith calls per theme+action.
  // Only the known 4 built-in themes have overrides.
  switch (themeId) {
    case 'mono-geo':
      return _applyMonoGeoOverride(base, actionId);
    case 'drift':
      return _applyDriftOverride(base, actionId);
    case 'molten':
      return _applyMoltenOverride(base, actionId);
    case 'sunset':
      return _applySunsetOverride(base, actionId);
    default:
      return base;
  }
}

ActionConfig _applyMonoGeoOverride(ActionConfig base, String actionId) {
  switch (actionId) {
    case 'leftClick':
      return base.copyWith(
        textKind: '数字飘字',
        textEnabled: true,
        textContent: '+1',
        textTags: ['+1', '+2', '+3'],
        textColor: '#1E293B',
        fontSize: 20,
        textWeight: '中等',
        textEasing: '线性',
        textShadow: '无',
        textFontFamily: '等宽字体',
        comboEnabled: true,
        particle: true,
        particleStyle: '方块',
        particleCount: 18,
        particleSpread: 56,
        particlePalette: ['#1E293B', '#334155', '#475569', '#64748B', '#94A3B8'],
        particleSize: 12,
        particleOpacity: 82,
        particleColorMode: '随机轻变化',
        particleGravity: 4,
        particleBounce: 8,
        ripple: true,
        rippleStyle: '单环',
        rippleSize: 48,
        rippleColor: '#334155',
        rippleOpacity: 42,
        rippleDuration: 540,
        sound: false,
        shake: 14,
        cursorOverride: '跟随当前状态',
      );
    case 'doubleClick':
      return base.copyWith(
        textKind: '数字飘字',
        textColor: '#1E293B',
        fontSize: 22,
        textWeight: '加粗',
        textEasing: '线性',
        textShadow: '无',
        textFontFamily: '等宽字体',
        particle: true,
        particleStyle: '方块',
        particleCount: 26,
        particleSpread: 66,
        particlePalette: ['#1E293B', '#334155', '#475569', '#64748B'],
        particleSize: 14,
        particleOpacity: 86,
        particleBounce: 12,
        ripple: true,
        rippleStyle: '双环',
        rippleSize: 56,
        rippleColor: '#334155',
        rippleOpacity: 50,
        rippleDuration: 600,
        sound: false,
        shake: 22,
      );
    case 'wheel':
      return base.copyWith(
        particle: true,
        particleStyle: '方块',
        particlePalette: ['#475569', '#64748B', '#94A3B8'],
        particleCount: 8,
        ripple: true,
        rippleColor: '#475569',
        rippleStyle: '单环',
        textColor: '#475569',
        sound: false,
      );
    case 'hover':
      return base.copyWith(
        ripple: true,
        rippleStyle: '单环',
        rippleColor: '#94A3B8',
        rippleOpacity: 24,
        textEnabled: true,
        textKind: '文本飘字',
        textTags: ['□', '■', '▣'],
        textTagPlayMode: '随机显示',
        textColor: '#475569',
        textFontFamily: '等宽字体',
        fontSize: 14,
        sound: false,
      );
    case 'rightClick':
      return base.copyWith(
        particle: true,
        particleStyle: '方块',
        particlePalette: ['#334155', '#475569', '#64748B'],
        particleCount: 12,
        ripple: true,
        rippleColor: '#475569',
        rippleStyle: '单环',
        textColor: '#475569',
        sound: false,
      );
    case 'longPress':
      return base.copyWith(
        particle: true,
        particleStyle: '方块',
        particlePalette: ['#1E293B', '#334155', '#475569'],
        particleCount: 16,
        particleBounce: 14,
        ripple: true,
        rippleColor: '#334155',
        rippleStyle: '双环',
        textColor: '#1E293B',
        sound: false,
        textFontFamily: '等宽字体',
      );
    default:
      return base;
  }
}

ActionConfig _applyDriftOverride(ActionConfig base, String actionId) {
  switch (actionId) {
    case 'leftClick':
      return base.copyWith(
        particle: true,
        particleStyle: '点状粒子',
        particleMotionMode: 'orbital',
        orbitalCount: 8,
        orbitalRadius: 28,
        orbitalSpeed: 2,
        particlePalette: ['#0D9488', '#14B8A6', '#5EEAD4', '#99F6E4'],
        particleSize: 10,
        particleOpacity: 80,
        particleColorMode: '随机轻变化',
        ripple: true,
        rippleStyle: '柔和面波',
        rippleColor: '#14B8A6',
        rippleSize: 44,
        rippleOpacity: 28,
        textEnabled: false,
        sound: false,
        shake: 0,
        cursorGlowColor: '#14B8A6',
        cursorTrailEnabled: true,
        cursorTrailCount: 3,
        cursorTrailOpacity: 28,
      );
    case 'doubleClick':
      return base.copyWith(
        particle: true,
        particleStyle: '点状粒子',
        particleMotionMode: 'orbital',
        orbitalCount: 12,
        orbitalRadius: 34,
        orbitalSpeed: 3,
        particlePalette: ['#0D9488', '#14B8A6', '#5EEAD4'],
        particleSize: 12,
        particleOpacity: 86,
        ripple: true,
        rippleStyle: '双环',
        rippleColor: '#14B8A6',
        rippleSize: 52,
        rippleOpacity: 36,
        textEnabled: false,
        sound: false,
        cursorGlowColor: '#14B8A6',
      );
    case 'wheel':
      return base.copyWith(
        particle: true,
        particleStyle: '点状粒子',
        particleCount: 6,
        particlePalette: ['#5EEAD4', '#99F6E4'],
        ripple: true,
        rippleColor: '#14B8A6',
        rippleStyle: '单环',
        textEnabled: false,
        sound: false,
      );
    case 'hover':
      return base.copyWith(
        ripple: true,
        rippleStyle: '柔和面波',
        rippleColor: '#5EEAD4',
        rippleOpacity: 20,
        cursorGlowColor: '#5EEAD4',
        textEnabled: false,
        sound: false,
      );
    case 'rightClick':
      return base.copyWith(
        particle: true,
        particleStyle: '点状粒子',
        particleCount: 8,
        particlePalette: ['#14B8A6', '#5EEAD4'],
        ripple: true,
        rippleColor: '#14B8A6',
        rippleStyle: '双环',
        textEnabled: false,
        sound: false,
      );
    case 'longPress':
      return base.copyWith(
        particle: true,
        particleStyle: '点状粒子',
        particleMotionMode: 'orbital',
        orbitalCount: 10,
        orbitalRadius: 30,
        orbitalSpeed: 1,
        particlePalette: ['#0D9488', '#14B8A6', '#5EEAD4'],
        particleSize: 10,
        ripple: true,
        rippleStyle: '柔和面波',
        rippleColor: '#14B8A6',
        textEnabled: false,
        sound: false,
      );
    default:
      return base;
  }
}

ActionConfig _applyMoltenOverride(ActionConfig base, String actionId) {
  switch (actionId) {
    case 'leftClick':
      return base.copyWith(
        particle: true,
        particleStyle: '火花',
        particleDirection: '向上喷发',
        particleCount: 28,
        particleSpread: 60,
        particlePalette: ['#F97316', '#FB923C', '#FBBF24', '#FEF08A', '#FDE68A'],
        particleSize: 14,
        particleOpacity: 90,
        particleColorMode: '随机轻变化',
        particleGravity: 12,
        particleBounce: 6,
        ripple: true,
        rippleStyle: '能量脉冲',
        rippleColor: '#F97316',
        rippleSize: 60,
        rippleOpacity: 60,
        textEnabled: true,
        textKind: '数字飘字',
        textContent: '+1',
        textColor: '#EA580C',
        fontSize: 22,
        textWeight: '加粗',
        textShadow: '清晰',
        textEasing: '弹性',
        textGradient: true,
        textGradientStart: '#F97316',
        textGradientEnd: '#FBBF24',
        sound: true,
        volume: 56,
        shake: 32,
        cursorGlowColor: '#F97316',
        cursorTrailEnabled: true,
        cursorTrailCount: 4,
        cursorTrailOpacity: 40,
      );
    case 'doubleClick':
      return base.copyWith(
        particle: true,
        particleStyle: '火花',
        particleDirection: '向上喷发',
        particleCount: 36,
        particleSpread: 72,
        particlePalette: ['#F97316', '#FB923C', '#FBBF24', '#FEF08A'],
        particleSize: 16,
        particleOpacity: 94,
        particleGravity: 16,
        particleBounce: 10,
        ripple: true,
        rippleStyle: '回声环',
        rippleColor: '#FB923C',
        rippleSize: 72,
        rippleOpacity: 68,
        textGradient: true,
        textGradientStart: '#F97316',
        textGradientEnd: '#FBBF24',
        fontSize: 24,
        animationEnabled: true,
        animationStyle: '星光闪耀',
        animationColor: '#F97316',
        animationDuration: 640,
        animationGlow: true,
        sound: true,
        volume: 64,
        shake: 42,
      );
    case 'wheel':
      return base.copyWith(
        particle: true,
        particleStyle: '火花',
        particleCount: 8,
        particlePalette: ['#FB923C', '#FBBF24'],
        particleGravity: 8,
        ripple: true,
        rippleColor: '#F97316',
        rippleStyle: '单环',
        textEnabled: false,
        sound: false,
      );
    case 'hover':
      return base.copyWith(
        ripple: true,
        rippleStyle: '柔和面波',
        rippleColor: '#FBBF24',
        rippleOpacity: 24,
        cursorGlowColor: '#FBBF24',
        textEnabled: true,
        textKind: '文本飘字',
        textTags: ['✦', '·', '●'],
        textTagPlayMode: '随机显示',
        textColor: '#F97316',
        fontSize: 14,
        sound: false,
      );
    case 'rightClick':
      return base.copyWith(
        particle: true,
        particleStyle: '火花',
        particleCount: 14,
        particleGravity: 10,
        particlePalette: ['#F97316', '#FB923C', '#FBBF24'],
        ripple: true,
        rippleColor: '#F97316',
        rippleStyle: '双环',
        textColor: '#EA580C',
        sound: false,
      );
    case 'longPress':
      return base.copyWith(
        particle: true,
        particleStyle: '火花',
        particleCount: 20,
        particleGravity: 18,
        particleBounce: 8,
        particlePalette: ['#F97316', '#FB923C', '#FBBF24'],
        ripple: true,
        rippleStyle: '能量脉冲',
        rippleColor: '#FB923C',
        textColor: '#EA580C',
        animationEnabled: true,
        animationStyle: '聚焦脉冲',
        animationColor: '#F97316',
        animationDuration: 520,
        sound: true,
        volume: 48,
      );
    default:
      return base;
  }
}

ActionConfig _applySunsetOverride(ActionConfig base, String actionId) {
  switch (actionId) {
    case 'leftClick':
      return base.copyWith(
        particle: true,
        particleStyle: '钻石',
        particleCount: 20,
        particleSpread: 64,
        particlePalette: ['#F43F5E', '#FB7185', '#FDA4AF', '#FBCFE8', '#FFF1F2'],
        particleSize: 12,
        particleOpacity: 82,
        particleColorMode: '随机轻变化',
        particleGravity: 4,
        particleWind: 2,
        particleBounce: 8,
        ripple: true,
        rippleStyle: '回声环',
        rippleColor: '#FB7185',
        rippleSize: 52,
        rippleOpacity: 44,
        textEnabled: true,
        textKind: '数字飘字',
        textContent: '+1',
        textColor: '#BE185D',
        fontSize: 20,
        textWeight: '加粗',
        textEasing: '弹跳',
        textShadow: '柔和',
        textGradient: true,
        textGradientStart: '#F43F5E',
        textGradientEnd: '#FB923C',
        sound: false,
        shake: 0,
        cursorGlowColor: '#FB7185',
        cursorTrailEnabled: true,
        cursorTrailCount: 3,
        cursorTrailOpacity: 32,
      );
    case 'doubleClick':
      return base.copyWith(
        particle: true,
        particleStyle: '钻石',
        particleCount: 28,
        particleSpread: 76,
        particlePalette: ['#F43F5E', '#FB7185', '#FDA4AF', '#FBCFE8'],
        particleSize: 14,
        particleOpacity: 88,
        particleGravity: 6,
        particleWind: 3,
        particleBounce: 12,
        ripple: true,
        rippleStyle: '双环',
        rippleColor: '#FB7185',
        rippleSize: 62,
        rippleOpacity: 52,
        textGradient: true,
        textGradientStart: '#F43F5E',
        textGradientEnd: '#FB923C',
        fontSize: 22,
        animationEnabled: true,
        animationStyle: '弹跳徽记',
        animationColor: '#FB7185',
        animationDuration: 600,
        sound: false,
      );
    case 'wheel':
      return base.copyWith(
        particle: true,
        particleStyle: '钻石',
        particleCount: 8,
        particlePalette: ['#FDA4AF', '#FBCFE8'],
        particleGravity: 6,
        particleWind: 4,
        ripple: true,
        rippleColor: '#FB7185',
        rippleStyle: '柔和面波',
        textEnabled: false,
        sound: false,
      );
    case 'hover':
      return base.copyWith(
        ripple: true,
        rippleStyle: '柔和面波',
        rippleColor: '#FDA4AF',
        rippleOpacity: 22,
        cursorGlowColor: '#FDA4AF',
        textEnabled: true,
        textKind: '文本飘字',
        textTags: ['✦', '·', '◦'],
        textTagPlayMode: '随机显示',
        textColor: '#BE185D',
        fontSize: 14,
        sound: false,
      );
    case 'rightClick':
      return base.copyWith(
        particle: true,
        particleStyle: '钻石',
        particleCount: 12,
        particlePalette: ['#FB7185', '#FDA4AF'],
        particleGravity: 4,
        ripple: true,
        rippleColor: '#FB7185',
        rippleStyle: '双环',
        textColor: '#BE185D',
        sound: false,
      );
    case 'longPress':
      return base.copyWith(
        particle: true,
        particleStyle: '钻石',
        particleCount: 18,
        particleGravity: 10,
        particleBounce: 14,
        particlePalette: ['#F43F5E', '#FB7185', '#FDA4AF'],
        ripple: true,
        rippleStyle: '回声环',
        rippleColor: '#FB7185',
        textColor: '#BE185D',
        animationEnabled: true,
        animationStyle: '聚焦脉冲',
        animationColor: '#FB7185',
        sound: false,
      );
    default:
      return base;
  }
}

// ═══════════════════════════════════════════════════════════════
// Public API
// ═══════════════════════════════════════════════════════════════

Map<String, ActionConfig> defaultActionConfigs(String themeId) {
  final result = <String, ActionConfig>{};
  for (final actionId in kActionIds) {
    final preset = presetForAction(actionId);
    result[actionId] = _applyThemeOverrides(preset, themeId, actionId);
  }
  return result;
}

Map<String, ActionConfig> cloneActionConfigs(Map<String, ActionConfig> configs) {
  return Map<String, ActionConfig>.from(configs);
}

TimingFieldMeta timingFieldMeta(String actionId) {
  switch (actionId) {
    case 'longPress':
      return TimingFieldMeta('长按阈值', '按住多久以后才算长按。', 200, 900);
    case 'doubleClick':
      return TimingFieldMeta('双击间隔', '两次点击之间允许的最大间隔。', 180, 520);
    case 'hover':
      return TimingFieldMeta('停留阈值', '鼠标停多久之后再触发 hover 效果。', 80, 700);
    case 'wheel':
      return TimingFieldMeta('合并间隔', '连续滚动时，多久合并为一次反馈。', 80, 520);
    default:
      return TimingFieldMeta('触发延迟', '动作识别后，延迟多久开始反馈。', 0, 320);
  }
}

List<String> conflictsForAction(String actionId, Map<String, ActionConfig> configs) {
  final current = configs[actionId];
  if (current == null) return [];
  final result = <String>[];

  if (actionId == 'longPress' &&
      current.sound &&
      (configs['leftClick']?.sound ?? false)) {
    result.add('长按和左键单击都在使用音效，后续需要明确谁先触发。');
  }

  if (!current.textEnabled &&
      !current.particle &&
      !current.ripple &&
      !current.sound &&
      !current.animationEnabled &&
      !current.imageEnabled) {
    result.add('当前动作没有绑定任何反馈，用户点击时会感觉没效果。');
  }

  return result;
}

class TimingFieldMeta {
  final String label;
  final String hint;
  final int min;
  final int max;

  const TimingFieldMeta(this.label, this.hint, this.min, this.max);
}
