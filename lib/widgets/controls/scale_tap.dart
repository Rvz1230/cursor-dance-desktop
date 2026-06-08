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

class _ScaleTapState extends State<ScaleTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 1.0, end: widget.scaleAmount)
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _controller.forward(),
      onPointerUp: (_) => _controller.reverse(),
      onPointerCancel: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(scale: _animation.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
