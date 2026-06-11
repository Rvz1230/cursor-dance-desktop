import 'action_config.dart';
import 'theme_draft.dart';

/// Preset configs for each theme's actions.
/// Phase 0: all defaults. Theme-specific overrides will be loaded
/// from assets/presets/theme_overrides.json by PresetRepository.

Map<String, ActionConfig> presetConfigsForTheme(String themeId) {
  return {
    for (final id in kActionIds) id: const ActionConfig(),
  };
}
