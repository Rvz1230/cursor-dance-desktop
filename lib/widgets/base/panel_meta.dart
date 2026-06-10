import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/app_tokens.dart';

/// 效果卡片图标色调元数据
///
/// 对应插件版 PANEL_META，每张卡片拥有独立的图标 + 色调。
class PanelMeta {
  final IconData icon;
  final Color bg;
  final Color fg;

  const PanelMeta({
    required this.icon,
    required this.bg,
    required this.fg,
  });
}

/// 所有效果卡片的图标色调注册表
class PanelMetaRegistry {
  PanelMetaRegistry._();

  static const trigger = PanelMeta(
    icon: LucideIcons.mousePointer2,
    bg: AppColors.toneTriggerBg,
    fg: AppColors.toneTriggerFg,
  );

  static const text = PanelMeta(
    icon: LucideIcons.type,
    bg: AppColors.toneTextBg,
    fg: AppColors.toneTextFg,
  );

  static const particle = PanelMeta(
    icon: LucideIcons.waves,
    bg: AppColors.toneParticleBg,
    fg: AppColors.toneParticleFg,
  );

  static const ripple = PanelMeta(
    icon: LucideIcons.circleDashed,
    bg: AppColors.toneRippleBg,
    fg: AppColors.toneRippleFg,
  );

  static const audio = PanelMeta(
    icon: LucideIcons.volume2,
    bg: AppColors.toneAudioBg,
    fg: AppColors.toneAudioFg,
  );

  static const animation = PanelMeta(
    icon: LucideIcons.sparkles,
    bg: AppColors.toneAnimationBg,
    fg: AppColors.toneAnimationFg,
  );

  static const image = PanelMeta(
    icon: LucideIcons.imagePlus,
    bg: AppColors.toneImageBg,
    fg: AppColors.toneImageFg,
  );

  static const cursor = PanelMeta(
    icon: LucideIcons.settings2,
    bg: AppColors.toneCursorBg,
    fg: AppColors.toneCursorFg,
  );

  static const keyboard = PanelMeta(
    icon: LucideIcons.keyboard,
    bg: AppColors.toneKeyboardBg,
    fg: AppColors.toneKeyboardFg,
  );

  /// 深色模式的色调映射
  static final Map<IconData, Color> _darkBg = {
    LucideIcons.mousePointer2: AppDarkColors.toneTriggerBg,
    LucideIcons.type: AppDarkColors.toneTextBg,
    LucideIcons.waves: AppDarkColors.toneParticleBg,
    LucideIcons.circleDashed: AppDarkColors.toneRippleBg,
    LucideIcons.volume2: AppDarkColors.toneAudioBg,
    LucideIcons.sparkles: AppDarkColors.toneAnimationBg,
    LucideIcons.imagePlus: AppDarkColors.toneImageBg,
    LucideIcons.settings2: AppDarkColors.toneCursorBg,
    LucideIcons.keyboard: AppDarkColors.toneKeyboardBg,
  };

  static final Map<IconData, Color> _darkFg = {
    LucideIcons.mousePointer2: AppDarkColors.toneTriggerFg,
    LucideIcons.type: AppDarkColors.toneTextFg,
    LucideIcons.waves: AppDarkColors.toneParticleFg,
    LucideIcons.circleDashed: AppDarkColors.toneRippleFg,
    LucideIcons.volume2: AppDarkColors.toneAudioFg,
    LucideIcons.sparkles: AppDarkColors.toneAnimationFg,
    LucideIcons.imagePlus: AppDarkColors.toneImageFg,
    LucideIcons.settings2: AppDarkColors.toneCursorFg,
    LucideIcons.keyboard: AppDarkColors.toneKeyboardFg,
  };

  static PanelMeta darkVariant(PanelMeta light) {
    return PanelMeta(
      icon: light.icon,
      bg: _darkBg[light.icon] ?? light.bg,
      fg: _darkFg[light.icon] ?? light.fg,
    );
  }
}
