import 'dart:ui';

class ParticleConfig {
  final Color color;
  final double size;
  final double speed;

  const ParticleConfig({
    required this.color,
    required this.size,
    required this.speed,
  });

  static const presets = [
    Color(0xFFFF4444), // 红
    Color(0xFFFF8C00), // 橙
    Color(0xFF4488FF), // 蓝
  ];
}
