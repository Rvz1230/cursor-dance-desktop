import 'package:cursor_dance_desktop/models/action_config.dart';
import 'package:cursor_dance_desktop/models/theme_draft.dart';
import 'package:cursor_dance_desktop/services/preset_loader.dart';
import 'package:flutter_test/flutter_test.dart';

const _factoryJson = '''
{
  "leftClick": {
    "textEnabled": true,
    "particle": true,
    "particleStyle": "火花",
    "particleCount": 22,
    "ripple": true
  },
  "rightClick": {
    "particle": false,
    "ripple": true,
    "fontSize": 18
  },
  "doubleClick": {},
  "longPress": {},
  "wheel": {},
  "hover": {}
}
''';

const _overrideJson = '''
{
  "amber": {
    "leftClick": {
      "particleStyle": "方块",
      "particleCount": 30
    },
    "rightClick": {
      "ripple": false
    }
  },
  "teal": {
    "leftClick": {
      "textEnabled": false
    }
  }
}
''';

void main() {
  group('PresetRepository', () {
    setUp(() {
      PresetRepository.instance.reset();
    });

    test('loadFromStrings populates data', () {
      PresetRepository.instance.loadFromStrings(_factoryJson, _overrideJson);
      expect(PresetRepository.instance.isLoaded, true);
    });

    test('presetForAction returns config for valid actionId', () {
      PresetRepository.instance.loadFromStrings(_factoryJson, _overrideJson);
      final config = PresetRepository.instance.presetForAction('leftClick');
      expect(config.textEnabled, true);
      expect(config.particle, true);
      expect(config.particleStyle, '火花');
    });

    test('presetForAction returns default for unknown actionId', () {
      PresetRepository.instance.loadFromStrings(_factoryJson, _overrideJson);
      final config = PresetRepository.instance.presetForAction('nonexistent');
      expect(config, const ActionConfig());
    });

    test('applyThemeOverrides merges overrides onto base', () {
      PresetRepository.instance.loadFromStrings(_factoryJson, _overrideJson);
      final base = const ActionConfig();
      final overridden =
          PresetRepository.instance.applyThemeOverrides(base, 'amber', 'leftClick');
      expect(overridden.particleStyle, '方块');
      expect(overridden.particleCount, 30);
    });

    test('applyThemeOverrides returns base when no overrides', () {
      PresetRepository.instance.loadFromStrings(_factoryJson, _overrideJson);
      final base = const ActionConfig();
      final result =
          PresetRepository.instance.applyThemeOverrides(base, 'nonexistent', 'leftClick');
      expect(result, base);
    });

    test('defaultActionConfigs returns configs for all action IDs', () {
      PresetRepository.instance.loadFromStrings(_factoryJson, _overrideJson);
      final configs = PresetRepository.instance.defaultActionConfigs('amber');
      expect(configs.length, kActionIds.length);
      for (final id in kActionIds) {
        expect(configs, contains(id));
      }
      expect(configs['leftClick']!.particleStyle, '方块');
      expect(configs['rightClick']!.ripple, false);
    });

    test('defaultActionConfigs for theme without overrides uses factory', () {
      PresetRepository.instance.loadFromStrings(_factoryJson, _overrideJson);
      final configs = PresetRepository.instance.defaultActionConfigs('slate');
      expect(configs['leftClick']!.textEnabled, true);
      expect(configs['leftClick']!.particleStyle, '火花');
    });
  });
}
