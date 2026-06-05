import 'dart:math';

import 'package:flutter/material.dart';

import '../models/particle_config.dart';

class Particle {
  double x, y;
  final double vx, vy;
  final double size;
  double opacity;
  final Color baseColor;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.baseColor,
    this.opacity = 1.0,
  });
}

class ParticleBurst {
  final List<Particle> _particles = [];
  final Random _random = Random();

  List<Particle> get particles => _particles;
  bool get isAlive => _particles.isNotEmpty;

  void spawn(double x, double y, ParticleConfig config) {
    final count = 12 + _random.nextInt(9); // 12-20
    final baseSpeed = config.speed * 120;

    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = baseSpeed * (0.4 + _random.nextDouble() * 0.6);
      final size = config.size * (0.4 + _random.nextDouble() * 0.6);

      _particles.add(Particle(
        x: x,
        y: y,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        size: size.clamp(1.0, 20.0),
        baseColor: config.color,
      ));
    }
  }

  void update(double dt) {
    for (final p in _particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.opacity -= dt * 0.8; // fade over ~1.25s
    }
    _particles.removeWhere((p) => p.opacity <= 0);
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.baseColor.withValues(alpha: p.opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      final radius = p.size * 0.5;
      canvas.drawCircle(Offset(p.x, p.y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
