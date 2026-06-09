import 'package:flutter/foundation.dart';

import '../models/action_config.dart';
import '../models/action_config_presets.dart';
import '../models/key_feedback_config.dart';
import '../models/theme.dart';
import '../models/theme_draft.dart';
import '../services/state_codec.dart';
import '../services/theme_io_service.dart';
import '../services/workbench_persistence_service.dart';

class WorkbenchState extends ChangeNotifier {
  final WorkbenchPersistenceService _persistenceService;

  WorkbenchState({WorkbenchPersistenceService? persistenceService})
      : _persistenceService = persistenceService ?? WorkbenchPersistenceService();

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
  final Map<String, bool> _dirtyThemes = {};

  // ── Keyboard Feedback ──
  KeyFeedbackConfig _keyFeedbackConfig = const KeyFeedbackConfig();

  bool get enabled => _enabled;
  bool get unsaved => _unsaved;
  bool get isSaving => _isSaving;
  String get saveError => _saveError;
  Map<String, bool> get dirtyThemes => Map.unmodifiable(_dirtyThemes);
  KeyFeedbackConfig get keyFeedbackConfig => _keyFeedbackConfig;

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
    _dirtyThemes[_selectedThemeId] = true;
    notifyListeners();
  }

  void updateActionConfigs(Map<String, ActionConfig Function(ActionConfig)> updaters) {
    final draft = _draftsByTheme[_selectedThemeId] ?? ThemeDraft.create(_selectedThemeId);
    final actionConfigs = Map<String, ActionConfig>.from(draft.actionConfigs);
    for (final entry in updaters.entries) {
      actionConfigs[entry.key] = entry.value(actionConfigs[entry.key] ?? ActionConfig());
    }
    _draftsByTheme[_selectedThemeId] = draft.copyWith(actionConfigs: actionConfigs);
    _unsaved = true;
    _dirtyThemes[_selectedThemeId] = true;
    notifyListeners();
  }

  void resetCurrentTheme() {
    _draftsByTheme[_selectedThemeId] = ThemeDraft.create(_selectedThemeId);
    _unsaved = true;
    _dirtyThemes[_selectedThemeId] = true;
    notifyListeners();
  }

  void discardThemeChanges(String themeId) {
    _draftsByTheme[themeId] = ThemeDraft.create(themeId);
    _dirtyThemes.remove(themeId);
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
    _dirtyThemes[id] = true;
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
    _dirtyThemes[id] = true;
    notifyListeners();
  }

  void deleteTheme(String themeId) {
    if (_themeLibrary.length <= 1) return;
    _themeLibrary = _themeLibrary.where((t) => t.id != themeId).toList();
    _draftsByTheme.remove(themeId);
    _dirtyThemes.remove(themeId);
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
    _dirtyThemes[themeId] = true;
    notifyListeners();
  }

  void updateThemeIcon(String themeId, String icon) {
    _themeLibrary = _themeLibrary.map((t) {
      if (t.id != themeId) return t;
      return t.copyWith(icon: icon);
    }).toList();
    _unsaved = true;
    _dirtyThemes[themeId] = true;
    notifyListeners();
  }

  String exportTheme(String themeId) {
    final draft = _draftsByTheme[themeId] ?? ThemeDraft.create(themeId);
    final item = _themeLibrary.firstWhere(
      (t) => t.id == themeId,
      orElse: () => _themeLibrary.first,
    );
    return ThemeIoService.exportTheme(item, draft);
  }

  void importThemeFromText(String text, String fileName) {
    final result = ThemeIoService.importTheme(text, fileName);
    if (result.error != null) {
      debugPrint('导入主题失败: ${result.error}');
      return;
    }
    final newItem = ThemeItem(
      id: result.id,
      name: result.name,
      kind: '自定义',
      icon: result.icon,
    );
    _themeLibrary = [..._themeLibrary, newItem];
    _draftsByTheme[result.id] = ThemeDraft(
      actionConfigs: result.actionConfigs,
      atmosphere: const AtmosphereConfig(),
      cursorModes: result.cursorModes,
      cursorStateActions: result.cursorStateActions,
      cursorStateAssets: result.cursorStateAssets,
    );
    _selectedThemeId = result.id;
    _unsaved = true;
    _dirtyThemes[result.id] = true;
    notifyListeners();
  }

  void setEnabled(bool value) {
    _enabled = value;
    notifyListeners();
  }

  void updateKeyFeedbackConfig(KeyFeedbackConfig config) {
    _keyFeedbackConfig = config;
    notifyListeners();
  }

  Map<String, dynamic> buildOverlayPayload() {
    return {
      'actionId': _selectedActionId,
      'config': currentActionConfig.toJson(),
    };
  }

  Map<String, dynamic> toPersistenceJson() {
    return encodePersistenceState(
      enabled: _enabled,
      activeThemeId: _selectedThemeId,
      keyFeedbackConfig: _keyFeedbackConfig,
      themeLibrary: _themeLibrary,
      draftsByTheme: _draftsByTheme,
    );
  }

  void applyPersistenceJson(Map<String, dynamic> data) {
    final snap = decodePersistenceState(data);
    _enabled = snap.enabled;
    if (snap.activeThemeId.isNotEmpty) {
      _selectedThemeId = snap.activeThemeId;
    }
    _keyFeedbackConfig = snap.keyFeedbackConfig;
    if (snap.themeLibrary.isNotEmpty) {
      _themeLibrary = snap.themeLibrary;
    }
    if (snap.draftsByTheme.isNotEmpty) {
      _draftsByTheme
        ..clear()
        ..addAll(snap.draftsByTheme);
    }
  }

  Future<void> saveChanges() async {
    _isSaving = true;
    _saveError = '';
    notifyListeners();

    try {
      await _persistenceService.save(toPersistenceJson());
      _unsaved = false;
      _dirtyThemes.clear();
    } catch (e) {
      _saveError = e.toString();
      debugPrint('保存配置失败: $e');
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> loadSavedConfig() async {
    try {
      final data = await _persistenceService.load();
      if (data != null) {
        applyPersistenceJson(data);
      }
    } catch (e) {
      debugPrint('加载配置失败，使用默认值: $e');
    }
    notifyListeners();
  }
}
