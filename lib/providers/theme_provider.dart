import 'package:flutter/foundation.dart';

import '../models/action_config.dart';
import '../models/key_feedback_config.dart';
import '../models/theme.dart';
import '../models/theme_draft.dart';
import '../repository/persistence_repository.dart';
import '../services/cursor_storage_service.dart';
import '../services/preset_loader.dart';
import '../services/theme_io_service.dart';

// ── Save result ───────────────────────────────────────────

class AsyncSaveResult {
  final bool ok;
  final String? error;
  const AsyncSaveResult({required this.ok, this.error});
}

class ThemeProvider extends ChangeNotifier {
  final PersistenceRepository _repo;

  ThemeProvider({PersistenceRepository? repo})
      : _repo = repo ?? PersistenceRepository();

  // ── Workspace ──
  String _workspaceId = 'workbench';
  String get workspaceId => _workspaceId;

  // ── Selection ──
  String _selectedThemeId = kBuiltinThemes.first.id;

  String get selectedThemeId => _selectedThemeId;

  // ── Data ──
  List<ThemeItem> _themeLibrary = [...kBuiltinThemes];
  final Map<String, ThemeDraft> _draftsByTheme = {};

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
  ThemeItem get activeTheme => _themeLibrary.firstWhere(
        (t) => t.id == _selectedThemeId,
        orElse: () => _themeLibrary.first,
      );

  ThemeDraft get currentDraft =>
      _draftsByTheme[_selectedThemeId] ?? _emptyDraft();

  bool get isWorkbench => _workspaceId == 'workbench';

  // ═══════════════════════════════════════════════
  // Helpers
  // ═══════════════════════════════════════════════

  ThemeDraft _emptyDraft() => ThemeDraft.create(
        PresetRepository.instance.defaultActionConfigs(_selectedThemeId),
      );

  void _ensureDraft(String themeId) {
    _draftsByTheme.putIfAbsent(
      themeId,
      () => ThemeDraft.create(
        PresetRepository.instance.defaultActionConfigs(themeId),
      ),
    );
  }

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
    _ensureDraft(id);
    notifyListeners();
  }

  // ═══════════════════════════════════════════════
  // Config Updates
  // ═══════════════════════════════════════════════

  void updateActionConfig(
    String actionId,
    ActionConfig Function(ActionConfig) updater,
  ) {
    _ensureDraft(_selectedThemeId);
    final draft = _draftsByTheme[_selectedThemeId]!;
    final actionConfigs = Map<String, ActionConfig>.from(draft.actionConfigs);
    actionConfigs[actionId] = updater(actionConfigs[actionId] ?? ActionConfig());
    _draftsByTheme[_selectedThemeId] =
        draft.copyWith(actionConfigs: actionConfigs);
    _unsaved = true;
    _dirtyThemes[_selectedThemeId] = true;
    notifyListeners();
  }

  void updateCursorState(String stateId, CursorStateEntry entry) {
    _ensureDraft(_selectedThemeId);
    final draft = _draftsByTheme[_selectedThemeId]!;
    final cursorStates = Map<String, CursorStateEntry>.from(draft.cursorStates);
    cursorStates[stateId] = entry;
    _draftsByTheme[_selectedThemeId] =
        draft.copyWith(cursorStates: cursorStates);
    _unsaved = true;
    _dirtyThemes[_selectedThemeId] = true;
    notifyListeners();
  }

  void removeCursorState(String stateId) {
    _ensureDraft(_selectedThemeId);
    final draft = _draftsByTheme[_selectedThemeId]!;
    final old = draft.cursorStates[stateId];
    final cursorStates = Map<String, CursorStateEntry>.from(draft.cursorStates);
    cursorStates.remove(stateId);
    _draftsByTheme[_selectedThemeId] =
        draft.copyWith(cursorStates: cursorStates);
    _unsaved = true;
    _dirtyThemes[_selectedThemeId] = true;
    // Clean up file
    if (old != null) {
      CursorStorageService.instance.delete(old.imagePath);
    }
    notifyListeners();
  }

  void resetCurrentTheme() {
    _draftsByTheme[_selectedThemeId] = ThemeDraft.create(
      PresetRepository.instance.defaultActionConfigs(_selectedThemeId),
    );
    _unsaved = true;
    _dirtyThemes[_selectedThemeId] = true;
    notifyListeners();
  }

  void discardThemeChanges(String themeId) {
    final oldDraft = _draftsByTheme[themeId];
    _draftsByTheme[themeId] = ThemeDraft.create(
      PresetRepository.instance.defaultActionConfigs(themeId),
    );
    // Clean up orphaned cursor files
    if (oldDraft != null) {
      for (final entry in oldDraft.cursorStates.values) {
        if (entry.imagePath.isNotEmpty) {
          CursorStorageService.instance.delete(entry.imagePath);
        }
      }
    }
    _dirtyThemes.remove(themeId);
    notifyListeners();
  }

  // ═══════════════════════════════════════════════
  // Theme CRUD
  // ═══════════════════════════════════════════════

  void createTheme(String name, {String? basedOnThemeId}) {
    final id = 'theme-${DateTime.now().microsecondsSinceEpoch}';
    if (basedOnThemeId == 'blank') {
      // blank template: empty action configs
      final blankItem = ThemeItem(
        id: id,
        name: name,
        kind: '自定义',
        summary: '0 个动效',
      );
      _themeLibrary = [blankItem, ..._themeLibrary];
      _draftsByTheme[id] = ThemeDraft.create({});
      _selectedThemeId = id;
      _unsaved = true;
      _dirtyThemes[id] = true;
      notifyListeners();
      return;
    }
    final baseId = basedOnThemeId ?? _selectedThemeId;
    _ensureDraft(baseId);
    final baseDraft = _draftsByTheme[baseId]!;
    final newItem = ThemeItem(
      id: id,
      name: name,
      kind: '自定义',
      summary: buildThemeSummary(baseDraft.actionConfigs),
    );
    _themeLibrary = [newItem, ..._themeLibrary];
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
    _ensureDraft(themeId);
    final baseDraft = _draftsByTheme[themeId]!;
    final newItem = source.copyWith(
      id: id,
      name: '${source.name} 副本',
      kind: '自定义',
    );
    _themeLibrary = [newItem, ..._themeLibrary];
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
    _ensureDraft(themeId);
    final draft = _draftsByTheme[themeId]!;
    final item = _themeLibrary.firstWhere(
      (t) => t.id == themeId,
      orElse: () => _themeLibrary.first,
    );
    return ThemeIoService.exportTheme(item, draft);
  }

  String? importThemeFromText(String text, String fileName) {
    final result = ThemeIoService.importTheme(text, fileName);
    if (result.error != null) {
      return result.error;
    }
    final newItem = ThemeItem(
      id: result.id,
      name: result.name,
      kind: '自定义',
      icon: result.icon,
    );
    _themeLibrary = [newItem, ..._themeLibrary];
    _draftsByTheme[result.id] = ThemeDraft(
      actionConfigs: result.actionConfigs,
      atmosphere: const AtmosphereConfig(),
      cursorStates: result.cursorStates,
    );
    _selectedThemeId = result.id;
    _unsaved = true;
    _dirtyThemes[result.id] = true;
    notifyListeners();
    // Return a hint if cursor states were present (images need re-upload)
    if (result.hasCursorStates) {
      return '__cursor_hint__';
    }
    return null;
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

  Map<String, dynamic> buildFullOverlayPayload() {
    final draft = currentDraft;
    return {
      'actions': draft.actionConfigs.map((k, v) => MapEntry(k, v.toJson())),
    };
  }

  Map<String, dynamic> buildSingleOverlayPayload(
    String actionId,
    ActionConfig config,
  ) {
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
        (key, draft) => MapEntry(key, draft.toJson()),
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
        _draftsByTheme[entry.key] = ThemeDraft.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
    }
  }

  Future<AsyncSaveResult> saveChanges() async {
    _isSaving = true;
    _saveError = '';
    notifyListeners();

    try {
      await _repo.save(toPersistenceJson());
      _unsaved = false;
      _dirtyThemes.clear();
      return const AsyncSaveResult(ok: true);
    } catch (e) {
      _saveError = e.toString();
      debugPrint('保存配置失败: $e');
      return AsyncSaveResult(ok: false, error: e.toString());
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
    // Ensure all builtin themes have drafts loaded
    for (final t in _themeLibrary) {
      _ensureDraft(t.id);
    }
    notifyListeners();
  }
}
