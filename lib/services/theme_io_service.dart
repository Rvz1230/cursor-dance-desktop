import 'dart:convert';

import '../models/action_config.dart';
import '../models/theme.dart';
import '../models/theme_draft.dart';

/// Result of importing a theme from JSON text.
class ThemeImportResult {
  final String id;
  final String name;
  final String icon;
  final Map<String, ActionConfig> actionConfigs;
  final Map<String, String> cursorModes;
  final Map<String, String> cursorStateActions;
  final Map<String, CursorStateAsset> cursorStateAssets;
  final String? error;

  const ThemeImportResult({
    required this.id,
    required this.name,
    required this.icon,
    this.actionConfigs = const {},
    this.cursorModes = const {},
    this.cursorStateActions = const {},
    this.cursorStateAssets = const {},
    this.error,
  });
}

/// Handles theme exporting (→ JSON string) and importing (← JSON string).
class ThemeIoService {
  static String exportTheme(ThemeItem item, ThemeDraft draft) {
    final exportData = {
      'format': 'cursordance-theme-v1',
      'id': item.id,
      'name': item.name,
      'icon': item.icon,
      'actionConfigs': draft.actionConfigs.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'cursorModes': draft.cursorModes,
      'cursorStateActions': draft.cursorStateActions,
      'cursorStateAssets': draft.cursorStateAssets.map(
        (k, v) => MapEntry(k, v.toJson()),
      ),
      'atmosphere': {'mode': draft.atmosphere.mode},
    };
    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  static ThemeImportResult importTheme(String text, String fileName) {
    try {
      final data = jsonDecode(text) as Map<String, dynamic>;
      final name = (data['name'] as String?) ?? fileName.replaceAll('.json', '');
      final icon = (data['icon'] as String?) ?? 'Wand2';
      final id = 'theme-${DateTime.now().microsecondsSinceEpoch}';

      final rawConfigs = data['actionConfigs'] as Map<String, dynamic>?;
      final actionConfigs = <String, ActionConfig>{};
      if (rawConfigs != null) {
        for (final entry in rawConfigs.entries) {
          actionConfigs[entry.key] = ActionConfig.fromJson(
            entry.value as Map<String, dynamic>,
          );
        }
      }

      final rawCursorModes = data['cursorModes'] as Map<String, dynamic>?;
      final rawCursorActions = data['cursorStateActions'] as Map<String, dynamic>?;
      final rawCursorAssets = data['cursorStateAssets'] as Map<String, dynamic>?;

      return ThemeImportResult(
        id: id,
        name: name,
        icon: icon,
        actionConfigs: actionConfigs,
        cursorModes: rawCursorModes?.map((k, v) => MapEntry(k, v as String)) ?? const {},
        cursorStateActions: rawCursorActions?.map((k, v) => MapEntry(k, v as String)) ?? const {},
        cursorStateAssets: rawCursorAssets?.map(
          (k, v) => MapEntry(k, CursorStateAsset.fromJson(v as Map<String, dynamic>)),
        ) ?? const {},
      );
    } catch (e) {
      return ThemeImportResult(id: '', name: '', icon: '', error: e.toString());
    }
  }
}
