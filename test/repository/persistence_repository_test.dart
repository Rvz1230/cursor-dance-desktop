import 'dart:io';

import 'package:cursor_dance_desktop/repository/persistence_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PersistenceRepository', () {
    late PersistenceRepository repo;
    late String testDir;

    setUp(() async {
      testDir =
          '${Directory.systemTemp.path}/cursordance_test_${DateTime.now().microsecondsSinceEpoch}';
      await Directory(testDir).create(recursive: true);
      repo = PersistenceRepository(configDirOverride: testDir);
    });

    tearDown(() async {
      final dir = Directory(testDir);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    });

    test('save → load round-trip preserves data', () async {
      final data = {
        'activeThemeId': 'amber',
        'keyFeedbackConfig': {'enabled': true, 'fontSize': 20},
        'themeLibrary': [
          {'id': 'amber', 'name': '琥珀', 'kind': '内置', 'icon': 'Flame'}
        ],
        'draftsByTheme': {
          'amber': {
            'actionConfigs': {
              'leftClick': {'textEnabled': true, 'particle': true},
            },
            'atmosphere': {'mode': 'none'},
            'cursorStates': <String, dynamic>{},
          },
        },
      };

      await repo.save(data);
      final loaded = await repo.load();

      expect(loaded, isNotNull);
      expect(loaded!['activeThemeId'], 'amber');
      expect(
        (loaded['themeLibrary'] as List).first['name'],
        '琥珀',
      );
    });

    test('load returns null when no config exists', () async {
      final freshDir =
          '${Directory.systemTemp.path}/cursordance_empty_${DateTime.now().microsecondsSinceEpoch}';
      final freshRepo = PersistenceRepository(configDirOverride: freshDir);
      final result = await freshRepo.load();
      expect(result, isNull);
    });

    test('saved data includes schemaVersion', () async {
      await repo.save({'test': 'value'});
      final loaded = await repo.load();
      expect(loaded?['schemaVersion'], 1);
    });

    test('backup is created on save', () async {
      await repo.save({'test': 'value'});
      final backupFile = File('$testDir/config.backup.json');
      expect(await backupFile.exists(), true);
    });

    test('falls back to backup when main config is corrupted', () async {
      await repo.save({'activeThemeId': 'amber'});

      // Corrupt main config
      final configFile = File('$testDir/config.json');
      await configFile.writeAsString('{invalid json');

      final loaded = await repo.load();
      expect(loaded?['activeThemeId'], 'amber');
    });

    test('overwrites existing config on save', () async {
      await repo.save({'version': 1});
      await repo.save({'version': 2});
      final loaded = await repo.load();
      expect(loaded?['version'], 2);
    });
  });
}
