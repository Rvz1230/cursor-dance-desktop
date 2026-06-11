import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/action_config.dart';
import '../models/theme_draft.dart';

/// Loads and caches factory presets and theme overrides from JSON assets.
///
/// Must be loaded before ThemeProvider is created — call
/// `await PresetRepository.instance.load()` before `runApp()`.
class PresetRepository {
  PresetRepository._();

  static final PresetRepository instance = PresetRepository._();

  Map<String, Map<String, dynamic>> _factoryPresets = {};
  Map<String, Map<String, Map<String, dynamic>>> _themeOverrides = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    final factoryRaw =
        await rootBundle.loadString('assets/presets/factory_presets.json');
    final overrideRaw =
        await rootBundle.loadString('assets/presets/theme_overrides.json');
    loadFromStrings(factoryRaw, overrideRaw);
  }

  void loadFromStrings(String factoryJson, String overrideJson) {
    if (_loaded) return;
    _factoryPresets = Map<String, Map<String, dynamic>>.from(
      jsonDecode(factoryJson) as Map,
    );
    _themeOverrides = Map.fromEntries(
      (jsonDecode(overrideJson) as Map<String, dynamic>).entries.map(
        (e) => MapEntry(
          e.key,
          Map<String, Map<String, dynamic>>.from(
            (e.value as Map).map((k, v) =>
                MapEntry(k as String, Map<String, dynamic>.from(v as Map))),
          ),
        ),
      ),
    );
    _loaded = true;
  }

  ActionConfig presetForAction(String actionId) {
    final data = _factoryPresets[actionId];
    if (data == null) return const ActionConfig();
    return ActionConfig.fromJson(data);
  }

  ActionConfig applyThemeOverrides(
    ActionConfig base,
    String themeId,
    String actionId,
  ) {
    final overrides = _themeOverrides[themeId]?[actionId];
    if (overrides == null || overrides.isEmpty) return base;
    return ActionConfig.fromJson({...base.toJson(), ...overrides});
  }

  Map<String, ActionConfig> defaultActionConfigs(String themeId) {
    return {
      for (final actionId in kActionIds)
        actionId: applyThemeOverrides(
          presetForAction(actionId),
          themeId,
          actionId,
        ),
    };
  }

  /// Reset internal state for testing.
  @visibleForTesting
  void reset() {
    _factoryPresets = {};
    _themeOverrides = {};
    _loaded = false;
  }
}
