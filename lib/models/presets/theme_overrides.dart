import '../action_config.dart';
import 'preset_factories.dart';

// ═══════════════════════════════════════════════════════════════
// Theme Action Overrides — per-theme overrides for each action
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

/// Builds the full set of action configs for a theme by applying
/// theme-specific overrides on top of the per-action presets.
Map<String, ActionConfig> defaultActionConfigs(String themeId) {
  final result = <String, ActionConfig>{};
  for (final actionId in kActionIds) {
    final preset = presetForAction(actionId);
    result[actionId] = applyThemeOverrides(preset, themeId, actionId);
  }
  return result;
}

ActionConfig applyThemeOverrides(ActionConfig base, String themeId, String actionId) {
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

// ═══════════════════════════════════════════════════════════════
// Mono-Geo (黑白灰 · 方块粒子 · 几何波纹)
// ═══════════════════════════════════════════════════════════════

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

// ═══════════════════════════════════════════════════════════════
// Drift (轨道粒子 · 涟漪扩散 · 沉静青绿)
// ═══════════════════════════════════════════════════════════════

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

// ═══════════════════════════════════════════════════════════════
// Molten (火花喷发 · 能量脉冲 · 熔岩橙金)
// ═══════════════════════════════════════════════════════════════

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

// ═══════════════════════════════════════════════════════════════
// Sunset (钻石飘落 · 回声涟漪 · 落日粉橙)
// ═══════════════════════════════════════════════════════════════

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
