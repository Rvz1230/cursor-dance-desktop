import '../models/action_config.dart';
import '../models/key_feedback_config.dart';
import '../models/theme.dart';
import '../models/theme_draft.dart';

// ═══════════════════════════════════════════════════════════════
// Persisted state snapshot
// ═══════════════════════════════════════════════════════════════

class PersistenceSnapshot {
  final bool enabled;
  final String activeThemeId;
  final KeyFeedbackConfig keyFeedbackConfig;
  final List<ThemeItem> themeLibrary;
  final Map<String, ThemeDraft> draftsByTheme;

  const PersistenceSnapshot({
    this.enabled = true,
    this.activeThemeId = '',
    this.keyFeedbackConfig = const KeyFeedbackConfig(),
    this.themeLibrary = const [],
    this.draftsByTheme = const {},
  });
}

// ═══════════════════════════════════════════════════════════════
// Encode: state fields → JSON map
// ═══════════════════════════════════════════════════════════════

Map<String, dynamic> encodePersistenceState({
  required bool enabled,
  required String activeThemeId,
  required KeyFeedbackConfig keyFeedbackConfig,
  required List<ThemeItem> themeLibrary,
  required Map<String, ThemeDraft> draftsByTheme,
}) {
  return {
    'enabled': enabled,
    'activeThemeId': activeThemeId,
    'keyFeedbackConfig': keyFeedbackConfig.toJson(),
    'themeLibrary': themeLibrary
        .map((t) => {
              'id': t.id,
              'name': t.name,
              'kind': t.kind,
              'icon': t.icon,
              'summary': t.summary,
              'description': t.description,
            })
        .toList(),
    'draftsByTheme': draftsByTheme.map(
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

// ═══════════════════════════════════════════════════════════════
// Decode: JSON map → PersistenceSnapshot
// ═══════════════════════════════════════════════════════════════

PersistenceSnapshot decodePersistenceState(Map<String, dynamic> data) {
  final enabled = data['enabled'] as bool? ?? true;
  final activeThemeId = data['activeThemeId'] as String? ?? '';

  final keyFeedbackConfig = data['keyFeedbackConfig'] != null
      ? KeyFeedbackConfig.fromJson(data['keyFeedbackConfig'] as Map<String, dynamic>)
      : const KeyFeedbackConfig();

  final List<ThemeItem> themeLibrary;
  final libraryData = data['themeLibrary'] as List<dynamic>?;
  if (libraryData != null && libraryData.isNotEmpty) {
    themeLibrary = libraryData.map((item) {
      return ThemeItem.fromJson(item as Map<String, dynamic>);
    }).toList();
  } else {
    themeLibrary = const [];
  }

  final Map<String, ThemeDraft> draftsByTheme;
  final draftsData = data['draftsByTheme'] as Map<String, dynamic>?;
  if (draftsData != null) {
    draftsByTheme = {};
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
      draftsByTheme[entry.key] = ThemeDraft(
        actionConfigs: actionConfigs,
        atmosphere: d['atmosphere'] != null
            ? AtmosphereConfig.fromJson(d['atmosphere'] as Map<String, dynamic>)
            : const AtmosphereConfig(),
        cursorModes: (d['cursorModes'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            const {},
        cursorStateActions: (d['cursorStateActions'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            const {},
        cursorStateAssets: (d['cursorStateAssets'] as Map<String, dynamic>?)
                ?.map((k, v) =>
                    MapEntry(k, CursorStateAsset.fromJson(v as Map<String, dynamic>))) ??
            const {},
      );
    }
  } else {
    draftsByTheme = const {};
  }

  return PersistenceSnapshot(
    enabled: enabled,
    activeThemeId: activeThemeId,
    keyFeedbackConfig: keyFeedbackConfig,
    themeLibrary: themeLibrary,
    draftsByTheme: draftsByTheme,
  );
}
