import 'package:flutter/material.dart';

// ── Spacing ──────────────────────────────────────────────
// 呼吸感节奏：lg/xl/section 刻意偏离 4px 倍数制造松紧交替。

class Spacing {
  Spacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;
  static const double xl = 28;
  static const double xxl = 32;
  static const double section = 40;
}

// ── Icon sizes ───────────────────────────────────────────

class IconSizes {
  IconSizes._();
  static const double xs = 10;
  static const double sm = 12;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double xxl = 32;
}

// ── Radius ───────────────────────────────────────────────
// Soft-Minimal Linear 风格

class RadiusTokens {
  RadiusTokens._();
  static const double none = 0;
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 8;
  static const double xl = 12;
  static const double xl2 = 16;
}

// ── Font sizes ───────────────────────────────────────────

class FontSizes {
  FontSizes._();
  static const double micro = 9;
  static const double caption = 11;
  static const double small = 12;
  static const double body = 13;
  static const double base = 14;
  static const double h4 = 14;
  static const double h3 = 16;
  static const double h2 = 18;
}

// ── Shadows ──────────────────────────────────────────────
// 层次感三档：card < cardElevated < panel

class ShadowTokens {
  ShadowTokens._();

  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> cardElevated = [
    BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> panel = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x18000000), blurRadius: 16, offset: Offset(0, 6)),
  ];

  // Dark variants
  static const List<BoxShadow> darkCard = [
    BoxShadow(color: Color(0x20000000), blurRadius: 4, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> darkCardElevated = [
    BoxShadow(color: Color(0x20000000), blurRadius: 4, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x30000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> darkPanel = [
    BoxShadow(color: Color(0x28000000), blurRadius: 6, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x38000000), blurRadius: 16, offset: Offset(0, 6)),
  ];
}

// ── Colors — Light ───────────────────────────────────────
// 仅用于 theme 定义，Widget 中应通过 ShadTheme.of(context).colorScheme 访问。
// Soft-Minimal Linear slate 色系。禁止装饰性渐变/紫色/glow。

class AppColors {
  AppColors._();

  // Base (slate)
  static const Color background = Color(0xFFF8F8FA);
  static const Color foreground = Color(0xFF0F172A);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF0F172A);
  static const Color popover = Color(0xFFFFFFFF);
  static const Color popoverForeground = Color(0xFF0F172A);
  static const Color muted = Color(0xFFF1F5F9);
  static const Color mutedForeground = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color input = Color(0xFFE2E8F0);

  // Primary (slate-900)
  static const Color primary = Color(0xFF0F172A);
  static const Color primaryForeground = Color(0xFFFFFFFF);

  // Secondary
  static const Color secondary = Color(0xFFF1F5F9);
  static const Color secondaryForeground = Color(0xFF1E293B);

  // Accent
  static const Color accent = Color(0xFFF1F5F9);
  static const Color accentForeground = Color(0xFF1E293B);

  // Semantic
  static const Color destructive = Color(0xFFE11D48);
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // Functional
  static const Color selection = Color(0xFFDBEAFE);
  static const Color ring = Color(0xFF94A3B8);

  // Effect card tone colors (light)
  static const Color toneTriggerBg = Color(0xFFD1FAE5);
  static const Color toneTriggerFg = Color(0xFF047857);
  static const Color toneTextBg = Color(0xFFFEF3C7);
  static const Color toneTextFg = Color(0xFFB45309);
  static const Color toneParticleBg = Color(0xFFE0F2FE);
  static const Color toneParticleFg = Color(0xFF0369A1);
  static const Color toneRippleBg = Color(0xFFCCFBF1);
  static const Color toneRippleFg = Color(0xFF0D9488);
  static const Color toneAudioBg = Color(0xFFFFE4E6);
  static const Color toneAudioFg = Color(0xFFBE123C);
  static const Color toneAnimationBg = Color(0xFFCFFAFE);
  static const Color toneAnimationFg = Color(0xFF0E7490);
  static const Color toneImageBg = Color(0xFFFAE8FF);
  static const Color toneImageFg = Color(0xFFA21CAF);
  static const Color toneCursorBg = Color(0xFFF1F5F9);
  static const Color toneCursorFg = Color(0xFF334155);
  static const Color toneKeyboardBg = Color(0xFFE0E7FF);
  static const Color toneKeyboardFg = Color(0xFF4F46E5);
}

// ── Colors — Dark ────────────────────────────────────────

class AppDarkColors {
  AppDarkColors._();

  static const Color background = Color(0xFF0F172A);
  static const Color foreground = Color(0xFFF1F5F9);
  static const Color card = Color(0xFF1E293B);
  static const Color cardForeground = Color(0xFFF1F5F9);
  static const Color popover = Color(0xFF1E293B);
  static const Color popoverForeground = Color(0xFFF1F5F9);
  static const Color muted = Color(0xFF334155);
  static const Color mutedForeground = Color(0xFF94A3B8);
  static const Color border = Color(0xFF334155);
  static const Color input = Color(0xFF475569);

  static const Color primary = Color(0xFFF1F5F9);
  static const Color primaryForeground = Color(0xFF1E293B);
  static const Color secondary = Color(0xFF334155);
  static const Color secondaryForeground = Color(0xFFE2E8F0);
  static const Color accent = Color(0xFF334155);
  static const Color accentForeground = Color(0xFFE2E8F0);

  static const Color destructive = Color(0xFFF43F5E);
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color selection = Color(0xFF1E40AF);
  static const Color ring = Color(0xFF64748B);

  // Effect card tone colors (dark)
  static const Color toneTriggerBg = Color(0xFF064E3B);
  static const Color toneTriggerFg = Color(0xFF6EE7B7);
  static const Color toneTextBg = Color(0xFF78350F);
  static const Color toneTextFg = Color(0xFFFCD34D);
  static const Color toneParticleBg = Color(0xFF075985);
  static const Color toneParticleFg = Color(0xFF7DD3FC);
  static const Color toneRippleBg = Color(0xFF134E4A);
  static const Color toneRippleFg = Color(0xFF5EEAD4);
  static const Color toneAudioBg = Color(0xFF881337);
  static const Color toneAudioFg = Color(0xFFFDA4AF);
  static const Color toneAnimationBg = Color(0xFF164E63);
  static const Color toneAnimationFg = Color(0xFF67E8F9);
  static const Color toneImageBg = Color(0xFF4A044E);
  static const Color toneImageFg = Color(0xFFF0ABFC);
  static const Color toneCursorBg = Color(0xFF334155);
  static const Color toneCursorFg = Color(0xFFE2E8F0);
  static const Color toneKeyboardBg = Color(0xFF312E81);
  static const Color toneKeyboardFg = Color(0xFFA5B4FC);
}

// ── Theme tone → preview palette ─────────────────────────

const kToneColors = <String, Color>{
  'amber': Color(0xFFF59E0B),
  'teal': Color(0xFF14B8A6),
  'slate': Color(0xFF64748B),
  'rose': Color(0xFFF43F5E),
  'sky': Color(0xFF0EA5E9),
};

Color resolveToneColor(String tone) =>
    kToneColors[tone] ?? kToneColors['teal']!;
