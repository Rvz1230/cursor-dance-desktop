import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/tokens.dart';

class PanelMeta {
  final IconData icon;
  final Color lightBg;
  final Color lightFg;
  final Color darkBg;
  final Color darkFg;

  const PanelMeta({
    required this.icon,
    required this.lightBg,
    required this.lightFg,
    required this.darkBg,
    required this.darkFg,
  });

  Color bg(Brightness brightness) =>
      brightness == Brightness.dark ? darkBg : lightBg;

  Color fg(Brightness brightness) =>
      brightness == Brightness.dark ? darkFg : lightFg;
}

class PanelMetaRegistry {
  PanelMetaRegistry._();

  static const trigger = PanelMeta(
    icon: LucideIcons.mousePointerClick,
    lightBg: AppColors.toneTriggerBg,
    lightFg: AppColors.toneTriggerFg,
    darkBg: AppDarkColors.toneTriggerBg,
    darkFg: AppDarkColors.toneTriggerFg,
  );

  static const text = PanelMeta(
    icon: LucideIcons.type,
    lightBg: AppColors.toneTextBg,
    lightFg: AppColors.toneTextFg,
    darkBg: AppDarkColors.toneTextBg,
    darkFg: AppDarkColors.toneTextFg,
  );

  static const particle = PanelMeta(
    icon: LucideIcons.sparkles,
    lightBg: AppColors.toneParticleBg,
    lightFg: AppColors.toneParticleFg,
    darkBg: AppDarkColors.toneParticleBg,
    darkFg: AppDarkColors.toneParticleFg,
  );

  static const ripple = PanelMeta(
    icon: LucideIcons.circle,
    lightBg: AppColors.toneRippleBg,
    lightFg: AppColors.toneRippleFg,
    darkBg: AppDarkColors.toneRippleBg,
    darkFg: AppDarkColors.toneRippleFg,
  );

  static const audio = PanelMeta(
    icon: LucideIcons.volume2,
    lightBg: AppColors.toneAudioBg,
    lightFg: AppColors.toneAudioFg,
    darkBg: AppDarkColors.toneAudioBg,
    darkFg: AppDarkColors.toneAudioFg,
  );

  static const animation = PanelMeta(
    icon: LucideIcons.play,
    lightBg: AppColors.toneAnimationBg,
    lightFg: AppColors.toneAnimationFg,
    darkBg: AppDarkColors.toneAnimationBg,
    darkFg: AppDarkColors.toneAnimationFg,
  );

  static const image = PanelMeta(
    icon: LucideIcons.image,
    lightBg: AppColors.toneImageBg,
    lightFg: AppColors.toneImageFg,
    darkBg: AppDarkColors.toneImageBg,
    darkFg: AppDarkColors.toneImageFg,
  );

  static const cursor = PanelMeta(
    icon: LucideIcons.mousePointer2,
    lightBg: AppColors.toneCursorBg,
    lightFg: AppColors.toneCursorFg,
    darkBg: AppDarkColors.toneCursorBg,
    darkFg: AppDarkColors.toneCursorFg,
  );
}
