import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/action_config.dart';

/// Loads and caches factory presets and theme overrides from JSON assets.
///
/// Must be loaded before WorkbenchState is created — call
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

    _factoryPresets = Map<String, Map<String, dynamic>>.from(
      jsonDecode(factoryRaw) as Map,
    );
    _themeOverrides = Map.fromEntries(
      (jsonDecode(overrideRaw) as Map<String, dynamic>).entries.map(
        (e) => MapEntry(
          e.key,
          Map<String, Map<String, dynamic>>.from(
            (e.value as Map).map((k, v) => MapEntry(k as String, Map<String, dynamic>.from(v as Map))),
          ),
        ),
      ),
    );
    _loaded = true;
  }

  /// Get the base [ActionConfig] for [actionId].
  ActionConfig presetForAction(String actionId) {
    final data = _factoryPresets[actionId];
    if (data == null) return const ActionConfig();
    return ActionConfig.fromJson(data);
  }

  /// Merge theme-specific overrides on top of a base [ActionConfig].
  ActionConfig applyThemeOverrides(
    ActionConfig base,
    String themeId,
    String actionId,
  ) {
    final overrides = _themeOverrides[themeId]?[actionId];
    if (overrides == null || overrides.isEmpty) return base;
    return ActionConfig.fromJson({...base.toJson(), ...overrides});
  }

  /// Build full set of action configs for a theme.
  Map<String, ActionConfig> defaultActionConfigs(String themeId) {
    return {
      for (final actionId in kActionIds)
        actionId: applyThemeOverrides(presetForAction(actionId), themeId, actionId),
    };
  }
}

// ═══════════════════════════════════════════════════════════════
// Const data (used by UI widgets, not part of preset system)
// ═══════════════════════════════════════════════════════════════

const kActionIds = [
  'leftClick',
  'rightClick',
  'doubleClick',
  'longPress',
  'wheel',
  'hover',
];

const kActionLabels = {
  'leftClick': '左键单击',
  'rightClick': '右键单击',
  'doubleClick': '双击',
  'longPress': '长按',
  'wheel': '滚轮',
  'hover': '悬停',
};

const kActionHints = {
  'leftClick': '最常用的触发入口',
  'rightClick': '适合菜单或次要动作',
  'doubleClick': '更强的强调反馈',
  'longPress': '按住蓄力后触发',
  'wheel': '轻反馈和页面尾迹',
  'hover': '切状态或轻提示',
};
