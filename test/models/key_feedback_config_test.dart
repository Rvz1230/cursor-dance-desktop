import 'package:cursor_dance_desktop/models/key_feedback_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KeyFeedbackConfig', () {
    test('default constructor has expected defaults', () {
      const config = KeyFeedbackConfig();
      expect(config.enabled, false);
      expect(config.animationStyle, 'bounce');
      expect(config.originEdge, 'bottom');
      expect(config.fontSize, 16);
      expect(config.uppercase, true);
      expect(config.glow, false);
    });

    test('toJson → fromJson round-trip preserves all fields', () {
      const config = KeyFeedbackConfig(
        enabled: true,
        animationStyle: 'rain',
        originEdge: 'top',
        originMapping: 'colemak',
        globalOffsetX: 10.0,
        globalOffsetY: -30.0,
        fontSize: 20,
        fontWeight: 'bold',
        fontFamily: 'Menlo',
        color: '#FF0000',
        opacity: 80,
        uppercase: false,
        duration: 1000,
        easing: '弹性',
        scale: 1.5,
        bounceHeight: 80,
        gravity: 0.8,
        wind: 0.3,
        glow: true,
        glowColor: '#00FF00',
        glowRadius: 12.0,
        trail: true,
        trailLength: 5,
        splash: true,
        cooldownMs: 100,
        maxSimultaneous: 30,
        delay: 50,
      );

      final json = config.toJson();
      final restored = KeyFeedbackConfig.fromJson(json);
      expect(restored, config);
    });

    test('fromJson handles missing fields with defaults', () {
      final restored = KeyFeedbackConfig.fromJson({});
      expect(restored.enabled, false);
      expect(restored.animationStyle, 'bounce');
    });
  });
}
