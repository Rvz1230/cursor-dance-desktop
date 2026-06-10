import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'app_tokens.dart';
import 'animations.dart';

/// 浅色主题 — Soft-Minimal Linear
final appTheme = ShadThemeData(
  brightness: Brightness.light,
  radius: BorderRadius.all(Radius.circular(RadiusTokens.xl)),
  colorScheme: _appColorScheme,
  textTheme: _appTextTheme,
  primaryToastTheme: ShadToastTheme(
    animateIn: AppAnimations.slideIn,
    animateOut: AppAnimations.slideOut,
  ),
);

/// 深色主题 — 反转亮度层级，保持相同色调映射
final darkTheme = ShadThemeData(
  brightness: Brightness.dark,
  radius: BorderRadius.all(Radius.circular(RadiusTokens.xl)),
  colorScheme: _darkColorScheme,
  primaryToastTheme: ShadToastTheme(
    animateIn: AppAnimations.slideIn,
    animateOut: AppAnimations.slideOut,
  ),
  textTheme: _appTextTheme.copyWith(
    h2: const TextStyle(
      fontSize: FontSizes.h2,
      fontWeight: FontWeight.w700,
      height: 1.3,
      color: AppDarkColors.foreground,
    ),
    h3: const TextStyle(
      fontSize: FontSizes.h3,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: AppDarkColors.foreground,
    ),
    h4: const TextStyle(
      fontSize: FontSizes.h4,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: AppDarkColors.foreground,
    ),
    p: const TextStyle(
      fontSize: FontSizes.body,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppDarkColors.foreground,
    ),
    small: const TextStyle(
      fontSize: FontSizes.small,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: AppDarkColors.foreground,
    ),
    muted: const TextStyle(
      fontSize: FontSizes.small,
      fontWeight: FontWeight.w400,
      color: AppDarkColors.mutedForeground,
      height: 1.4,
    ),
  ),
);

// ── 浅色配色 ──

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

// ── 深色配色 ──

final _darkColorScheme = ShadColorScheme(
  background: AppDarkColors.background,
  foreground: AppDarkColors.foreground,
  card: AppDarkColors.card,
  cardForeground: AppDarkColors.cardForeground,
  popover: AppDarkColors.popover,
  popoverForeground: AppDarkColors.popoverForeground,
  primary: AppDarkColors.primary,
  primaryForeground: AppDarkColors.primaryForeground,
  secondary: AppDarkColors.secondary,
  secondaryForeground: AppDarkColors.secondaryForeground,
  muted: AppDarkColors.muted,
  mutedForeground: AppDarkColors.mutedForeground,
  accent: AppDarkColors.accent,
  accentForeground: AppDarkColors.accentForeground,
  destructive: AppDarkColors.destructive,
  destructiveForeground: AppDarkColors.destructiveForeground,
  border: AppDarkColors.border,
  input: AppDarkColors.input,
  ring: AppDarkColors.ring,
  selection: AppDarkColors.selection,
  custom: const {
    'success': AppDarkColors.success,
    'warning': AppDarkColors.warning,
  },
);

// ── 共享文本主题 ──

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
