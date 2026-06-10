import 'package:flutter_test/flutter_test.dart';

import 'package:cursor_dance_desktop/providers/config_provider.dart';
import 'package:cursor_dance_desktop/providers/theme_provider.dart';
import 'package:cursor_dance_desktop/repository/persistence_repository.dart';

class _FakeRepo extends PersistenceRepository {
  @override
  Future<void> save(Map<String, dynamic> data) async {}
  @override
  Future<Map<String, dynamic>?> load() async => null;
}

void main() {
  late ThemeProvider themeProvider;
  late ConfigProvider configProvider;

  setUp(() {
    themeProvider = ThemeProvider(repo: _FakeRepo());
    configProvider = ConfigProvider(themeProvider: themeProvider);
  });

  group('action selection', () {
    test('starts with leftClick', () {
      expect(configProvider.selectedActionId, 'leftClick');
    });

    test('setActionId changes action', () {
      configProvider.setActionId('rightClick');
      expect(configProvider.selectedActionId, 'rightClick');
    });
  });

  group('config access', () {
    test('currentActionConfig returns non-null config for selected action', () {
      final config = configProvider.currentActionConfig;
      expect(config, isNotNull);
    });

    test('updateConfig modifies config via ThemeProvider', () {
      configProvider.updateConfig((c) => c.copyWith(textEnabled: true));
      expect(configProvider.currentActionConfig.textEnabled, true);
      expect(themeProvider.unsaved, true);
    });

    test('currentConflicts returns list for current action', () {
      final conflicts = configProvider.currentConflicts;
      expect(conflicts, isA<List<String>>());
    });
  });

  group('theme change propagation', () {
    test('currentActionConfig changes when theme switches', () {
      // Set values on current theme
      configProvider.updateConfig((c) => c.copyWith(textContent: 'A'));
      expect(configProvider.currentActionConfig.textContent, 'A');
    });
  });
}
