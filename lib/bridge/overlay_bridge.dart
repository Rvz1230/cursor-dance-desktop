import 'package:flutter/services.dart';

import '../models/particle_config.dart';

class OverlayBridge {
  static const _channel = MethodChannel('cursor_dance/overlay');

  Future<void> start(ParticleConfig config) async {
    await _channel.invokeMethod('startOverlay', {
      'color': config.color.toARGB32(),
      'size': config.size,
      'speed': config.speed,
    });
  }

  Future<void> stop() async {
    await _channel.invokeMethod('stopOverlay');
  }

  Future<void> updateConfig(ParticleConfig config) async {
    await _channel.invokeMethod('updateConfig', {
      'color': config.color.toARGB32(),
      'size': config.size,
      'speed': config.speed,
    });
  }
}
