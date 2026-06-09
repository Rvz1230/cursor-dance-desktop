import 'package:flutter/material.dart';

/// 缩放点击反馈 — 插件版 active:scale-[0.97]
///
/// 使用 [Listener] 观察指针事件，不参与手势竞争。
/// 按下缩放到 [scaleAmount]，抬起/取消恢复。
class ScaleTap extends StatefulWidget {
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
