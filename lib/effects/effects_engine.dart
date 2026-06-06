import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../models/action_config.dart';

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
  double x, y;
  final double vx;
  double vy;
  final double size;
  double opacity;
  final Color color;
  final ParticleShape shape;

  PreviewParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.shape,
    this.opacity = 1.0,
  });
}

class PreviewText {
  double x, y;
  final String content;
  double opacity;
  final Color color;
  final double fontSize;
  double vy = 0; // vertical drift per frame

  PreviewText({
    required this.x,
    required this.y,
    required this.content,
    required this.color,
    required this.fontSize,
    this.opacity = 1.0,
    this.vy = 0,
  });
}

class PreviewRipple {
  double progress; // 0.0 → 1.0
  final double x, y;
  final double maxSize;
  final double opacityPeak;
  final double lineWidth;
  final Color color;
  final bool filled;

  PreviewRipple({
    required this.x,
    required this.y,
    required this.maxSize,
    required this.opacityPeak,
    required this.lineWidth,
    required this.color,
    this.filled = false,
    this.progress = 0.0,
  });
}

// ═══════════════════════════════════════════════════════════════
// EffectsEngine — manages all preview effects
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
    final count = min(config.particleCount, 40);
    final baseSpeed = config.particleSpread * 3.0;
    final shape = shapeFromString(config.particleStyle);
    final palette = config.particlePalette;
    final colorMode = config.particleColorMode;
    final gravity = config.particleGravity * 0.3;
    final wind = config.particleWind * 0.3;
    final size = config.particleSize.toDouble();
    final opacity = config.particleOpacity / 100.0;

    for (int i = 0; i < count; i++) {
      final angle = _angleForDirection(i, count, config.particleDirection);
      final speed = baseSpeed * (0.3 + _random.nextDouble() * 0.7);
      final pSize = size * (0.5 + _random.nextDouble() * 0.5);

      Color pColor;
      if (colorMode == '随机轻变化') {
        pColor = _randomizedColor(palette.isNotEmpty ? palette.first : '#F59E0B');
      } else {
        pColor = _parseHex(palette.isNotEmpty ? palette[i % palette.length] : '#F59E0B');
      }

      _particles.add(PreviewParticle(
        x: x,
        y: y,
        vx: cos(angle) * speed + wind * _random.nextDouble(),
        vy: sin(angle) * speed + gravity,
        size: pSize.clamp(2.0, 32.0),
        color: pColor,
        shape: shape,
        opacity: opacity,
      ));
    }
  }

  void _spawnText(double x, double y, ActionConfig config) {
    final content = config.textContent.isNotEmpty ? config.textContent : '✦';
    final fontSize = config.fontSize.toDouble();
    final color = _parseHex(config.textColor);
    final offsetY = config.textOffsetY.toDouble().abs(); // drift distance

    _texts.add(PreviewText(
      x: x,
      y: y,
      content: content,
      color: color,
      fontSize: fontSize,
      opacity: config.textOpacity / 100.0,
    ));

    final duration = config.textDuration / 1000.0;
    // Store drift in vy as speed per frame
    _texts.last.vy = offsetY / (duration * 60);
  }

  void _spawnRipples(double x, double y, ActionConfig config) {
    final style = config.rippleStyle;
    final size = config.rippleSize.toDouble();
    final opacity = config.rippleOpacity / 100.0;
    final color = _parseHex(config.rippleColor);
    final lineWidth = config.rippleLineWidth.toDouble();

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
      ));
    }
  }

  void update(double dt) {
    // Update particles
    for (final p in _particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      // Gravity accumulates
      p.vy += p.vy.sign * 0.5; // slow deceleration
    }
    // Fade particles
    final particleDuration = 0.8; // seconds to fully fade
    _updateFade(_particles, dt / particleDuration);

    // Update text: float up
    for (final t in _texts) {
      t.y -= t.vy;
    }
    final textDuration = 1.0;
    _updateFade(_texts, dt / textDuration);

    // Update ripples
    for (final r in _ripples) {
      r.progress += dt * 1.2;
    }
    final rippleDuration = 1.0;
    _updateFade(_ripples, dt / rippleDuration);
  }

  void _updateFade(List<dynamic> items, double fadeStep) {
    for (int i = items.length - 1; i >= 0; i--) {
      final item = items[i];
      if (item is PreviewParticle) {
        item.opacity -= fadeStep;
        if (item.opacity <= 0) items.removeAt(i);
      } else if (item is PreviewText) {
        item.opacity -= fadeStep * 0.8;
        if (item.opacity <= 0) items.removeAt(i);
      } else if (item is PreviewRipple) {
        // Remove when progress exceeds 1
        if (item.progress >= 1.0) items.removeAt(i);
      }
    }
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
        return pi + _random.nextDouble() * pi - pi / 2;
      case '旋转扫射':
        return (2 * pi / count) * index + _random.nextDouble() * 0.3;
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

  Color _randomizedColor(String hex) {
    final base = _parseHex(hex);
    final offset = (_random.nextDouble() - 0.5) * 0.3;
    return Color.from(
      alpha: 1.0,
      red: (base.r + offset).clamp(0.0, 1.0),
      green: (base.g + offset).clamp(0.0, 1.0),
      blue: (base.b + offset).clamp(0.0, 1.0),
    );
  }

  List<({double size, double opacity, double lineWidth, bool filled})> _rippleLayers(
    String style, double size, double opacity, double lineWidth, Color color,
  ) {
    switch (style) {
      case '双环':
        return [
          (size: size, opacity: opacity, lineWidth: lineWidth, filled: false),
          (size: size * 1.12, opacity: opacity * 0.82, lineWidth: lineWidth * 0.8, filled: false),
        ];
      case '柔和面波':
        return [(size: size, opacity: opacity, lineWidth: lineWidth, filled: true)];
      case '脉冲波纹':
        return [
          (size: size, opacity: opacity, lineWidth: lineWidth, filled: true),
          (size: size * 1.24, opacity: opacity * 0.52, lineWidth: lineWidth, filled: false),
          (size: size * 1.4, opacity: opacity * 0.26, lineWidth: lineWidth * 0.6, filled: false),
        ];
      case '回声环':
        return [
          (size: size, opacity: opacity, lineWidth: lineWidth, filled: false),
          (size: size * 1.1, opacity: opacity * 0.68, lineWidth: lineWidth * 0.9, filled: false),
          (size: size * 1.22, opacity: opacity * 0.44, lineWidth: lineWidth * 0.8, filled: false),
          (size: size * 1.36, opacity: opacity * 0.22, lineWidth: lineWidth * 0.6, filled: false),
        ];
      case '能量脉冲':
        return [
          (size: size, opacity: opacity * 1.1, lineWidth: lineWidth, filled: true),
          (size: size * 1.16, opacity: opacity * 0.58, lineWidth: lineWidth, filled: false),
        ];
      default: // 单环
        return [(size: size, opacity: opacity, lineWidth: lineWidth, filled: false)];
    }
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
          canvas.drawRect(Rect.fromCenter(center: Offset(p.x, p.y), width: p.size, height: p.size), paint);
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
      final currentSize = r.maxSize * lerpDouble(0.18, 1.0, progress)!;
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
