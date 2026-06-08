// ═══════════════════════════════════════════════════════════════
// Barrel file — re-exports all presets sub-modules
// ═══════════════════════════════════════════════════════════════

export 'presets/preset_options.dart';
export 'presets/timing_meta.dart';
export 'presets/preset_factories.dart';
export 'presets/theme_overrides.dart';

import 'action_config.dart';

// ═══════════════════════════════════════════════════════════════
// Public API — config validation
// ═══════════════════════════════════════════════════════════════

List<String> conflictsForAction(String actionId, Map<String, ActionConfig> configs) {
  final current = configs[actionId];
  if (current == null) return [];
  final result = <String>[];

  if (actionId == 'longPress' &&
      current.sound &&
      (configs['leftClick']?.sound ?? false)) {
    result.add('长按和左键单击都在使用音效，后续需要明确谁先触发。');
  }

  if (!current.textEnabled &&
      !current.particle &&
      !current.ripple &&
      !current.sound &&
      !current.animationEnabled &&
      !current.imageEnabled) {
    result.add('当前动作没有绑定任何反馈，用户点击时会感觉没效果。');
  }

  return result;
}
