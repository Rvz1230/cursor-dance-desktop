import 'package:flutter/foundation.dart';

import '../models/action_config.dart';
import '../models/action_config_presets.dart';
import '../models/theme.dart';
import '../models/theme_draft.dart';

class WorkbenchState extends ChangeNotifier {
  // ── Workspace ──
  String _workspaceId = 'workbench';
  String get workspaceId => _workspaceId;

  // ── Selection ──
  String _selectedThemeId = kBuiltinThemes.first.id;
  String _selectedActionId = 'leftClick';
  String _selectedCursorStateId = 'default';

  String get selectedThemeId => _selectedThemeId;
  String get selectedActionId => _selectedActionId;
  String get selectedCursorStateId => _selectedCursorStateId;

  // ── Data ──
  List<ThemeItem> _themeLibrary = [...kBuiltinThemes];
  final Map<String, ThemeDraft> _draftsByTheme = buildDefaultDrafts();

  List<ThemeItem> get themeLibrary => _themeLibrary;
  Map<String, ThemeDraft> get draftsByTheme => _draftsByTheme;

  // ── UI State ──
  bool _enabled = true;
  bool _unsaved = false;
  bool _isSaving = false;
  String _saveError = '';

  bool get enabled => _enabled;
  bool get unsaved => _unsaved;
  bool get isSaving => _isSaving;
  String get saveError => _saveError;

  // ── Derived ──
  ThemeItem get activeTheme =>
      _themeLibrary.firstWhere(
        (t) => t.id == _selectedThemeId,
        orElse: () => _themeLibrary.first,
      );

  ThemeDraft get currentDraft => _draftsByTheme[_selectedThemeId] ?? ThemeDraft.create(_selectedThemeId);

  ActionConfig get currentActionConfig =>
      currentDraft.actionConfigs[_selectedActionId] ?? ActionConfig();

  List<String> get currentConflicts =>
      conflictsForAction(_selectedActionId, currentDraft.actionConfigs);

  bool get isWorkbench => _workspaceId == 'workbench';

  // ═══════════════════════════════════════════════
  // Workspace
  // ═══════════════════════════════════════════════

  void setWorkspaceId(String id) {
    if (_workspaceId == id) return;
    _workspaceId = id;
    _unsaved = true;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════
  // Selection
  // ═══════════════════════════════════════════════

  void setThemeId(String id) {
    if (_selectedThemeId == id) return;
    _selectedThemeId = id;
    notifyListeners();
  }

  void setActionId(String id) {
    if (_selectedActionId == id) return;
    _selectedActionId = id;
    notifyListeners();
  }

  void setCursorStateId(String id) {
    if (_selectedCursorStateId == id) return;
    _selectedCursorStateId = id;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════
  // Config Updates
  // ═══════════════════════════════════════════════

  void updateActionConfig(ActionConfig Function(ActionConfig) updater) {
    final draft = _draftsByTheme[_selectedThemeId] ?? ThemeDraft.create(_selectedThemeId);
    final actionConfigs = Map<String, ActionConfig>.from(draft.actionConfigs);
    actionConfigs[_selectedActionId] = updater(actionConfigs[_selectedActionId] ?? ActionConfig());
    _draftsByTheme[_selectedThemeId] = draft.copyWith(actionConfigs: actionConfigs);
    _unsaved = true;
    notifyListeners();
  }

  void updateActionConfigs(Map<String, ActionConfig Function(ActionConfig)> updaters) {
    var draft = _draftsByTheme[_selectedThemeId] ?? ThemeDraft.create(_selectedThemeId);
    var actionConfigs = Map<String, ActionConfig>.from(draft.actionConfigs);
    for (final entry in updaters.entries) {
      actionConfigs[entry.key] = entry.value(actionConfigs[entry.key] ?? ActionConfig());
    }
    _draftsByTheme[_selectedThemeId] = draft.copyWith(actionConfigs: actionConfigs);
    _unsaved = true;
    notifyListeners();
  }

  void updateAtmosphere(String key, dynamic value) {
    final draft = _draftsByTheme[_selectedThemeId] ?? ThemeDraft.create(_selectedThemeId);
    final updated = draft.copyWith(
      atmosphere: key == 'mode'
          ? AtmosphereConfig(mode: value as String)
          : AtmosphereConfig(mode: draft.atmosphere.mode),
    );
    _draftsByTheme[_selectedThemeId] = updated;
    _unsaved = true;
    notifyListeners();
  }

  void resetCurrentTheme() {
    _draftsByTheme[_selectedThemeId] = ThemeDraft.create(_selectedThemeId);
    _unsaved = true;
    notifyListeners();
  }

  void discardThemeChanges(String themeId) {
    _draftsByTheme[themeId] = ThemeDraft.create(themeId);
    notifyListeners();
  }

  // ═══════════════════════════════════════════════
  // Theme CRUD
  // ═══════════════════════════════════════════════

  void createTheme(String name, {String? basedOnThemeId}) {
    final id = 'theme-${DateTime.now().millisecondsSinceEpoch}';
    final baseId = basedOnThemeId ?? _selectedThemeId;
    final baseDraft = _draftsByTheme[baseId] ?? ThemeDraft.create(baseId);
    final newItem = ThemeItem(
      id: id,
      name: name,
      kind: '自定义',
      summary: buildThemeSummary(baseDraft.actionConfigs),
    );
    _themeLibrary = [..._themeLibrary, newItem];
    _draftsByTheme[id] = baseDraft.copyWith();
    _selectedThemeId = id;
    _unsaved = true;
    notifyListeners();
  }

  void duplicateTheme(String themeId) {
    final source = _themeLibrary.firstWhere(
      (t) => t.id == themeId,
      orElse: () => _themeLibrary.first,
    );
    final id = 'theme-${DateTime.now().millisecondsSinceEpoch}';
    final baseDraft = _draftsByTheme[themeId] ?? ThemeDraft.create(themeId);
    final newItem = source.copyWith(
      id: id,
      name: '${source.name} 副本',
      kind: '自定义',
    );
    _themeLibrary = [..._themeLibrary, newItem];
    _draftsByTheme[id] = baseDraft.copyWith();
    _selectedThemeId = id;
    _unsaved = true;
    notifyListeners();
  }

  void deleteTheme(String themeId) {
    if (_themeLibrary.length <= 1) return;
    _themeLibrary = _themeLibrary.where((t) => t.id != themeId).toList();
    _draftsByTheme.remove(themeId);
    if (_selectedThemeId == themeId) {
      _selectedThemeId = _themeLibrary.first.id;
    }
    _unsaved = true;
    notifyListeners();
  }

  void renameTheme(String themeId, String name) {
    _themeLibrary = _themeLibrary.map((t) {
      if (t.id != themeId) return t;
      return t.copyWith(name: name);
    }).toList();
    _unsaved = true;
    notifyListeners();
  }

  void updateThemeIcon(String themeId, String icon) {
    _themeLibrary = _themeLibrary.map((t) {
      if (t.id != themeId) return t;
      return t.copyWith(icon: icon);
    }).toList();
    _unsaved = true;
    notifyListeners();
  }

  String exportTheme(String themeId) {
    final draft = _draftsByTheme[themeId] ?? ThemeDraft.create(themeId);
    final item = _themeLibrary.firstWhere(
      (t) => t.id == themeId,
      orElse: () => _themeLibrary.first,
    );
    final exportData = {
      'id': themeId,
      'name': item.name,
      'icon': item.icon,
      'actionConfigs': draft.actionConfigs.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'atmosphere': {'mode': draft.atmosphere.mode},
    };
    return exportData.toString(); // Simplified for Phase 3.2
  }

  void importThemeFromText(String text, String fileName) {
    // Simplified for Phase 3.2 — creates an empty custom theme
    final id = 'theme-${DateTime.now().millisecondsSinceEpoch}';
    final newItem = ThemeItem(
      id: id,
      name: fileName.replaceAll('.json', ''),
      kind: '自定义',
    );
    _themeLibrary = [..._themeLibrary, newItem];
    _draftsByTheme[id] = ThemeDraft.create(newItem.id);
    _selectedThemeId = id;
    _unsaved = true;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════
  // Save / Persistence
  // ═══════════════════════════════════════════════

  Future<void> saveChanges() async {
    _isSaving = true;
    _saveError = '';
    notifyListeners();

    try {
      // In Phase 3.2, saving is a no-op that just marks state as clean
      await Future.delayed(const Duration(milliseconds: 100));
      _unsaved = false;
    } catch (e) {
      _saveError = e.toString();
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void setEnabled(bool value) {
    _enabled = value;
    notifyListeners();
  }
}
