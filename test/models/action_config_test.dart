import 'dart:convert';

import 'package:cursor_dance_desktop/models/action_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActionConfig', () {
    test('default constructor has expected defaults', () {
      const config = ActionConfig();
      expect(config.triggerTiming, '抬起时');
      expect(config.textEnabled, false);
      expect(config.particle, false);
      expect(config.ripple, false);
      expect(config.sound, false);
      expect(config.animationEnabled, false);
      expect(config.imageEnabled, false);
      expect(config.cursorOverride, 'none');
      expect(config.comboEnabled, false);
    });

    test('toJson → fromJson round-trip preserves all fields', () {
      const config = ActionConfig(
        triggerTiming: '按下时',
        holdMs: 300,
        textEnabled: true,
        textKind: '数字飘字',
        particle: true,
        particleCount: 30,
        particleSpread: 80,
        particleStyle: '火花',
        particlePalette: ['#FF0000', '#00FF00'],
        ripple: true,
        rippleSize: 100,
        sound: true,
        soundFile: 'test.wav',
        animationEnabled: true,
        animationStyle: '缩放脉冲',
        imageEnabled: true,
        imageDataUrl: 'data:image/png;base64,abc',
        cursorOverride: 'custom',
        cursorSize: 48,
        shake: 20,
        comboEnabled: true,
        comboWindowMs: 1000,
      );

      final json = config.toJson();
      final restored = ActionConfig.fromJson(json);

      expect(restored, config);
    });

    test('fromJson handles missing fields with defaults', () {
      final restored = ActionConfig.fromJson({});
      expect(restored.triggerTiming, '抬起时');
      expect(restored.textEnabled, false);
      expect(restored.particle, false);
    });

    test('toJson produces valid JSON string', () {
      const config = ActionConfig(textEnabled: true, particle: true);
      final json = config.toJson();
      final encoded = jsonEncode(json);
      expect(encoded, isA<String>());
      expect(encoded, contains('textEnabled'));
      expect(encoded, contains('particle'));
    });

    test('equality works correctly', () {
      const a = ActionConfig(textEnabled: true, particle: true);
      const b = ActionConfig(textEnabled: true, particle: true);
      const c = ActionConfig(textEnabled: true, particle: false);
      expect(a, b);
      expect(a, isNot(c));
    });
  });
}
