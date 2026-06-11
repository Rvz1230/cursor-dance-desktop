import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme.freezed.dart';
part 'theme.g.dart';

@freezed
class ThemeItem with _$ThemeItem {
  const factory ThemeItem({
    required String id,
    required String name,
    @Default('内置') String kind,
    @Default('Wand2') String icon,
    @Default('') String summary,
    @Default('') String description,
  }) = _ThemeItem;

  factory ThemeItem.fromJson(Map<String, dynamic> json) =>
      _$ThemeItemFromJson(json);
}

const kBuiltinThemes = <ThemeItem>[
  ThemeItem(id: 'amber', name: '琥珀', kind: '内置', icon: 'Flame', summary: '温暖活力的琥珀色调'),
  ThemeItem(id: 'teal', name: '翠绿', kind: '内置', icon: 'Leaf', summary: '清新自然的翠绿色调'),
  ThemeItem(id: 'slate', name: '石板灰', kind: '内置', icon: 'Mountain', summary: '沉稳内敛的石板灰色调'),
  ThemeItem(id: 'rose', name: '玫瑰', kind: '内置', icon: 'Heart', summary: '热情浪漫的玫瑰色调'),
  ThemeItem(id: 'sky', name: '天空', kind: '内置', icon: 'CloudSun', summary: '澄澈明亮的天空色调'),
];
