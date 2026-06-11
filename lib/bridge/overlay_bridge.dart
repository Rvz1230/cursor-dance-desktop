import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum BridgeResult { success, error }

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
    }
  }

  Future<BridgeResult> start(Map<String, dynamic> config) async {
    try {
      await _channel.invokeMethod('startOverlay', {
        'config': jsonEncode(config),
      });
      return BridgeResult.success;
    } on PlatformException catch (e) {
      debugPrint('OverlayBridge.start error: ${e.message}');
      return BridgeResult.error;
    } catch (e) {
      debugPrint('OverlayBridge.start error: $e');
      return BridgeResult.error;
    }
  }

  Future<BridgeResult> stop() async {
    try {
      await _channel.invokeMethod('stopOverlay');
      return BridgeResult.success;
    } on PlatformException catch (e) {
      debugPrint('OverlayBridge.stop error: ${e.message}');
      return BridgeResult.error;
    } catch (e) {
      debugPrint('OverlayBridge.stop error: $e');
      return BridgeResult.error;
    }
  }

  Future<BridgeResult> updateConfig(Map<String, dynamic> config) async {
    try {
      await _channel.invokeMethod('updateConfig', {
        'config': jsonEncode(config),
      });
      return BridgeResult.success;
    } on PlatformException catch (e) {
      debugPrint('OverlayBridge.updateConfig error: ${e.message}');
      return BridgeResult.error;
    } catch (e) {
      debugPrint('OverlayBridge.updateConfig error: $e');
      return BridgeResult.error;
    }
  }

  Future<BridgeResult> updateKeyFeedbackConfig(
    Map<String, dynamic> config,
  ) async {
    try {
      await _channel.invokeMethod('updateKeyFeedbackConfig', {
        'config': jsonEncode(config),
      });
      return BridgeResult.success;
    } on PlatformException catch (e) {
      debugPrint('OverlayBridge.updateKeyFeedbackConfig error: ${e.message}');
      return BridgeResult.error;
    } catch (e) {
      debugPrint('OverlayBridge.updateKeyFeedbackConfig error: $e');
      return BridgeResult.error;
    }
  }

  void dispose() {
    _channel.setMethodCallHandler(null);
    onOverlayStateChanged = null;
  }
}
