import 'package:cursor_dance_desktop/models/theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeItem', () {
    test('toJson → fromJson round-trip', () {
      const item = ThemeItem(
        id: 'test',
        name: '测试主题',
        kind: '自定义',
        icon: 'Star',
        summary: '测试用',
        description: '测试描述',
      );
      final json = item.toJson();
      final restored = ThemeItem.fromJson(json);
      expect(restored, item);
    });

    test('fromJson uses defaults for missing fields', () {
      final restored = ThemeItem.fromJson({'id': 'x', 'name': 'y'});
      expect(restored.kind, '内置');
      expect(restored.icon, 'Wand2');
      expect(restored.summary, '');
    });

    test('kBuiltinThemes has 5 themes', () {
      expect(kBuiltinThemes.length, 5);
      expect(kBuiltinThemes.map((t) => t.id),
          ['amber', 'teal', 'slate', 'rose', 'sky']);
    });

    test('copyWith works', () {
      const item = ThemeItem(id: 'a', name: 'b');
      final renamed = item.copyWith(name: 'c');
      expect(renamed.name, 'c');
      expect(renamed.id, 'a');
    });
  });
}
