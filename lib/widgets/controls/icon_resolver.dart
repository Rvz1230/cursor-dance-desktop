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
