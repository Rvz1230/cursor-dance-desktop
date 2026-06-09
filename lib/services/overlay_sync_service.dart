import 'dart:async';

import 'package:flutter/foundation.dart';

import '../bridge/overlay_bridge.dart';
import '../state/workbench_state.dart';

class OverlaySyncService {
  final OverlayBridge _bridge;
  String _lastConfigJson = '';
  String _lastKeyConfigJson = '';

  OverlaySyncService({OverlayBridge? bridge}) : _bridge = bridge ?? OverlayBridge();

  OverlayBridge get bridge => _bridge;

  void setOverlayStateChangedHandler(void Function(bool enabled) handler) {
    _bridge.onOverlayStateChanged = handler;
  }

  Future<void> start(WorkbenchState state) async {
    final payload = state.buildOverlayPayload();
    _lastConfigJson = state.currentActionConfigJson;
    _lastKeyConfigJson = state.keyFeedbackConfigJson;
    await _bridge.start(payload);
    await _bridge.updateKeyFeedbackConfig(state.keyFeedbackConfig.toJson());
  }

  Future<void> stop() => _bridge.stop();

  Future<void> sync(WorkbenchState state) async {
    if (!state.enabled) return;

    final newConfigJson = state.currentActionConfigJson;
    if (newConfigJson != _lastConfigJson) {
      _lastConfigJson = newConfigJson;
      await _bridge.updateConfig(state.buildOverlayPayload());
    }

    final newKeyJson = state.keyFeedbackConfigJson;
    if (newKeyJson != _lastKeyConfigJson) {
      _lastKeyConfigJson = newKeyJson;
      await _bridge.updateKeyFeedbackConfig(state.keyFeedbackConfig.toJson());
    }
  }

  void syncIfNeeded(WorkbenchState state) {
    if (!state.enabled) return;
    unawaited(_syncSafe(state));
  }

  Future<void> _syncSafe(WorkbenchState state) async {
    try {
      await sync(state);
    } catch (e) {
      debugPrint('OverlaySyncService.sync 失败: $e');
    }
  }

  void dispose() {
    _bridge.stop();
    _bridge.dispose();
  }
}
