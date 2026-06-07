import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'app_tokens.dart';

/// CursorDance Application Theme
///
/// Soft-Minimal Linear 浅色主题，使用 slate 单色系 + 语义功能色。
/// 匹配插件版 DESIGN.md 规范。
final appTheme = ShadThemeData(
  brightness: Brightness.light,
  radius: BorderRadius.all(Radius.circular(RadiusTokens.xl)),
  colorScheme: _appColorScheme,
  textTheme: _appTextTheme,
);

final _appColorScheme = ShadColorScheme(
  background: AppColors.background,
  foreground: AppColors.foreground,
  card: AppColors.card,
  cardForeground: AppColors.cardForeground,
  popover: AppColors.popover,
  popoverForeground: AppColors.popoverForeground,
  primary: AppColors.primary,
  primaryForeground: AppColors.primaryForeground,
  secondary: AppColors.secondary,
  secondaryForeground: AppColors.secondaryForeground,
  muted: AppColors.muted,
  mutedForeground: AppColors.mutedForeground,
  accent: AppColors.accent,
  accentForeground: AppColors.accentForeground,
  destructive: AppColors.destructive,
  destructiveForeground: AppColors.destructiveForeground,
  border: AppColors.border,
  input: AppColors.input,
  ring: AppColors.ring,
  selection: AppColors.selection,
  custom: const {
    'success': AppColors.success,
    'warning': AppColors.warning,
  },
);

final _appTextTheme = ShadTextTheme(
  h2: const TextStyle(
    fontSize: FontSizes.h2,
    fontWeight: FontWeight.w700,
    height: 1.3,
  ),
  h3: const TextStyle(
    fontSize: FontSizes.h3,
    fontWeight: FontWeight.w600,
    height: 1.4,
  ),
  h4: const TextStyle(
    fontSize: FontSizes.h4,
    fontWeight: FontWeight.w600,
    height: 1.4,
  ),
  p: const TextStyle(
    fontSize: FontSizes.body,
    fontWeight: FontWeight.w400,
    height: 1.5,
  ),
  small: const TextStyle(
    fontSize: FontSizes.small,
    fontWeight: FontWeight.w400,
    height: 1.4,
  ),
  muted: const TextStyle(
    fontSize: FontSizes.small,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedForeground,
    height: 1.4,
  ),
);
