import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../bridge/overlay_bridge.dart';
import 'config_provider.dart';
import 'theme_provider.dart';

/// 覆盖层启用/同步状态管理 Provider
class OverlayProvider extends ChangeNotifier {
  final OverlayBridge _bridge;
  final ThemeProvider _themeProvider;
  final ConfigProvider _configProvider;
  String _lastConfigJson = '';
  String _lastKeyConfigJson = '';

  bool _enabled = true;
  bool get enabled => _enabled;

  OverlayProvider({
    required this._themeProvider,
    required this._configProvider,
    OverlayBridge? bridge,
  }) : _bridge = bridge ?? OverlayBridge();

  void setOverlayStateChangedHandler(void Function(bool enabled) handler) {
    _bridge.onOverlayStateChanged = handler;
  }

  Future<void> start() async {
    final config = _configProvider.currentActionConfig;
    final payload = _themeProvider.buildOverlayPayload(
      _configProvider.selectedActionId,
      config,
    );
    _lastConfigJson = jsonEncode(config.toJson());
    _lastKeyConfigJson = jsonEncode(_themeProvider.keyFeedbackConfig.toJson());
    await _bridge.start(payload);
    await _bridge.updateKeyFeedbackConfig(
      _themeProvider.keyFeedbackConfig.toJson(),
    );
  }

  Future<void> stop() => _bridge.stop();

  Future<void> sync() async {
    if (!_enabled) return;

    final config = _configProvider.currentActionConfig;
    final newConfigJson = jsonEncode(config.toJson());
    if (newConfigJson != _lastConfigJson) {
      _lastConfigJson = newConfigJson;
      await _bridge.updateConfig(_themeProvider.buildOverlayPayload(
        _configProvider.selectedActionId,
        config,
      ));
    }

    final newKeyJson = jsonEncode(_themeProvider.keyFeedbackConfig.toJson());
    if (newKeyJson != _lastKeyConfigJson) {
      _lastKeyConfigJson = newKeyJson;
      await _bridge.updateKeyFeedbackConfig(
        _themeProvider.keyFeedbackConfig.toJson(),
      );
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

  void setEnabled(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _bridge.stop();
    _bridge.dispose();
    super.dispose();
  }
}
