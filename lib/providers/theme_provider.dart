import 'package:flutter/foundation.dart';

import '../models/action_config.dart';
import '../models/key_feedback_config.dart';
import '../models/theme.dart';
import '../models/theme_draft.dart';
import '../repository/persistence_repository.dart';
import '../services/theme_io_service.dart';

/// 主题库状态管理 Provider
///
/// 负责：
/// - 主题库 CRUD（create/delete/rename/duplicate）
/// - 草稿管理（draftsByTheme）
/// - 选中态（selectedThemeId / workspaceId）
/// - 键盘反馈配置（keyFeedbackConfig）
/// - 持久化（save/load）
class ThemeProvider extends ChangeNotifier {
  final PersistenceRepository _repo;

  ThemeProvider({PersistenceRepository? repo})
      : _repo = repo ?? PersistenceRepository();

  // ── Workspace ──
  String _workspaceId = 'workbench';
  String get workspaceId => _workspaceId;

  // ── Selection ──
  String _selectedThemeId = kBuiltinThemes.first.id;
  String _selectedCursorStateId = 'default';

  String get selectedThemeId => _selectedThemeId;
  String get selectedCursorStateId => _selectedCursorStateId;

  // ── Data ──
  List<ThemeItem> _themeLibrary = [...kBuiltinThemes];
  final Map<String, ThemeDraft> _draftsByTheme = buildDefaultDrafts();

  List<ThemeItem> get themeLibrary => _themeLibrary;
  Map<String, ThemeDraft> get draftsByTheme => _draftsByTheme;

  // ── UI State ──
  bool _unsaved = false;
  bool _isSaving = false;
  String _saveError = '';
  final Map<String, bool> _dirtyThemes = {};

  bool get unsaved => _unsaved;
  bool get isSaving => _isSaving;
  String get saveError => _saveError;
  Map<String, bool> get dirtyThemes => Map.unmodifiable(_dirtyThemes);

  // ── Keyboard Feedback ──
  KeyFeedbackConfig _keyFeedbackConfig = const KeyFeedbackConfig();
  KeyFeedbackConfig get keyFeedbackConfig => _keyFeedbackConfig;

  // ── Derived ──
  ThemeItem get activeTheme =>
      _themeLibrary.firstWhere(
        (t) => t.id == _selectedThemeId,
        orElse: () => _themeLibrary.first,
      );

  ThemeDraft get currentDraft =>
      _draftsByTheme[_selectedThemeId] ?? ThemeDraft.create(_selectedThemeId);

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

  void setCursorStateId(String id) {
    if (_selectedCursorStateId == id) return;
    _selectedCursorStateId = id;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════
  // Config Updates (delegated from ConfigProvider)
  // ═══════════════════════════════════════════════

  void updateActionConfig(String actionId, ActionConfig Function(ActionConfig) updater) {
    final draft = _draftsByTheme[_selectedThemeId] ?? ThemeDraft.create(_selectedThemeId);
    final actionConfigs = Map<String, ActionConfig>.from(draft.actionConfigs);
    actionConfigs[actionId] = updater(actionConfigs[actionId] ?? ActionConfig());
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
    final id = 'theme-${DateTime.now().microsecondsSinceEpoch}';
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
    final id = 'theme-${DateTime.now().microsecondsSinceEpoch}';
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

  // ═══════════════════════════════════════════════
  // Key Feedback
  // ═══════════════════════════════════════════════

  void updateKeyFeedbackConfig(KeyFeedbackConfig config) {
    _keyFeedbackConfig = config;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════
  // Overlay payload
  // ═══════════════════════════════════════════════

  Map<String, dynamic> buildOverlayPayload(String actionId, ActionConfig config) {
    return {
      'actionId': actionId,
      'config': config.toJson(),
    };
  }

  // ═══════════════════════════════════════════════
  // Persistence
  // ═══════════════════════════════════════════════

  Map<String, dynamic> toPersistenceJson() {
    return {
      'activeThemeId': _selectedThemeId,
      'keyFeedbackConfig': _keyFeedbackConfig.toJson(),
      'themeLibrary': _themeLibrary
          .map((t) => {
                'id': t.id,
                'name': t.name,
                'kind': t.kind,
                'icon': t.icon,
                'summary': t.summary,
                'description': t.description,
              })
          .toList(),
      'draftsByTheme': _draftsByTheme.map(
        (key, draft) => MapEntry(key, {
          'actionConfigs': draft.actionConfigs.map(
            (k, v) => MapEntry(k, v.toJson()),
          ),
          'atmosphere': {'mode': draft.atmosphere.mode},
          'cursorModes': draft.cursorModes,
          'cursorStateActions': draft.cursorStateActions,
          'cursorStateAssets': draft.cursorStateAssets.map(
            (k, v) => MapEntry(k, v.toJson()),
          ),
        }),
      ),
    };
  }

  void applyPersistenceJson(Map<String, dynamic> data) {
    final themeId = data['activeThemeId'] as String?;
    if (themeId != null && themeId.isNotEmpty) {
      _selectedThemeId = themeId;
    }
    if (data['keyFeedbackConfig'] != null) {
      _keyFeedbackConfig = KeyFeedbackConfig.fromJson(
        data['keyFeedbackConfig'] as Map<String, dynamic>,
      );
    }
    final libraryData = data['themeLibrary'] as List<dynamic>?;
    if (libraryData != null && libraryData.isNotEmpty) {
      _themeLibrary = libraryData
          .map((item) => ThemeItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    final draftsData = data['draftsByTheme'] as Map<String, dynamic>?;
    if (draftsData != null) {
      _draftsByTheme.clear();
      for (final entry in draftsData.entries) {
        final d = entry.value as Map<String, dynamic>;
        final rawConfigs = d['actionConfigs'] as Map<String, dynamic>?;
        final actionConfigs = <String, ActionConfig>{};
        if (rawConfigs != null) {
          for (final ce in rawConfigs.entries) {
            actionConfigs[ce.key] = ActionConfig.fromJson(
              ce.value as Map<String, dynamic>,
            );
          }
        }
        _draftsByTheme[entry.key] = ThemeDraft(
          actionConfigs: actionConfigs,
          atmosphere: d['atmosphere'] != null
              ? AtmosphereConfig.fromJson(
                  d['atmosphere'] as Map<String, dynamic>)
              : const AtmosphereConfig(),
          cursorModes: (d['cursorModes'] as Map<String, dynamic>?)
                  ?.map((k, v) => MapEntry(k, v as String)) ??
              const {},
          cursorStateActions: (d['cursorStateActions'] as Map<String, dynamic>?)
                  ?.map((k, v) => MapEntry(k, v as String)) ??
              const {},
          cursorStateAssets:
              (d['cursorStateAssets'] as Map<String, dynamic>?)
                      ?.map((k, v) => MapEntry(
                          k,
                          CursorStateAsset.fromJson(
                              v as Map<String, dynamic>))) ??
                  const {},
        );
      }
    }
  }

  Future<void> saveChanges() async {
    _isSaving = true;
    _saveError = '';
    notifyListeners();

    try {
      await _repo.save(toPersistenceJson());
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
      final data = await _repo.load();
      if (data != null) {
        applyPersistenceJson(data);
      }
    } catch (e) {
      debugPrint('加载配置失败，使用默认值: $e');
    }
    notifyListeners();
  }
}
