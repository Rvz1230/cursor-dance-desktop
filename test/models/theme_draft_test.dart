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
      expect(draft.cursorStates, isEmpty);
      expect(draft.atmosphere.mode, 'none');
    });

    test('copyWith only overrides provided fields', () {
      final original = ThemeDraft.create({
        'leftClick': const ActionConfig(textEnabled: true),
      });
      final modified = original.copyWith(
        cursorStates: {'arrow': const CursorStateEntry(imagePath: 'arrow.png')},
      );
      expect(modified.actionConfigs, original.actionConfigs);
      expect(modified.cursorStates['arrow']!.imagePath, 'arrow.png');
    });

    test('toJson → fromJson round-trip', () {
      final draft = ThemeDraft(
        actionConfigs: {
          'leftClick': const ActionConfig(textEnabled: true, particle: true),
          'rightClick': const ActionConfig(ripple: true),
        },
        cursorStates: {
          'arrow': const CursorStateEntry(
            imagePath: 'arrow.png',
            hotspotX: 8,
            hotspotY: 16,
            size: 32,
          ),
          'pointer': const CursorStateEntry(
            imagePath: 'pointer.gif',
            isAnimated: true,
            frameCount: 12,
            fps: 30,
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
      expect(restored.cursorStates['arrow']!.imagePath, 'arrow.png');
      expect(restored.cursorStates['arrow']!.hotspotX, 8);
      expect(restored.cursorStates['pointer']!.isAnimated, true);
      expect(restored.cursorStates['pointer']!.frameCount, 12);
      expect(restored.atmosphere.mode, 'rain');
    });

    test('fromJson handles missing optional fields', () {
      final draft = ThemeDraft.fromJson({
        'actionConfigs': {
          'leftClick': {'textEnabled': true},
        },
      });
      expect(draft.actionConfigs['leftClick']!.textEnabled, true);
      expect(draft.cursorStates, isEmpty);
      expect(draft.atmosphere.mode, 'none');
    });

    test('fromJson handles empty input', () {
      final draft = ThemeDraft.fromJson({});
      expect(draft.actionConfigs, isEmpty);
      expect(draft.cursorStates, isEmpty);
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

  group('CursorStateEntry', () {
    test('toJson → fromJson round-trip', () {
      const entry = CursorStateEntry(
        imagePath: 'crosshair.png',
        hotspotX: 10,
        hotspotY: 20,
        size: 40,
      );
      final json = entry.toJson();
      final restored = CursorStateEntry.fromJson(json);
      expect(restored, entry);
    });

    test('animated entry round-trip', () {
      const entry = CursorStateEntry(
        imagePath: 'resize.gif',
        imageFormat: 'gif',
        isAnimated: true,
        frameCount: 24,
        fps: 30,
        size: 64,
      );
      final json = entry.toJson();
      final restored = CursorStateEntry.fromJson(json);
      expect(restored, entry);
    });
  });

  group('kCursorStates', () {
    test('contains all 8 states', () {
      expect(kCursorStates.length, 8);
      expect(kCursorStates.keys, containsAll([
        'arrow', 'pointer', 'ibeam', 'crosshair',
        'openHand', 'closedHand', 'resize', 'forbidden',
      ]));
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
