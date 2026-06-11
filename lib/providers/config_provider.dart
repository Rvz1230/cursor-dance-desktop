import 'package:flutter/foundation.dart';

import '../models/action_config.dart';
import '../models/theme_draft.dart';
import 'theme_provider.dart';

class ConfigProvider extends ChangeNotifier {
  final ThemeProvider _themeProvider;

  String _selectedActionId = 'leftClick';
  String get selectedActionId => _selectedActionId;

  ConfigProvider({required this._themeProvider}) {
    _themeProvider.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeProvider.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => notifyListeners();

  ActionConfig get currentActionConfig {
    final draft = _themeProvider.draftsByTheme[_themeProvider.selectedThemeId] ??
        ThemeDraft.create(_themeProvider.selectedThemeId);
    return draft.actionConfigs[_selectedActionId] ?? ActionConfig();
  }

  List<String> get currentConflicts =>
      conflictsForAction(_selectedActionId, _getCurrentDraft().actionConfigs);

  ThemeDraft _getCurrentDraft() =>
      _themeProvider.draftsByTheme[_themeProvider.selectedThemeId] ??
      ThemeDraft.create(_themeProvider.selectedThemeId);

  void setActionId(String id) {
    if (_selectedActionId == id) return;
    _selectedActionId = id;
    notifyListeners();
  }

  void updateConfig(ActionConfig Function(ActionConfig) updater) {
    _themeProvider.updateActionConfig(_selectedActionId, updater);
  }
}
