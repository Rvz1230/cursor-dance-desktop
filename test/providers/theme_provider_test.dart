import 'package:flutter_test/flutter_test.dart';

import 'package:cursor_dance_desktop/providers/theme_provider.dart';
import 'package:cursor_dance_desktop/repository/persistence_repository.dart';

/// Fake repository that stores data in memory instead of on disk.
class FakePersistenceRepository extends PersistenceRepository {
  Map<String, dynamic>? _storedData;

  @override
  Future<void> save(Map<String, dynamic> data) async {
    _storedData = data;
  }

  @override
  Future<Map<String, dynamic>?> load() async {
    return _storedData;
  }
}

void main() {
  late ThemeProvider provider;
  late FakePersistenceRepository repo;

  setUp(() {
    repo = FakePersistenceRepository();
    provider = ThemeProvider(repo: repo);
  });

  group('initial state', () {
    test('starts with builtin themes', () {
      expect(provider.themeLibrary.length, greaterThan(0));
      expect(provider.themeLibrary.first.kind, '内置');
    });

    test('starts with workbench workspace', () {
      expect(provider.workspaceId, 'workbench');
    });

    test('drafts are populated for builtin themes', () {
      expect(provider.draftsByTheme.length, greaterThan(0));
    });

    test('is not unsaved initially', () {
      expect(provider.unsaved, false);
    });
  });

  group('workspace', () {
    test('setWorkspaceId changes workspace', () {
      provider.setWorkspaceId('keyboard');
      expect(provider.workspaceId, 'keyboard');
    });

    test('setWorkspaceId does nothing if same', () {
      provider.setWorkspaceId('workbench');
      expect(provider.workspaceId, 'workbench');
    });
  });

  group('theme CRUD', () {
    test('createTheme adds a new theme and selects it', () {
      provider.createTheme('我的主题');

      expect(provider.themeLibrary.length, 5); // 4 builtin + 1 new
      expect(provider.themeLibrary.last.name, '我的主题');
      expect(provider.themeLibrary.last.kind, '自定义');
      expect(provider.selectedThemeId, provider.themeLibrary.last.id);
      expect(provider.unsaved, true);
      expect(provider.dirtyThemes.containsKey(provider.themeLibrary.last.id), true);
    });

    test('duplicateTheme copies an existing theme', () {
      provider.duplicateTheme('drift');

      expect(provider.themeLibrary.length, 5);
      expect(provider.themeLibrary.last.name, '流光 副本');
      expect(provider.themeLibrary.last.kind, '自定义');
    });

    test('deleteTheme removes a theme', () {
      provider.deleteTheme('drift');

      expect(provider.themeLibrary.length, 3);
    });

    test('deleteTheme does nothing when only one theme remains', () {
      // Delete all until one remains
      provider.deleteTheme('drift');
      provider.deleteTheme('mono-geo');
      provider.deleteTheme('molten');
      expect(provider.themeLibrary.length, 1);
      provider.deleteTheme(provider.themeLibrary.first.id);
      expect(provider.themeLibrary.length, 1); // Still 1
    });

    test('renameTheme renames and marks dirty', () {
      provider.renameTheme('drift', '新建的名字');

      final renamed = provider.themeLibrary.firstWhere((t) => t.id == 'drift');
      expect(renamed.name, '新建的名字');
      expect(provider.unsaved, true);
      expect(provider.dirtyThemes['drift'], true);
    });

    test('updateThemeIcon changes icon', () {
      provider.updateThemeIcon('drift', 'Star');

      final updated = provider.themeLibrary.firstWhere((t) => t.id == 'drift');
      expect(updated.icon, 'Star');
    });
  });

  group('config updates', () {
    test('updateActionConfig modifies action config and marks dirty', () {
      provider.updateActionConfig('leftClick', (c) => c.copyWith(textEnabled: true));

      expect(provider.unsaved, true);
      expect(provider.dirtyThemes[provider.selectedThemeId], true);
    });

    test('discardThemeChanges resets draft', () {
      provider.updateActionConfig('leftClick', (c) => c.copyWith(textEnabled: true));
      expect(provider.dirtyThemes[provider.selectedThemeId], true);

      provider.discardThemeChanges(provider.selectedThemeId);

      expect(provider.dirtyThemes.containsKey(provider.selectedThemeId), false);
    });

    test('resetCurrentTheme resets current draft', () {
      provider.updateActionConfig('leftClick', (c) => c.copyWith(textEnabled: true));
      provider.resetCurrentTheme();

      expect(provider.unsaved, true);
      expect(provider.dirtyThemes[provider.selectedThemeId], true);
    });
  });

  group('key feedback config', () {
    test('updateKeyFeedbackConfig updates config', () {
      final updated =
          provider.keyFeedbackConfig.copyWith(enabled: false);
      provider.updateKeyFeedbackConfig(updated);

      expect(provider.keyFeedbackConfig.enabled, false);
    });
  });

  group('persistence', () {
    test('saveChanges persists and clears dirty flags', () async {
      provider.createTheme('新主题');
      expect(provider.unsaved, true);

      await provider.saveChanges();

      expect(provider.unsaved, false);
      expect(provider.dirtyThemes.isEmpty, true);
      expect(provider.saveError, '');
    });

    test('loadSavedConfig restores previously saved data', () async {
      provider.createTheme('测试主题');
      await provider.saveChanges();

      // Create a fresh provider and load
      final freshRepo = FakePersistenceRepository();
      final savedData = await repo.load();
      if (savedData != null) {
        await freshRepo.save(savedData);
      }
      final fresh = ThemeProvider(repo: freshRepo);
      await fresh.loadSavedConfig();

      expect(fresh.themeLibrary.length, 5);
      expect(fresh.themeLibrary.last.name, '测试主题');
    });
  });

  group('selection', () {
    test('setThemeId changes selected theme', () {
      provider.setThemeId('drift');
      expect(provider.selectedThemeId, 'drift');
    });

    test('setCursorStateId changes cursor state', () {
      provider.setCursorStateId('text');
      expect(provider.selectedCursorStateId, 'text');
    });
  });

  group('derived state', () {
    test('activeTheme returns current theme', () {
      provider.setThemeId('molten');
      expect(provider.activeTheme.id, 'molten');
      expect(provider.activeTheme.name, '熔金');
    });
  });

  group('export / import', () {
    test('exportTheme returns valid JSON string', () {
      final json = provider.exportTheme('drift');
      expect(json, contains('"format": "cursordance-theme-v1"'));
      expect(json, contains('"id": "drift"'));
    });

    test('importThemeFromText adds imported theme', () {
      final json = provider.exportTheme('drift');
      provider.importThemeFromText(json, 'imported.json');

      expect(provider.themeLibrary.length, 5);
      expect(provider.themeLibrary.last.kind, '自定义');
    });
  });
}
