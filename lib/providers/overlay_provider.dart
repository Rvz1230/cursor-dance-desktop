import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../bridge/overlay_bridge.dart';
import 'config_provider.dart';
import 'theme_provider.dart';

class OverlayProvider extends ChangeNotifier {
  final OverlayBridge _bridge;
  final ThemeProvider _themeProvider;
  final ConfigProvider _configProvider;
  String _lastActionsJson = '';
  String _lastKeyConfigJson = '';

  bool _enabled = true;
  bool get enabled => _enabled;

  OverlayProvider({
    required this._themeProvider,
    required this._configProvider,
    OverlayBridge? bridge,
  }) : _bridge = bridge ?? OverlayBridge() {
    _themeProvider.addListener(_onDependencyChanged);
    _configProvider.addListener(_onDependencyChanged);
  }

  @override
  void dispose() {
    _themeProvider.removeListener(_onDependencyChanged);
    _configProvider.removeListener(_onDependencyChanged);
    _bridge.stop();
    _bridge.dispose();
    super.dispose();
  }

  void setOverlayStateChangedHandler(void Function(bool enabled) handler) {
    _bridge.onOverlayStateChanged = handler;
  }

  Future<void> start() async {
    final payload = _themeProvider.buildFullOverlayPayload();
    _lastActionsJson = jsonEncode(payload);
    _lastKeyConfigJson = jsonEncode(_themeProvider.keyFeedbackConfig.toJson());
    await _bridge.start(payload);
    await _bridge.updateKeyFeedbackConfig(
      _themeProvider.keyFeedbackConfig.toJson(),
    );
  }

  Future<void> stop() => _bridge.stop();

  Future<void> sync() async {
    if (!_enabled) return;

    final payload = _themeProvider.buildFullOverlayPayload();
    final newActionsJson = jsonEncode(payload);
    if (newActionsJson != _lastActionsJson) {
      _lastActionsJson = newActionsJson;
      final result = await _bridge.updateAllConfigs(payload);
      if (result == BridgeResult.error) {
        debugPrint('OverlayProvider.sync: updateAllConfigs failed');
      }
    }

    final newKeyJson = jsonEncode(_themeProvider.keyFeedbackConfig.toJson());
    if (newKeyJson != _lastKeyConfigJson) {
      _lastKeyConfigJson = newKeyJson;
      final result = await _bridge.updateKeyFeedbackConfig(
        _themeProvider.keyFeedbackConfig.toJson(),
      );
      if (result == BridgeResult.error) {
        debugPrint('OverlayProvider.sync: updateKeyFeedbackConfig failed');
      }
    }
  }

  void syncIfNeeded() {
    if (!_enabled) return;
    unawaited(_syncSafe());
  }

  Future<void> _syncSafe() async {
    try {
      await sync();
    } catch (e) {
      debugPrint('OverlayProvider.sync 失败: $e');
    }
  }

  void _onDependencyChanged() => syncIfNeeded();

  void setEnabled(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    notifyListeners();
  }
}
