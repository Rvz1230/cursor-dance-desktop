import 'dart:convert';
import 'dart:io';

import 'package:cursor_dance_desktop/models/action_config.dart';
import 'package:cursor_dance_desktop/models/theme_draft.dart';
import 'package:flutter_test/flutter_test.dart';

/// Golden test: verifies that JSON contract fixtures match current model output.
///
/// If models change intentionally, delete the fixture files and re-run
/// to regenerate them.
void main() {
  final fixturesDir = Directory('test/fixtures');

  group('JSON contract fixtures', () {
    setUpAll(() {
      if (!fixturesDir.existsSync()) {
        fixturesDir.createSync(recursive: true);
      }
    });

    test('action_config_default.json matches ActionConfig().toJson()', () {
      const config = ActionConfig();
      final json = config.toJson();
      final pretty = const JsonEncoder.withIndent('  ').convert(json);

      final file = File('${fixturesDir.path}/action_config_default.json');
      _verifyGolden(file, pretty);
    });

    test('action_config_leftClick.json matches leftClick preset output', () {
      // Simulate what a leftClick config looks like after factory preset
      // merge (ActionConfig defaults + factory override)
      const config = ActionConfig(
        textKind: '数字飘字',
        textEnabled: true,
        textContent: '+1',
        textTags: ['功德 +1', '继续点击', '已触发'],
        textColor: '#B45309',
        textEasing: '弹跳',
        textWeight: '加粗',
        textShadow: '柔和',
        comboEnabled: true,
        textOffsetY: -28,
        particle: true,
        particleCount: 22,
        particleSpread: 62,
        particleStyle: '火花',
        particleDirection: '四周扩散',
        particleDuration: 780,
        particleSize: 14,
        particleOpacity: 88,
        particleGravity: 8,
        particleBounce: 14,
        ripple: true,
        rippleDuration: 860,
        rippleStyle: '回声环',
        rippleEasing: '缓出',
        rippleOpacity: 72,
        sound: true,
        soundFile: 'woodfish-soft.wav',
        volume: 72,
        soundFadeOut: 80,
        soundTriggerMode: '每次触发',
        shake: 48,
        cursorOverride: '木鱼（继承默认）',
        cursorTrailEnabled: true,
        cursorTrailCount: 4,
        cursorTrailOpacity: 36,
        cursorGlowColor: '#F59E0B',
      );
      final json = config.toJson();
      final pretty = const JsonEncoder.withIndent('  ').convert(json);

      final file = File('${fixturesDir.path}/action_config_leftClick.json');
      _verifyGolden(file, pretty);
    });

    test('theme_draft_full.json matches full ThemeDraft.toJson()', () {
      final draft = ThemeDraft(
        actionConfigs: {
          'leftClick': const ActionConfig(textEnabled: true, particle: true),
          'rightClick': const ActionConfig(ripple: true),
        },
        cursorModes: {'default': 'pointer'},
        cursorStateActions: {'click': 'leftClick'},
        cursorStateAssets: {
          'press': CursorStateAsset(
            imageDataUrl: 'data:image/png;base64,abc',
            hotspotX: 8,
            hotspotY: 16,
            size: 32,
          ),
        },
        atmosphere: const AtmosphereConfig(mode: 'rain'),
      );
      final json = draft.toJson();
      final pretty = const JsonEncoder.withIndent('  ').convert(json);

      final file = File('${fixturesDir.path}/theme_draft_full.json');
      _verifyGolden(file, pretty);
    });
  });
}

void _verifyGolden(File file, String current) {
  if (!file.existsSync()) {
    // First run: create the fixture
    file.writeAsStringSync(current);
    fail('Created fixture ${file.path} — re-run tests to verify');
  }

  final expected = file.readAsStringSync();
  if (current != expected) {
    // Write the actual output for diff comparison
    File('${file.path}.actual').writeAsStringSync(current);
    fail(
      'Fixture mismatch: ${file.path}\n'
      'Actual output written to ${file.path}.actual\n'
      'If intentional, delete ${file.path} and re-run.',
    );
  }

  // Clean up any stale .actual file
  final actualFile = File('${file.path}.actual');
  if (actualFile.existsSync()) {
    actualFile.deleteSync();
  }
}
