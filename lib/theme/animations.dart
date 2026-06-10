/// CursorDance 动画设计令牌
///
/// 统一时长、缓动曲线和 shadcn_ui Animate effects，
/// 所有 Widget 中禁止出现 Duration(milliseconds: N) 硬编码。
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppAnimations {
  AppAnimations._();

  // ── 时长 ──
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration fastish = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 150);
  static const Duration slow = Duration(milliseconds: 200);
  static const Duration slower = Duration(milliseconds: 250);
  static const Duration theme = Duration(milliseconds: 400);

  // ── 缓动曲线 ──
  static const Curve defaultCurve = Curves.easeOut;
  static const Curve spring = Curves.easeOutBack;
  static const Curve smooth = Curves.easeInOut;

  // ── 常用过渡效果组合 ──
  static final List<AnimateEffect<dynamic>> slideIn = [
    FadeEffect(duration: normal, curve: defaultCurve),
    SlideEffect(
      begin: Offset(0, 0.05),
      end: Offset.zero,
      duration: normal,
      curve: defaultCurve,
    ),
  ];

  static final List<AnimateEffect<dynamic>> fadeIn = [
    FadeEffect(duration: normal, curve: defaultCurve),
  ];

  static final List<AnimateEffect<dynamic>> scaleIn = [
    FadeEffect(duration: fast, curve: defaultCurve),
    ScaleEffect(
      begin: Offset(0.97, 0.97),
      end: Offset(1.0, 1.0),
      duration: fast,
      curve: defaultCurve,
    ),
  ];

  static final List<AnimateEffect<dynamic>> slideOut = [
    FadeEffect(duration: fast, curve: Curves.easeIn),
    SlideEffect(
      begin: Offset.zero,
      end: Offset(0, -0.05),
      duration: fast,
      curve: Curves.easeIn,
    ),
  ];
}
