import 'package:cursor_dance_desktop/models/action_config.dart';
import 'package:cursor_dance_desktop/models/theme_draft.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeDraft', () {
    test('create factory sets actionConfigs', () {
      final configs = {
        'leftClick': const ActionConfig(textEnabled: true),
        'rightClick': const ActionConfig(particle: true),
      };
      final draft = ThemeDraft.create(configs);
      expect(draft.actionConfigs, configs);
      expect(draft.cursorModes, isEmpty);
      expect(draft.atmosphere.mode, 'none');
    });

    test('copyWith only overrides provided fields', () {
      final original = ThemeDraft.create({
        'leftClick': const ActionConfig(textEnabled: true),
      });
      final modified = original.copyWith(
        cursorModes: {'default': 'pointer'},
      );
      expect(modified.actionConfigs, original.actionConfigs);
      expect(modified.cursorModes, {'default': 'pointer'});
    });

    test('toJson → fromJson round-trip', () {
      final draft = ThemeDraft(
        actionConfigs: {
          'leftClick': const ActionConfig(textEnabled: true, particle: true),
          'rightClick': const ActionConfig(ripple: true),
        },
        cursorModes: {'default': 'pointer', 'hover': 'grab'},
        cursorStateActions: {'click': 'leftClick'},
        cursorStateAssets: {
          'press': CursorStateAsset(
            imageDataUrl: 'data:png',
            hotspotX: 8,
            hotspotY: 16,
            size: 32,
          ),
        },
        atmosphere: const AtmosphereConfig(mode: 'rain'),
      );

      final json = draft.toJson();
      final restored = ThemeDraft.fromJson(json);

      expect(restored.actionConfigs.length, 2);
      expect(restored.actionConfigs['leftClick']!.textEnabled, true);
      expect(restored.actionConfigs['leftClick']!.particle, true);
      expect(restored.actionConfigs['rightClick']!.ripple, true);
      expect(restored.cursorModes, {'default': 'pointer', 'hover': 'grab'});
      expect(restored.cursorStateActions, {'click': 'leftClick'});
      expect(restored.cursorStateAssets['press']!.imageDataUrl, 'data:png');
      expect(restored.cursorStateAssets['press']!.hotspotX, 8);
      expect(restored.atmosphere.mode, 'rain');
    });

    test('fromJson handles missing optional fields', () {
      final draft = ThemeDraft.fromJson({
        'actionConfigs': {
          'leftClick': {'textEnabled': true},
        },
      });
      expect(draft.actionConfigs['leftClick']!.textEnabled, true);
      expect(draft.cursorModes, isEmpty);
      expect(draft.cursorStateAssets, isEmpty);
      expect(draft.atmosphere.mode, 'none');
    });

    test('fromJson handles empty input', () {
      final draft = ThemeDraft.fromJson({});
      expect(draft.actionConfigs, isEmpty);
      expect(draft.cursorModes, isEmpty);
      expect(draft.atmosphere.mode, 'none');
    });
  });

  group('AtmosphereConfig', () {
    test('toJson → fromJson round-trip', () {
      const config = AtmosphereConfig(mode: 'snow');
      final json = config.toJson();
      final restored = AtmosphereConfig.fromJson(json);
      expect(restored, config);
    });
  });

  group('CursorStateAsset', () {
    test('toJson → fromJson round-trip', () {
      const asset = CursorStateAsset(
        imageDataUrl: 'data:png;base64,abc',
        hotspotX: 10,
        hotspotY: 20,
        size: 40,
      );
      final json = asset.toJson();
      final restored = CursorStateAsset.fromJson(json);
      expect(restored, asset);
    });
  });

  group('buildThemeSummary', () {
    test('counts enabled effects', () {
      final configs = {
        'leftClick': const ActionConfig(textEnabled: true, particle: true),
        'rightClick': const ActionConfig(ripple: true),
        'doubleClick': const ActionConfig(),
      };
      expect(buildThemeSummary(configs), '2 个动效');
    });

    test('returns 0 when nothing enabled', () {
      final configs = {
        'leftClick': const ActionConfig(),
        'rightClick': const ActionConfig(),
      };
      expect(buildThemeSummary(configs), '0 个动效');
    });
  });

  group('conflictsForAction', () {
    test('detects holdMs + 抬起时 conflict', () {
      final configs = {
        'leftClick': const ActionConfig(holdMs: 300, triggerTiming: '抬起时'),
      };
      final conflicts = conflictsForAction('leftClick', configs);
      expect(conflicts.length, 1);
      expect(conflicts.first, contains('按下时'));
    });

    test('no conflict when holdMs is 0', () {
      final configs = {
        'leftClick': const ActionConfig(holdMs: 0, triggerTiming: '抬起时'),
      };
      expect(conflictsForAction('leftClick', configs), isEmpty);
    });

    test('no conflict when timing is 按下时', () {
      final configs = {
        'leftClick': const ActionConfig(holdMs: 300, triggerTiming: '按下时'),
      };
      expect(conflictsForAction('leftClick', configs), isEmpty);
    });
  });
}
