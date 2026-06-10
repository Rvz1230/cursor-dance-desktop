/// CursorDance Design Tokens
///
/// 4px 基线网格体系，所有间距/尺寸必须是 4 的倍数。
/// 所有 Widget 中禁止硬编码间距/圆角值，必须引用此文件。
library;

import 'dart:ui';

class Spacing {
  Spacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Icon 尺寸层级
class IconSizes {
  IconSizes._();

  static const double xs = 10;
  static const double sm = 12;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// 圆角体系 — Soft-Minimal Linear 风格
class RadiusTokens {
  RadiusTokens._();

  static const double none = 0;
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 8;
  static const double xl = 12;
  static const double xl2 = 16;
}

/// 字体大小层级 — 匹配插件版 text-xs/sm/base
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

/// 颜色常量（仅用于 theme 定义，Widget 中应通过 Theme 访问）
///
/// Soft-Minimal Linear 浅色 slate 色系，匹配插件版 DESIGN.md。
/// 禁止装饰性渐变/紫色/glow。
class AppColors {
  AppColors._();

  // ── 基础色板 (slate 系) ──
  static const Color background = Color(0xFFF8F8FA); // 页面底色
  static const Color foreground = Color(0xFF0F172A); // slate-900
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF0F172A);
  static const Color popover = Color(0xFFFFFFFF);
  static const Color popoverForeground = Color(0xFF0F172A);
  static const Color muted = Color(0xFFF1F5F9); // slate-100
  static const Color mutedForeground = Color(0xFF64748B); // slate-500
  static const Color border = Color(0xFFE2E8F0); // slate-200
  static const Color input = Color(0xFFE2E8F0);

  // ── 主色 (slate-900) ──
  static const Color primary = Color(0xFF0F172A);
  static const Color primaryForeground = Color(0xFFFFFFFF);

  // ── 次级 ──
  static const Color secondary = Color(0xFFF1F5F9);
  static const Color secondaryForeground = Color(0xFF1E293B); // slate-800

  // ── 强调色 (非装饰，仅语义用途) ──
  static const Color accent = Color(0xFFF1F5F9);
  static const Color accentForeground = Color(0xFF1E293B);

  // ── 语义色 ──
  static const Color destructive = Color(0xFFE11D48); // rose-600
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF10B981); // emerald-500
  static const Color warning = Color(0xFFF59E0B); // amber-500

  // ── 功能色 ──
  static const Color selection = Color(0xFFDBEAFE);
  static const Color ring = Color(0xFF94A3B8);

  // ── 效果卡片图标色调 (浅色) ──
  static const Color toneTriggerBg = Color(0xFFD1FAE5); // emerald-100
  static const Color toneTriggerFg = Color(0xFF047857); // emerald-700
  static const Color toneTextBg = Color(0xFFFEF3C7); // amber-100
  static const Color toneTextFg = Color(0xFFB45309); // amber-700
  static const Color toneParticleBg = Color(0xFFE0F2FE); // sky-100
  static const Color toneParticleFg = Color(0xFF0369A1); // sky-700
  static const Color toneRippleBg = Color(0xFFCCFBF1); // teal-100
  static const Color toneRippleFg = Color(0xFF0D9488); // teal-700
  static const Color toneAudioBg = Color(0xFFFFE4E6); // rose-100
  static const Color toneAudioFg = Color(0xFFBE123C); // rose-700
  static const Color toneAnimationBg = Color(0xFFCFFAFE); // cyan-100
  static const Color toneAnimationFg = Color(0xFF0E7490); // cyan-700
  static const Color toneImageBg = Color(0xFFFAE8FF); // fuchsia-100
  static const Color toneImageFg = Color(0xFFA21CAF); // fuchsia-700
  static const Color toneCursorBg = Color(0xFFF1F5F9); // slate-100
  static const Color toneCursorFg = Color(0xFF334155); // slate-700
  static const Color toneKeyboardBg = Color(0xFFE0E7FF); // indigo-100
  static const Color toneKeyboardFg = Color(0xFF4F46E5); // indigo-700
}

/// 深色模式颜色常量
class AppDarkColors {
  AppDarkColors._();

  static const Color background = Color(0xFF0F172A); // slate-950
  static const Color foreground = Color(0xFFF1F5F9); // slate-100
  static const Color card = Color(0xFF1E293B);       // slate-900
  static const Color cardForeground = Color(0xFFF1F5F9);
  static const Color popover = Color(0xFF1E293B);
  static const Color popoverForeground = Color(0xFFF1F5F9);
  static const Color muted = Color(0xFF334155);       // slate-800
  static const Color mutedForeground = Color(0xFF94A3B8); // slate-400
  static const Color border = Color(0xFF334155);       // slate-800
  static const Color input = Color(0xFF475569);        // slate-700
  static const Color primary = Color(0xFFF1F5F9);
  static const Color primaryForeground = Color(0xFF1E293B);
  static const Color secondary = Color(0xFF334155);
  static const Color secondaryForeground = Color(0xFFE2E8F0);
  static const Color accent = Color(0xFF334155);
  static const Color accentForeground = Color(0xFFE2E8F0);
  static const Color destructive = Color(0xFFF43F5E);  // rose-500
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF34D399);       // emerald-400
  static const Color warning = Color(0xFFFBBF24);       // amber-400
  static const Color selection = Color(0xFF1E40AF);
  static const Color ring = Color(0xFF64748B);          // slate-500

  // ── 效果卡片图标色调 (深色) ──
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
  static const Color toneKeyboardBg = Color(0xFF312E81); // indigo-900
  static const Color toneKeyboardFg = Color(0xFFA5B4FC); // indigo-200
}

/// 主题色调 → 预览色板
const kToneColors = <String, Color>{
  'amber': Color(0xFFF59E0B),
  'teal': Color(0xFF14B8A6),
  'slate': Color(0xFF64748B),
  'rose': Color(0xFFF43F5E),
  'sky': Color(0xFF0EA5E9),
};

Color resolveToneColor(String tone) =>
    kToneColors[tone] ?? kToneColors['teal']!;
