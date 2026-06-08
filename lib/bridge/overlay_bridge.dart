import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class OverlayBridge {
  static const _channel = MethodChannel('cursor_dance/overlay');
  ValueChanged<bool>? onOverlayStateChanged;

  OverlayBridge() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'overlayStateChanged':
        final args = call.arguments as Map<dynamic, dynamic>;
        final enabled = args['enabled'] as bool;
        onOverlayStateChanged?.call(enabled);
        break;
    }
  }

  Future<void> start(Map<String, dynamic> config) async {
    try {
      await _channel.invokeMethod('startOverlay', {
        'config': jsonEncode(config),
      });
    } catch (e) {
      debugPrint('OverlayBridge.start error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _channel.invokeMethod('stopOverlay');
    } catch (e) {
      debugPrint('OverlayBridge.stop error: $e');
    }
  }

  Future<void> updateConfig(Map<String, dynamic> config) async {
    try {
      await _channel.invokeMethod('updateConfig', {
        'config': jsonEncode(config),
      });
    } catch (e) {
      debugPrint('OverlayBridge.updateConfig error: $e');
    }
  }

  Future<void> updateKeyFeedbackConfig(Map<String, dynamic> config) async {
    try {
      await _channel.invokeMethod('updateKeyFeedbackConfig', {
        'config': jsonEncode(config),
      });
    } catch (e) {
      debugPrint('OverlayBridge.updateKeyFeedbackConfig error: $e');
    }
  }
}
