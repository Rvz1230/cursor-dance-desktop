import 'package:flutter/foundation.dart';

import '../models/action_config.dart';
import '../models/action_config_presets.dart';
import '../models/theme_draft.dart';
import 'theme_provider.dart';

/// 当前动作配置管理 Provider
///
/// 依赖 ThemeProvider 来获取当前主题的草稿和选中动作，
/// 提供当前动作配置和冲突信息的派生状态。
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

  void _onThemeChanged() {
    // When theme selection changes, recompute derived state
    notifyListeners();
  }

  /// 当前动作的配置（从 ThemeProvider 的草稿中派生）
  ActionConfig get currentActionConfig {
    final draft = _themeProvider.draftsByTheme[_themeProvider.selectedThemeId] ??
        ThemeDraft.create(_themeProvider.selectedThemeId);
    return draft.actionConfigs[_selectedActionId] ?? ActionConfig();
  }

  /// 当前动作的冲突信息（从草稿派生）
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

  /// 更新当前动作的配置，委托给 ThemeProvider
  void updateConfig(ActionConfig Function(ActionConfig) updater) {
    _themeProvider.updateActionConfig(_selectedActionId, updater);
  }
}
