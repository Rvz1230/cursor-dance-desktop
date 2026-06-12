import 'package:cursor_dance_desktop/models/key_feedback_config.dart';
import 'package:cursor_dance_desktop/models/theme.dart';
import 'package:cursor_dance_desktop/providers/theme_provider.dart';
import 'package:cursor_dance_desktop/services/preset_loader.dart';
import 'package:flutter_test/flutter_test.dart';

const _factoryJson = '''
{
  "leftClick": {"textEnabled": true, "particle": true},
  "rightClick": {"ripple": true},
  "doubleClick": {},
  "longPress": {},
  "wheel": {},
  "hover": {}
}
''';

const _overrideJson = '''
{
  "amber": {
    "leftClick": {"particleStyle": "火花", "particleCount": 28}
  },
  "teal": {
    "leftClick": {"textEnabled": false}
  },
  "slate": {},
  "rose": {},
  "sky": {}
}
''';

void main() {
  setUp(() {
    PresetRepository.instance.reset();
    PresetRepository.instance.loadFromStrings(_factoryJson, _overrideJson);
  });

  group('ThemeProvider', () {
    late ThemeProvider provider;

    setUp(() {
      provider = ThemeProvider();
    });

    test('initial state', () {
      expect(provider.selectedThemeId, kBuiltinThemes.first.id);
      expect(provider.unsaved, false);
      expect(provider.isSaving, false);
      expect(provider.themeLibrary.length, kBuiltinThemes.length);
    });

    test('setThemeId changes selection', () {
      provider.setThemeId('teal');
      expect(provider.selectedThemeId, 'teal');
    });

    test('setThemeId ignores same id', () {
      final id = provider.selectedThemeId;
      provider.setThemeId(id);
      expect(provider.selectedThemeId, id);
    });

    test('currentDraft returns draft for selected theme', () {
      provider.setThemeId('amber');
      final draft = provider.currentDraft;
      expect(draft, isNotNull);
      expect(draft.actionConfigs, isNotEmpty);
    });

    test('currentDraft uses preset data', () {
      provider.setThemeId('amber');
      final draft = provider.currentDraft;
      // amber leftClick has override: particleStyle=火花, particleCount=28
      expect(draft.actionConfigs['leftClick']!.particleStyle, '火花');
      expect(draft.actionConfigs['leftClick']!.particleCount, 28);
    });

    test('updateActionConfig modifies draft', () {
      provider.updateActionConfig('leftClick', (c) {
        return c.copyWith(textEnabled: true);
      });
      final draft = provider.draftsByTheme[provider.selectedThemeId]!;
      expect(draft.actionConfigs['leftClick']!.textEnabled, true);
      expect(provider.unsaved, true);
    });

    test('resetCurrentTheme clears customizations', () {
      provider.updateActionConfig('leftClick', (c) {
        return c.copyWith(textEnabled: true, particle: true);
      });
      provider.resetCurrentTheme();
      expect(provider.unsaved, true);
    });

    test('createTheme adds new theme and selects it', () {
      provider.createTheme('My Theme');
      expect(provider.themeLibrary.length, kBuiltinThemes.length + 1);
      expect(provider.selectedThemeId, contains('theme-'));
      expect(provider.unsaved, true);
    });

    test('duplicateTheme copies and renames', () {
      provider.duplicateTheme(kBuiltinThemes.first.id);
      final newTheme = provider.themeLibrary.first;
      expect(newTheme.name, contains('副本'));
      expect(provider.selectedThemeId, newTheme.id);
    });

    test('deleteTheme removes theme', () {
      final initialCount = provider.themeLibrary.length;
      provider.deleteTheme(kBuiltinThemes.last.id);
      expect(provider.themeLibrary.length, initialCount - 1);
    });

    test('deleteTheme does not remove last theme', () {
      while (provider.themeLibrary.length > 1) {
        provider.deleteTheme(provider.themeLibrary.last.id);
      }
      provider.deleteTheme(provider.themeLibrary.first.id);
      expect(provider.themeLibrary.length, 1);
    });

    test('renameTheme updates name', () {
      final id = kBuiltinThemes.first.id;
      provider.renameTheme(id, '新名称');
      expect(provider.themeLibrary.firstWhere((t) => t.id == id).name, '新名称');
    });

    test('updateKeyFeedbackConfig changes config', () {
      const newConfig = KeyFeedbackConfig(enabled: true, fontSize: 24);
      provider.updateKeyFeedbackConfig(newConfig);
      expect(provider.keyFeedbackConfig.enabled, true);
      expect(provider.keyFeedbackConfig.fontSize, 24);
    });

    group('persistence', () {
      test('toPersistenceJson → applyPersistenceJson round-trip', () {
        provider.setThemeId('amber');
        provider.updateActionConfig('leftClick', (c) {
          return c.copyWith(textEnabled: true, particle: true);
        });
        provider.updateKeyFeedbackConfig(
          const KeyFeedbackConfig(enabled: true),
        );

        final json = provider.toPersistenceJson();
        final newProvider = ThemeProvider();
        newProvider.applyPersistenceJson(json);

        expect(newProvider.selectedThemeId, 'amber');
        final draft = newProvider.draftsByTheme['amber']!;
        expect(draft.actionConfigs['leftClick']!.textEnabled, true);
        expect(draft.actionConfigs['leftClick']!.particle, true);
        expect(newProvider.keyFeedbackConfig.enabled, true);
      });

      test('applyPersistenceJson with empty data does not crash', () {
        provider.applyPersistenceJson({});
        expect(provider.selectedThemeId, kBuiltinThemes.first.id);
      });
    });

    group('export/import', () {
      test('exportTheme produces valid JSON', () {
        final exported = provider.exportTheme(kBuiltinThemes.first.id);
        expect(exported, contains('cursordance-theme-v1'));
        expect(exported, contains('actionConfigs'));
      });

      test('importThemeFromText creates new theme', () {
        final exported = provider.exportTheme(kBuiltinThemes.first.id);
        provider.importThemeFromText(exported, 'test.json');
        expect(provider.themeLibrary.length, kBuiltinThemes.length + 1);
        expect(provider.selectedThemeId, contains('theme-'));
      });
    });
  });
}
