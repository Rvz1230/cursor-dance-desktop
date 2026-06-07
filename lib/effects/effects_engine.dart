import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../models/action_config.dart';

// ═══════════════════════════════════════════════════════════════
// Easing — mirrors Swift's timingFunction(from:)
// ═══════════════════════════════════════════════════════════════

double _cubicBezierY(double t, double cp1x, double cp1y, double cp2x, double cp2y) {
  final mt = 1.0 - t;
  return 3.0 * mt * mt * t * cp1y + 3.0 * mt * t * t * cp2y + t * t * t;
}

/// Solve cubic bezier for x(t) = inputX using Newton-Raphson,
/// then return y(t). Mirrors CAMediaTimingFunction evaluation.
double _solveBezier(double x, double cp1x, double cp1y, double cp2x, double cp2y) {
  double t = x;
  for (int i = 0; i < 10; i++) {
    final mt = 1.0 - t;
    final xSamp = 3.0 * mt * mt * t * cp1x + 3.0 * mt * t * t * cp2x + t * t * t;
    final dx = 3.0 * mt * mt * cp1x + 6.0 * mt * t * (cp2x - cp1x) + 3.0 * t * t * (1.0 - cp2x);
    if (dx.abs() < 1e-10) break;
    t -= (xSamp - x) / dx;
    t = t.clamp(0.0, 1.0);
  }
  return _cubicBezierY(t, cp1x, cp1y, cp2x, cp2y);
}

double ease(String name, double t) {
  switch (name) {
    case '线性':
      return t;
    case '缓入':
      return t * t;
    case '缓出':
      return 1.0 - (1.0 - t) * (1.0 - t);
    case '缓入缓出':
      return t < 0.5 ? 2.0 * t * t : 1.0 - (-2.0 * t + 2.0) * (-2.0 * t + 2.0) / 2.0;
    case '弹跳':
      return _solveBezier(t, 0.34, 1.56, 0.64, 1.0);
    case '弹性':
      return _solveBezier(t, 0.22, 1.0, 0.36, 1.18);
    default:
      return 1.0 - (1.0 - t) * (1.0 - t); // easeOut
  }
}

// ═══════════════════════════════════════════════════════════════
// Particle styles
// ═══════════════════════════════════════════════════════════════

enum ParticleShape { circle, square, diamond, spark }

ParticleShape shapeFromString(String style) {
  switch (style) {
    case '方块':
      return ParticleShape.square;
    case '钻石':
      return ParticleShape.diamond;
    case '火花':
      return ParticleShape.spark;
    default:
      return ParticleShape.circle;
  }
}

// ═══════════════════════════════════════════════════════════════
// Effect data classes
// ═══════════════════════════════════════════════════════════════

class PreviewParticle {
  // Computed each frame
  double x, y, opacity;
  // Fixed interpolation params (matching Swift CAAnimation model)
  final double startX, startY;
  final double deltaX, deltaY;
  final double size;
  final double startOpacity;
  final double duration; // seconds
  final String easing;
  final Color color;
  final ParticleShape shape;
  double elapsed;

  PreviewParticle({
    required this.x,
    required this.y,
    required this.startX,
    required this.startY,
    required this.deltaX,
    required this.deltaY,
    required this.size,
    required this.startOpacity,
    required this.duration,
    required this.color,
    required this.shape,
    this.easing = '缓出',
    this.elapsed = 0.0,
    this.opacity = 1.0,
  });
}

class PreviewText {
  // Computed each frame
  double x, y, opacity;
  // Fixed interpolation params
  final double startY;
  final double totalOffsetY; // positive = float-up distance
  final double duration;
  final String easing;
  final String content;
  final Color color;
  final double fontSize;
  final double startOpacity;
  double elapsed;

  PreviewText({
    required this.x,
    required this.y,
    required this.startY,
    required this.totalOffsetY,
    required this.duration,
    required this.content,
    required this.color,
    required this.fontSize,
    required this.startOpacity,
    this.easing = '缓出',
    this.elapsed = 0.0,
    this.opacity = 1.0,
  });
}

class PreviewRipple {
  // Computed each frame
  double progress; // 0→1, linear
  // Fixed params
  final double x, y;
  final double maxSize;
  final double opacityPeak;
  final double lineWidth;
  final double delay; // stagger offset
  final double duration;
  final String easing;
  final Color color;
  final bool filled;
  double elapsed;

  PreviewRipple({
    required this.x,
    required this.y,
    required this.maxSize,
    required this.opacityPeak,
    required this.lineWidth,
    required this.delay,
    required this.duration,
    required this.color,
    this.easing = '缓出',
    this.filled = false,
    this.elapsed = 0.0,
    this.progress = 0.0,
  });
}

// ═══════════════════════════════════════════════════════════════
// EffectsEngine
// ═══════════════════════════════════════════════════════════════

class EffectsEngine {
  final List<PreviewParticle> _particles = [];
  final List<PreviewText> _texts = [];
  final List<PreviewRipple> _ripples = [];
  final Random _random = Random();

  List<PreviewParticle> get particles => _particles;
  List<PreviewText> get texts => _texts;
  List<PreviewRipple> get ripples => _ripples;

  bool get isAlive => _particles.isNotEmpty || _texts.isNotEmpty || _ripples.isNotEmpty;

  void trigger(double x, double y, ActionConfig config) {
    if (config.particle) _spawnParticles(x, y, config);
    if (config.textEnabled) _spawnText(x, y, config);
    if (config.ripple) _spawnRipples(x, y, config);
  }

  void _spawnParticles(double x, double y, ActionConfig config) {
    final count = min(config.particleCount, 60);
    final shape = shapeFromString(config.particleStyle);
    // Swift uses palette.first for all particles
    final baseColor = config.particlePalette.isNotEmpty
        ? config.particlePalette.first
        : '#F59E0B';
    final spread = config.particleSpread.toDouble();
    final gravity = config.particleGravity.toDouble();
    final wind = config.particleWind.toDouble();
    final size = config.particleSize.toDouble();
    final startOpacity = config.particleOpacity / 100.0;
    final duration = config.particleDuration / 1000.0;

    for (int i = 0; i < count; i++) {
      final angle = _angleForDirection(i, count, config.particleDirection);
      // Match Swift: random dist * spread, then endpoint = angle vector + wind/gravity adjust
      final dist = (0.4 + _random.nextDouble() * 0.6) * spread;
      final deltaX = cos(angle) * dist + wind * dist * 0.02;
      final deltaY = sin(angle) * dist + gravity * dist * 0.03;
      final pSize = size * (0.5 + _random.nextDouble() * 0.5);

      _particles.add(PreviewParticle(
        x: x,
        y: y,
        startX: x,
        startY: y,
        deltaX: deltaX,
        deltaY: deltaY,
        size: pSize.clamp(2.0, 32.0),
        startOpacity: startOpacity,
        duration: duration,
        color: _parseHex(baseColor),
        shape: shape,
        opacity: startOpacity,
      ));
    }
  }

  void _spawnText(double x, double y, ActionConfig config) {
    final content = config.textContent.isNotEmpty ? config.textContent : '✦';
    final fontSize = config.fontSize.toDouble();
    final color = _parseHex(config.textColor);
    final offsetY = config.textOffsetY.toDouble().abs();
    final startOpacity = config.textOpacity / 100.0;
    final duration = config.textDuration / 1000.0;

    _texts.add(PreviewText(
      x: x,
      y: y,
      startY: y,
      totalOffsetY: offsetY,
      content: content,
      color: color,
      fontSize: fontSize,
      duration: duration,
      startOpacity: startOpacity,
      easing: config.textEasing,
      opacity: startOpacity,
    ));
  }

  void _spawnRipples(double x, double y, ActionConfig config) {
    final style = config.rippleStyle;
    final size = config.rippleSize.toDouble();
    final opacity = config.rippleOpacity / 100.0;
    final color = _parseHex(config.rippleColor);
    final lineWidth = config.rippleLineWidth.toDouble();
    final duration = config.rippleDuration / 1000.0;

    final layers = _rippleLayers(style, size, opacity, lineWidth, color);
    for (final layer in layers) {
      _ripples.add(PreviewRipple(
        x: x,
        y: y,
        maxSize: layer.size,
        opacityPeak: layer.opacity,
        lineWidth: layer.lineWidth,
        color: color,
        filled: layer.filled,
        easing: config.rippleEasing,
        delay: layer.delay,
        duration: duration,
      ));
    }
  }

  void update(double dt) {
    // Particles — endpoint interpolation with easeOut
    for (final p in _particles) {
      p.elapsed += dt;
      final t = (p.elapsed / p.duration).clamp(0.0, 1.0);
      final eased = ease(p.easing, t);
      p.x = p.startX + p.deltaX * eased;
      p.y = p.startY + p.deltaY * eased;
      p.opacity = p.startOpacity * (1.0 - t); // linear fade
    }
    _particles.removeWhere((p) => p.elapsed >= p.duration);

    // Texts — eased float-up + linear fade
    for (final t in _texts) {
      t.elapsed += dt;
      final progress = (t.elapsed / t.duration).clamp(0.0, 1.0);
      final eased = ease(t.easing, progress);
      t.y = t.startY - t.totalOffsetY * eased;
      t.opacity = t.startOpacity * (1.0 - progress);
    }
    _texts.removeWhere((t) => t.elapsed >= t.duration);

    // Ripples — eased scale + linear fade, with stagger delay
    for (final r in _ripples) {
      r.elapsed += dt;
      final activeTime = r.elapsed - r.delay;
      if (activeTime <= 0) continue;
      r.progress = (activeTime / r.duration).clamp(0.0, 1.0);
    }
    _ripples.removeWhere((r) => r.elapsed >= r.duration + r.delay);
  }

  void clear() {
    _particles.clear();
    _texts.clear();
    _ripples.clear();
  }

  // ═════════════════════════════════════════════════════
  // Helpers
  // ═════════════════════════════════════════════════════

  double _angleForDirection(int index, int count, String direction) {
    switch (direction) {
      case '向上喷发':
        // Match Swift: random(in: -.pi * 0.9 ... .pi * 0.9)
        return _random.nextDouble() * pi * 1.8 - pi * 0.9;
      case '旋转扫射':
        // Match Swift: step * i + random(-0.15...0.15)
        final step = (2 * pi) / count;
        return step * index + (_random.nextDouble() - 0.5) * 0.3;
      case '随机散射':
        return _random.nextDouble() * 2 * pi;
      default: // 四周扩散
        return _random.nextDouble() * 2 * pi;
    }
  }

  Color _parseHex(String hex) {
    final h = hex.replaceFirst('#', '');
    final v = int.parse('FF$h', radix: 16);
    return Color(v);
  }

  List<({double size, double opacity, double lineWidth, bool filled, double delay})>
      _rippleLayers(String style, double size, double opacity, double lineWidth, Color color) {
    const stagger = 0.08; // Match Swift stagger

    List<(double sz, double op, double lw, bool fl)> raw;
    switch (style) {
      case '双环':
        raw = [
          (size, opacity, lineWidth, false),
          (size * 1.12, opacity * 0.82, lineWidth * 0.8, false),
        ];
      case '柔和面波':
        raw = [(size, opacity, lineWidth, true)];
      case '脉冲波纹':
        raw = [
          (size, opacity, lineWidth, true),
          (size * 1.24, opacity * 0.52, lineWidth, false),
          (size * 1.4, opacity * 0.26, lineWidth * 0.6, false),
        ];
      case '回声环':
        raw = [
          (size, opacity, lineWidth, false),
          (size * 1.1, opacity * 0.68, lineWidth * 0.9, false),
          (size * 1.22, opacity * 0.44, lineWidth * 0.8, false),
          (size * 1.36, opacity * 0.22, lineWidth * 0.6, false),
        ];
      case '能量脉冲':
        raw = [
          (size, opacity * 1.1, lineWidth, true),
          (size * 1.16, opacity * 0.58, lineWidth, false),
        ];
      default: // 单环
        raw = [(size, opacity, lineWidth, false)];
    }

    return [
      for (int i = 0; i < raw.length; i++)
        (
          size: raw[i].$1,
          opacity: raw[i].$2,
          lineWidth: raw[i].$3,
          filled: raw[i].$4,
          delay: i * stagger,
        ),
    ];
  }
}

// ═══════════════════════════════════════════════════════════════
// EffectsPainter — renders all effects on one Canvas
// ═══════════════════════════════════════════════════════════════

class EffectsPainter extends CustomPainter {
  final EffectsEngine engine;

  EffectsPainter(this.engine);

  @override
  void paint(Canvas canvas, Size size) {
    _drawRipples(canvas);
    _drawParticles(canvas);
    _drawTexts(canvas);
  }

  void _drawParticles(Canvas canvas) {
    for (final p in engine.particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      switch (p.shape) {
        case ParticleShape.square:
          canvas.drawRect(
              Rect.fromCenter(center: Offset(p.x, p.y), width: p.size, height: p.size), paint);
        case ParticleShape.diamond:
          final path = Path()
            ..moveTo(p.x, p.y - p.size / 2)
            ..lineTo(p.x + p.size / 2, p.y)
            ..lineTo(p.x, p.y + p.size / 2)
            ..lineTo(p.x - p.size / 2, p.y)
            ..close();
          canvas.drawPath(path, paint);
        case ParticleShape.spark:
          final path = Path()
            ..moveTo(p.x, p.y - p.size / 2)
            ..lineTo(p.x + p.size / 3, p.y + p.size / 3)
            ..lineTo(p.x - p.size / 3, p.y + p.size / 3)
            ..close();
          canvas.drawPath(path, paint);
        case ParticleShape.circle:
          canvas.drawCircle(Offset(p.x, p.y), p.size / 2, paint);
      }
    }
  }

  void _drawTexts(Canvas canvas) {
    for (final t in engine.texts) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: t.content,
          style: TextStyle(
            color: t.color.withValues(alpha: t.opacity.clamp(0.0, 1.0)),
            fontSize: t.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(t.x - textPainter.width / 2, t.y - textPainter.height / 2),
      );
    }
  }

  void _drawRipples(Canvas canvas) {
    for (final r in engine.ripples) {
      final progress = r.progress.clamp(0.0, 1.0);
      // Scale uses easing (matching Swift's scaleAnim timingFunction)
      final easedScale = ease(r.easing, progress);
      final currentSize = r.maxSize * lerpDouble(0.18, 1.0, easedScale)!;
      // Opacity fades linearly (matching Swift's opacity animation — no timing function)
      final alpha = (1.0 - progress) * r.opacityPeak;
      final paint = Paint()
        ..color = r.color.withValues(alpha: alpha.clamp(0.0, 1.0))
        ..style = r.filled ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = r.lineWidth;
      canvas.drawCircle(Offset(r.x, r.y), currentSize / 2, paint);
    }
  }

  @override
  bool shouldRepaint(EffectsPainter oldDelegate) => true;
}
