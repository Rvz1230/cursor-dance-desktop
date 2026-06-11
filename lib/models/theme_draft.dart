import 'package:freezed_annotation/freezed_annotation.dart';

import 'action_config.dart';
import 'theme.dart';

part 'theme_draft.freezed.dart';
part 'theme_draft.g.dart';

@freezed
class AtmosphereConfig with _$AtmosphereConfig {
  const factory AtmosphereConfig({
    @Default('none') String mode,
  }) = _AtmosphereConfig;

  factory AtmosphereConfig.fromJson(Map<String, dynamic> json) =>
      _$AtmosphereConfigFromJson(json);
}

@freezed
class CursorStateAsset with _$CursorStateAsset {
  const factory CursorStateAsset({
    @Default('') String imageDataUrl,
    @Default(16) int hotspotX,
    @Default(32) int hotspotY,
    @Default(48) int size,
  }) = _CursorStateAsset;

  factory CursorStateAsset.fromJson(Map<String, dynamic> json) =>
      _$CursorStateAssetFromJson(json);
}

/// ThemeDraft: per-theme full config including all actions.
///
/// Hand-written copyWith (not @freezed) because [ThemeDraft.create]
/// contains initialization logic.
class ThemeDraft {
  final Map<String, ActionConfig> actionConfigs;
  final Map<String, String> cursorModes;
  final Map<String, String> cursorStateActions;
  final Map<String, CursorStateAsset> cursorStateAssets;
  final AtmosphereConfig atmosphere;

  const ThemeDraft({
    required this.actionConfigs,
    this.cursorModes = const {},
    this.cursorStateActions = const {},
    this.cursorStateAssets = const {},
    this.atmosphere = const AtmosphereConfig(),
  });

  ThemeDraft copyWith({
    Map<String, ActionConfig>? actionConfigs,
    Map<String, String>? cursorModes,
    Map<String, String>? cursorStateActions,
    Map<String, CursorStateAsset>? cursorStateAssets,
    AtmosphereConfig? atmosphere,
  }) {
    return ThemeDraft(
      actionConfigs: actionConfigs ?? this.actionConfigs,
      cursorModes: cursorModes ?? this.cursorModes,
      cursorStateActions: cursorStateActions ?? this.cursorStateActions,
      cursorStateAssets: cursorStateAssets ?? this.cursorStateAssets,
      atmosphere: atmosphere ?? this.atmosphere,
    );
  }

  static ThemeDraft create(String themeId) {
    return ThemeDraft(
      actionConfigs: _defaultActionConfigs(themeId),
    );
  }
}

Map<String, ActionConfig> _defaultActionConfigs(String themeId) {
  return {
    for (final id in kActionIds) id: const ActionConfig(),
  };
}

const kActionIds = [
  'leftClick',
  'rightClick',
  'doubleClick',
  'longPress',
  'wheel',
  'hover',
];

const kActionLabels = {
  'leftClick': '左键单击',
  'rightClick': '右键单击',
  'doubleClick': '双击',
  'longPress': '长按',
  'wheel': '滚轮',
  'hover': '悬停',
};

const kActionHints = {
  'leftClick': '最常用的触发入口',
  'rightClick': '适合菜单或次要动作',
  'doubleClick': '更强的强调反馈',
  'longPress': '按住蓄力后触发',
  'wheel': '轻反馈和页面尾迹',
  'hover': '切状态或轻提示',
};

Map<String, ThemeDraft> buildDefaultDrafts() {
  return {
    for (final t in kBuiltinThemes) t.id: ThemeDraft.create(t.id),
  };
}

String buildThemeSummary(Map<String, ActionConfig> configs) {
  final enabled = configs.values.where((c) {
    return c.textEnabled || c.particle || c.ripple || c.sound ||
        c.animationEnabled || c.imageEnabled;
  }).length;
  return '$enabled 个动效';
}

List<String> conflictsForAction(
  String actionId,
  Map<String, ActionConfig> configs,
) {
  final current = configs[actionId];
  if (current == null) return [];
  final conflicts = <String>[];
  if (current.holdMs > 0 && current.triggerTiming == '抬起时') {
    conflicts.add('长按时长仅在"按下时"触发模式下有效');
  }
  return conflicts;
}
