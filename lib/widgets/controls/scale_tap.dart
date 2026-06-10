import 'package:flutter/material.dart';

import '../../theme/animations.dart';

/// 缩放点击反馈 — 插件版 active:scale-[0.97]
class ScaleTap extends StatefulWidget {
  final Widget child;
  final double scaleAmount;
  final Duration duration;

  const ScaleTap({
    super.key,
    required this.child,
    this.scaleAmount = 0.97,
    this.duration = AppAnimations.fast,
  });

  @override
  State<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<ScaleTap> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? widget.scaleAmount : 1.0,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}
