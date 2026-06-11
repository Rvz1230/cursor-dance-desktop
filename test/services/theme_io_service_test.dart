import 'package:cursor_dance_desktop/models/action_config.dart';
import 'package:cursor_dance_desktop/models/theme.dart';
import 'package:cursor_dance_desktop/models/theme_draft.dart';
import 'package:cursor_dance_desktop/services/theme_io_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeIoService', () {
    test('exportTheme produces valid JSON with format marker', () {
      const item = ThemeItem(id: 'test', name: '测试', icon: 'Star');
      final draft = ThemeDraft.create({
        'leftClick': const ActionConfig(textEnabled: true),
      });
      final exported = ThemeIoService.exportTheme(item, draft);
      expect(exported, contains('cursordance-theme-v1'));
      expect(exported, contains('"id": "test"'));
      expect(exported, contains('"name": "测试"'));
      expect(exported, contains('actionConfigs'));
    });

    test('exportTheme → importTheme round-trip preserves actionConfigs', () {
      const item = ThemeItem(id: 'src', name: '源', icon: 'Flame');
      final draft = ThemeDraft(
        actionConfigs: {
          'leftClick': const ActionConfig(
            textEnabled: true,
            particle: true,
            particleCount: 30,
          ),
          'rightClick': const ActionConfig(ripple: true),
        },
        cursorModes: {'default': 'pointer'},
        cursorStateActions: {'click': 'leftClick'},
        cursorStateAssets: {
          'press': CursorStateAsset(imageDataUrl: 'data:png', size: 32),
        },
        atmosphere: const AtmosphereConfig(mode: 'rain'),
      );

      final exported = ThemeIoService.exportTheme(item, draft);
      final result = ThemeIoService.importTheme(exported, 'test.json');

      expect(result.error, isNull);
      expect(result.actionConfigs['leftClick']!.textEnabled, true);
      expect(result.actionConfigs['leftClick']!.particleCount, 30);
      expect(result.actionConfigs['rightClick']!.ripple, true);
      expect(result.cursorModes, {'default': 'pointer'});
      expect(result.cursorStateActions, {'click': 'leftClick'});
      expect(result.cursorStateAssets['press']!.imageDataUrl, 'data:png');
    });

    test('importTheme returns error for invalid JSON', () {
      final result = ThemeIoService.importTheme('not json', 'bad.json');
      expect(result.error, isNotNull);
    });

    test('importTheme uses filename as fallback name', () {
      final result =
          ThemeIoService.importTheme('{}', 'my_theme.json');
      expect(result.name, 'my_theme');
    });

    test('importTheme generates unique id', () {
      final result1 = ThemeIoService.importTheme('{"name":"a"}', 'a.json');
      final result2 = ThemeIoService.importTheme('{"name":"b"}', 'b.json');
      expect(result1.id, isNot(equals(result2.id)));
    });
  });
}
