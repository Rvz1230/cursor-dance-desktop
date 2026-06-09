import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 缩放点击反馈 — 插件版 active:scale-[0.97]
class ScaleTap extends HookWidget {
  final Widget child;
  final double scaleAmount;
  final Duration duration;

  const ScaleTap({
    super.key,
    required this.child,
    this.scaleAmount = 0.97,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  Widget build(BuildContext context) {
    final pressed = useState(false);

    return Listener(
      onPointerDown: (_) => pressed.value = true,
      onPointerUp: (_) => pressed.value = false,
      onPointerCancel: (_) => pressed.value = false,
      child: AnimatedScale(
        scale: pressed.value ? scaleAmount : 1.0,
        duration: duration,
        child: child,
      ),
    );
  }
}
