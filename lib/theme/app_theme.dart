import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'app_tokens.dart';
import 'animations.dart';

/// 浅色主题 — Soft-Minimal Linear
final appTheme = ShadThemeData(
  brightness: Brightness.light,
  radius: const BorderRadius.all(Radius.circular(RadiusTokens.xl)),
  colorScheme: _appColorScheme,
  textTheme: _appTextTheme,
  primaryToastTheme: ShadToastTheme(
    animateIn: AppAnimations.slideIn,
    animateOut: AppAnimations.slideOut,
  ),
  popoverTheme: _popoverThemeLight,
  selectTheme: _selectThemeLight,
  optionTheme: _optionTheme,
  contextMenuTheme: _contextMenuThemeLight,
  cardTheme: _cardThemeLight,
);

/// 深色主题 — 反转亮度层级，保持相同色调映射
final darkTheme = ShadThemeData(
  brightness: Brightness.dark,
  radius: const BorderRadius.all(Radius.circular(RadiusTokens.xl)),
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
  popoverTheme: _popoverThemeDark,
  selectTheme: _selectThemeDark,
  optionTheme: _optionTheme,
  contextMenuTheme: _contextMenuThemeDark,
  cardTheme: _cardThemeDark,
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

// ── 共享阴影 ──

final _popoverShadows = <BoxShadow>[
  BoxShadow(
    color: const Color(0x08000000),
    blurRadius: 4,
    offset: const Offset(0, 1),
  ),
  BoxShadow(
    color: const Color(0x14000000),
    blurRadius: 12,
    offset: const Offset(0, 4),
  ),
];

final _cardShadows = <BoxShadow>[
  BoxShadow(
    color: const Color(0x08000000),
    blurRadius: 4,
    offset: const Offset(0, 1),
  ),
];

final _darkPopoverShadows = <BoxShadow>[
  BoxShadow(
    color: const Color(0x20000000),
    blurRadius: 4,
    offset: const Offset(0, 1),
  ),
  BoxShadow(
    color: const Color(0x30000000),
    blurRadius: 12,
    offset: const Offset(0, 4),
  ),
];

final _darkCardShadows = <BoxShadow>[
  BoxShadow(
    color: const Color(0x20000000),
    blurRadius: 4,
    offset: const Offset(0, 1),
  ),
];

// ── 浅色子主题 ──

final _popoverThemeLight = ShadPopoverTheme(
  shadows: _popoverShadows,
  padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: 6),
  decoration: const ShadDecoration(
    border: _popoverBorder,
  ),
);

final _selectThemeLight = ShadSelectTheme(
  decoration: const ShadDecoration(
    border: _inputBorder,
  ),
  padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
  optionsPadding: const EdgeInsets.all(Spacing.xs),
  anchor: const ShadAnchorAuto(
    offset: Offset(0, Spacing.xs),
  ),
);

final _contextMenuThemeLight = ShadContextMenuTheme(
  decoration: const ShadDecoration(
    border: _popoverBorder,
  ),
  shadows: _popoverShadows,
  padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
  itemPadding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
  height: 32,
);

final _cardThemeLight = ShadCardTheme(
  padding: EdgeInsets.zero,
  radius: const BorderRadius.all(Radius.circular(RadiusTokens.xl)),
  border: _cardBorder,
  shadows: _cardShadows,
);

// ── 深色子主题 ──

final _popoverThemeDark = ShadPopoverTheme(
  shadows: _darkPopoverShadows,
  padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: 6),
  decoration: const ShadDecoration(
    border: _darkPopoverBorder,
  ),
);

final _selectThemeDark = ShadSelectTheme(
  decoration: const ShadDecoration(
    border: _darkInputBorder,
  ),
  padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
  optionsPadding: const EdgeInsets.all(Spacing.xs),
  anchor: const ShadAnchorAuto(
    offset: Offset(0, Spacing.xs),
  ),
);

final _contextMenuThemeDark = ShadContextMenuTheme(
  decoration: const ShadDecoration(
    border: _darkPopoverBorder,
  ),
  shadows: _darkPopoverShadows,
  padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
  itemPadding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
  height: 32,
);

final _cardThemeDark = ShadCardTheme(
  padding: EdgeInsets.zero,
  radius: const BorderRadius.all(Radius.circular(RadiusTokens.xl)),
  border: _darkCardBorder,
  shadows: _darkCardShadows,
);

// ── 共享子主题（与色彩模式无关） ──

final _optionTheme = ShadOptionTheme(
  hoveredBackgroundColor: AppColors.muted,
  padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
  radius: const BorderRadius.all(Radius.circular(RadiusTokens.sm)),
);

// ── 边框常量 ──

const _popoverBorder = ShadBorder(
  top: ShadBorderSide(color: AppColors.border, width: 1),
  right: ShadBorderSide(color: AppColors.border, width: 1),
  bottom: ShadBorderSide(color: AppColors.border, width: 1),
  left: ShadBorderSide(color: AppColors.border, width: 1),
  radius: BorderRadius.all(Radius.circular(RadiusTokens.xl2)),
);

const _inputBorder = ShadBorder(
  top: ShadBorderSide(color: AppColors.border, width: 1),
  right: ShadBorderSide(color: AppColors.border, width: 1),
  bottom: ShadBorderSide(color: AppColors.border, width: 1),
  left: ShadBorderSide(color: AppColors.border, width: 1),
  radius: BorderRadius.all(Radius.circular(RadiusTokens.xl)),
);

const _darkPopoverBorder = ShadBorder(
  top: ShadBorderSide(color: AppDarkColors.border, width: 1),
  right: ShadBorderSide(color: AppDarkColors.border, width: 1),
  bottom: ShadBorderSide(color: AppDarkColors.border, width: 1),
  left: ShadBorderSide(color: AppDarkColors.border, width: 1),
  radius: BorderRadius.all(Radius.circular(RadiusTokens.xl2)),
);

const _darkInputBorder = ShadBorder(
  top: ShadBorderSide(color: AppDarkColors.border, width: 1),
  right: ShadBorderSide(color: AppDarkColors.border, width: 1),
  bottom: ShadBorderSide(color: AppDarkColors.border, width: 1),
  left: ShadBorderSide(color: AppDarkColors.border, width: 1),
  radius: BorderRadius.all(Radius.circular(RadiusTokens.xl)),
);

const _cardBorder = _inputBorder;
final _darkCardBorder = _darkInputBorder;

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
