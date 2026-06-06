import 'action_config.dart';

class ThemeItem {
  final String id;
  final String name;
  final String kind; // "内置" or "自定义"
  final String summary;
  final String description;
  final String tone; // "amber", "teal", "slate", "rose", "sky"
  final String icon; // Lucide icon name

  const ThemeItem({
    required this.id,
    required this.name,
    this.kind = '自定义',
    this.summary = '',
    this.description = '',
    this.tone = 'teal',
    this.icon = 'Wand2',
  });

  ThemeItem copyWith({
    String? id,
    String? name,
    String? kind,
    String? summary,
    String? description,
    String? tone,
    String? icon,
  }) {
    return ThemeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      tone: tone ?? this.tone,
      icon: icon ?? this.icon,
    );
  }
}

const kThemeTones = ['amber', 'teal', 'sky', 'rose', 'slate'];

const kThemeToneById = {
  'mono-geo': 'slate',
  'drift': 'teal',
  'molten': 'amber',
  'sunset': 'rose',
};

String themeTone(String themeId, [int fallbackIndex = 0]) {
  return kThemeToneById[themeId] ?? kThemeTones[fallbackIndex % kThemeTones.length];
}

String buildThemeSummary(Map<String, ActionConfig>? actionConfigs) {
  final leftClick = actionConfigs?['leftClick'];
  if (leftClick == null) return '默认反馈主题';
  final parts = <String>[];
  if (leftClick.textEnabled) {
    parts.add(leftClick.textKind == '文本飘字' ? '文本飘字' : '数字飘字');
  }
  if (leftClick.sound) parts.add('声音反馈');
  if (leftClick.animationEnabled) parts.add('动画反馈');
  if (leftClick.imageEnabled) parts.add('图片贴纸');
  if (leftClick.ripple) parts.add('轻波纹');
  if (leftClick.particle) parts.add('粒子反馈');
  return parts.isEmpty ? '默认反馈主题' : parts.take(3).join(' · ');
}

const kBuiltinThemes = [
  ThemeItem(
    id: 'mono-geo',
    name: '几何',
    kind: '内置',
    summary: '黑白灰 · 方块粒子 · 几何波纹',
    tone: 'slate',
    icon: 'Wand2',
  ),
  ThemeItem(
    id: 'drift',
    name: '流光',
    kind: '内置',
    summary: '轨道粒子 · 涟漪扩散 · 沉静青绿',
    tone: 'teal',
    icon: 'Wand2',
  ),
  ThemeItem(
    id: 'molten',
    name: '熔金',
    kind: '内置',
    summary: '火花喷发 · 能量脉冲 · 熔岩橙金',
    tone: 'amber',
    icon: 'Wand2',
  ),
  ThemeItem(
    id: 'sunset',
    name: '夕霞',
    kind: '内置',
    summary: '钻石飘落 · 回声涟漪 · 落日粉橙',
    tone: 'rose',
    icon: 'Wand2',
  ),
];
