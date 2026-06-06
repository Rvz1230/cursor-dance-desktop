import 'dart:convert';

import 'package:flutter/services.dart';

class OverlayBridge {
  static const _channel = MethodChannel('cursor_dance/overlay');

  Future<void> start(Map<String, dynamic> config) async {
    await _channel.invokeMethod('startOverlay', {
      'config': jsonEncode(config),
    });
  }

  Future<void> stop() async {
    await _channel.invokeMethod('stopOverlay');
  }

  Future<void> updateConfig(Map<String, dynamic> config) async {
    await _channel.invokeMethod('updateConfig', {
      'config': jsonEncode(config),
    });
  }
}
