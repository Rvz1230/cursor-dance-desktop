import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'tokens.dart';
import 'animations.dart';

// ── Light theme ──────────────────────────────────────────

final appTheme = ShadThemeData(
  brightness: Brightness.light,
  radius: const BorderRadius.all(Radius.circular(RadiusTokens.xl)),
  colorScheme: _lightColorScheme,
  textTheme: _textTheme,
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

// ── Dark theme ───────────────────────────────────────────

final darkTheme = ShadThemeData(
  brightness: Brightness.dark,
  radius: const BorderRadius.all(Radius.circular(RadiusTokens.xl)),
  colorScheme: _darkColorScheme,
  primaryToastTheme: ShadToastTheme(
    animateIn: AppAnimations.slideIn,
    animateOut: AppAnimations.slideOut,
  ),
  textTheme: _darkTextTheme,
  popoverTheme: _popoverThemeDark,
  selectTheme: _selectThemeDark,
  optionTheme: _optionTheme,
  contextMenuTheme: _contextMenuThemeDark,
  cardTheme: _cardThemeDark,
);

// ── Color schemes ────────────────────────────────────────

final _lightColorScheme = ShadColorScheme(
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

// ── Text themes ──────────────────────────────────────────

final _textTheme = ShadTextTheme(
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

final _darkTextTheme = ShadTextTheme(
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
);

// ── Borders ──────────────────────────────────────────────

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

// ── Light sub-themes ─────────────────────────────────────

final _popoverThemeLight = ShadPopoverTheme(
  shadows: ShadowTokens.cardElevated,
  padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: 6),
  decoration: const ShadDecoration(border: _popoverBorder),
);

final _selectThemeLight = ShadSelectTheme(
  decoration: const ShadDecoration(border: _inputBorder),
  padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
  optionsPadding: const EdgeInsets.all(Spacing.xs),
  anchor: const ShadAnchorAuto(offset: Offset(0, Spacing.xs)),
);

final _contextMenuThemeLight = ShadContextMenuTheme(
  decoration: const ShadDecoration(border: _popoverBorder),
  shadows: ShadowTokens.cardElevated,
  padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
  itemPadding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
  height: 32,
);

final _cardThemeLight = ShadCardTheme(
  padding: EdgeInsets.zero,
  radius: const BorderRadius.all(Radius.circular(RadiusTokens.xl)),
  border: _inputBorder,
  shadows: ShadowTokens.card,
);

// ── Dark sub-themes ──────────────────────────────────────

final _popoverThemeDark = ShadPopoverTheme(
  shadows: ShadowTokens.darkCardElevated,
  padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: 6),
  decoration: const ShadDecoration(border: _darkPopoverBorder),
);

final _selectThemeDark = ShadSelectTheme(
  decoration: const ShadDecoration(border: _darkInputBorder),
  padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
  optionsPadding: const EdgeInsets.all(Spacing.xs),
  anchor: const ShadAnchorAuto(offset: Offset(0, Spacing.xs)),
);

final _contextMenuThemeDark = ShadContextMenuTheme(
  decoration: const ShadDecoration(border: _darkPopoverBorder),
  shadows: ShadowTokens.darkCardElevated,
  padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
  itemPadding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
  height: 32,
);

final _cardThemeDark = ShadCardTheme(
  padding: EdgeInsets.zero,
  radius: const BorderRadius.all(Radius.circular(RadiusTokens.xl)),
  border: _darkInputBorder,
  shadows: ShadowTokens.darkCard,
);

// ── Shared sub-themes ────────────────────────────────────

final _optionTheme = ShadOptionTheme(
  hoveredBackgroundColor: AppColors.muted,
  padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
  radius: const BorderRadius.all(Radius.circular(RadiusTokens.lg)),
);
