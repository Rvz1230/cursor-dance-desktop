import 'dart:convert';

import '../models/action_config.dart';
import '../models/theme.dart';
import '../models/theme_draft.dart';

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

class ThemeIoService {
  static String exportTheme(ThemeItem item, ThemeDraft draft) {
    final exportData = {
      'format': 'cursordance-theme-v1',
      'id': item.id,
      'name': item.name,
      'icon': item.icon,
      ...draft.toJson(),
    };
    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  static ThemeImportResult importTheme(String text, String fileName) {
    try {
      final data = jsonDecode(text) as Map<String, dynamic>;
      final name =
          (data['name'] as String?) ?? fileName.replaceAll('.json', '');
      final icon = (data['icon'] as String?) ?? 'Wand2';
      final id = 'theme-${DateTime.now().microsecondsSinceEpoch}';

      final draft = ThemeDraft.fromJson(data);

      return ThemeImportResult(
        id: id,
        name: name,
        icon: icon,
        actionConfigs: draft.actionConfigs,
        cursorModes: draft.cursorModes,
        cursorStateActions: draft.cursorStateActions,
        cursorStateAssets: draft.cursorStateAssets,
      );
    } catch (e) {
      return ThemeImportResult(id: '', name: '', icon: '', error: e.toString());
    }
  }
}
