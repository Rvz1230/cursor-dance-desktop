import 'package:flutter_test/flutter_test.dart';

import 'package:cursor_dance_desktop/models/action_config.dart';
import 'package:cursor_dance_desktop/models/theme_draft.dart';
import 'package:cursor_dance_desktop/models/theme.dart';

void main() {
  group('ActionConfig', () {
    test('default textEnabled is false', () {
      final config = ActionConfig();
      expect(config.textEnabled, false);
    });

    test('copyWith creates modified copy', () {
      final config = ActionConfig();
      final modified = config.copyWith(textEnabled: true);
      expect(config.textEnabled, false);
      expect(modified.textEnabled, true);
    });

    test('toJson / fromJson round-trip', () {
      final config = ActionConfig(
        textEnabled: true,
        textContent: '测试',
        particle: true,
        particleCount: 32,
      );
      final json = config.toJson();
      final restored = ActionConfig.fromJson(json);
      expect(restored.textEnabled, true);
      expect(restored.textContent, '测试');
      expect(restored.particle, true);
      expect(restored.particleCount, 32);
    });
  });

  group('ThemeItem', () {
    test('default kind is "自定义"', () {
      final item = ThemeItem(id: 'test', name: '测试');
      expect(item.kind, '自定义');
    });

    test('toJson / fromJson round-trip', () {
      final item = ThemeItem(
        id: 'test-1',
        name: '测试主题',
        kind: '内置',
        summary: '一个测试',
      );
      final json = item.toJson();
      final restored = ThemeItem.fromJson(json);
      expect(restored.id, 'test-1');
      expect(restored.name, '测试主题');
      expect(restored.kind, '内置');
    });

    test('copyWith creates modified copy', () {
      final item = ThemeItem(id: 'test', name: '原版');
      final modified = item.copyWith(name: '改版');
      expect(item.name, '原版');
      expect(modified.name, '改版');
    });
  });

  group('ThemeDraft', () {
    test('create builds a draft with action configs', () {
      final draft = ThemeDraft.create('drift');
      expect(draft.actionConfigs.isNotEmpty, true);
      expect(draft.actionConfigs.containsKey('leftClick'), true);
    });

    test('atmosphere defaults to manual mode', () {
      final draft = ThemeDraft.create('drift');
      expect(draft.atmosphere.mode, 'manual');
    });

    test('copyWith creates new draft', () {
      final draft = ThemeDraft.create('drift');
      final updated = draft.copyWith();
      expect(updated.actionConfigs.length, draft.actionConfigs.length);
    });
  });
}
