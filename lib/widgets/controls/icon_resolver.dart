import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';

/// Theme icon name → LucideIcons mapping.
const kThemeIconMap = <String, IconData>{
  'Wand2': LucideIcons.wand2,
  'Sparkles': LucideIcons.sparkles,
  'Heart': LucideIcons.heart,
  'Star': LucideIcons.star,
  'Smile': LucideIcons.smile,
  'Zap': LucideIcons.zap,
  'Flame': LucideIcons.flame,
  'Gem': LucideIcons.gem,
  'Cloud': LucideIcons.cloud,
  'Moon': LucideIcons.moon,
  'Sun': LucideIcons.sun,
  'Palette': LucideIcons.palette,
  'Music': LucideIcons.music,
  'Leaf': LucideIcons.leaf,
  'Snowflake': LucideIcons.snowflake,
};

/// Available theme icon names (aligned with plugin ICON_OPTIONS).
const kThemeIconNames = [
  'Wand2',
  'Sparkles',
  'Heart',
  'Star',
  'Smile',
  'Zap',
  'Flame',
  'Gem',
  'Cloud',
  'Moon',
  'Sun',
  'Palette',
  'Music',
  'Leaf',
  'Snowflake',
];

IconData resolveThemeIcon(String name) {
  return kThemeIconMap[name] ?? LucideIcons.wand2;
}

/// Action ID → icon mapping.
const kActionIconMap = <String, IconData>{
  'leftClick': LucideIcons.mousePointer2,
  'rightClick': LucideIcons.arrowUpFromLine,
  'doubleClick': LucideIcons.mousePointerClick,
  'longPress': LucideIcons.hand,
  'wheel': LucideIcons.scrollText,
  'hover': LucideIcons.eye,
};

IconData actionIcon(String actionId) {
  return kActionIconMap[actionId] ?? LucideIcons.mousePointer2;
}

/// Kind badge colors.
class KindBadgeStyle {
  final Color bg;
  final Color fg;
  final Color border;

  const KindBadgeStyle({
    required this.bg,
    required this.fg,
    required this.border,
  });
}

const kKindBadgeStyles = <String, KindBadgeStyle>{
  '内置': KindBadgeStyle(
    bg: Color(0xFFCCFBF1),
    fg: Color(0xFF0D9488),
    border: Color(0xFF5EEAD4),
  ),
  '自定义': KindBadgeStyle(
    bg: Color(0xFFFEF3C7),
    fg: Color(0xFFB45309),
    border: Color(0xFFFCD34D),
  ),
};

KindBadgeStyle kindBadgeStyle(String kind) {
  return kKindBadgeStyles[kind] ?? kKindBadgeStyles['自定义']!;
}
