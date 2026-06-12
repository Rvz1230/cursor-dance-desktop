import 'package:freezed_annotation/freezed_annotation.dart';

import 'action_config.dart';

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

/// Single cursor state customization.
@freezed
class CursorStateEntry with _$CursorStateEntry {
  const factory CursorStateEntry({
    /// Relative path under cursordance/cursors/ (e.g. "arrow.png")
    @Default('') String imagePath,
    @Default('') String imageFormat,
    @Default(0) int hotspotX,
    @Default(0) int hotspotY,
    @Default(48) int size,
    @Default(false) bool isAnimated,
    @Default(0) int frameCount,
    @Default(0) int fps,
  }) = _CursorStateEntry;

  factory CursorStateEntry.fromJson(Map<String, dynamic> json) =>
      _$CursorStateEntryFromJson(json);
}

/// Fixed cursor state IDs and their labels.
const kCursorStates = <String, String>{
  'arrow': '默认箭头',
  'pointer': '指向手',
  'ibeam': '文本插入',
  'crosshair': '十字准星',
  'openHand': '抓取手',
  'closedHand': '拖拽中',
  'resize': '调整大小',
  'forbidden': '禁止',
};

/// ThemeDraft: per-theme full config including all actions.
///
/// Hand-written copyWith (not @freezed) because [ThemeDraft.create]
/// contains initialization logic.
class ThemeDraft {
  final Map<String, ActionConfig> actionConfigs;
  final Map<String, CursorStateEntry> cursorStates;
  final AtmosphereConfig atmosphere;

  const ThemeDraft({
    required this.actionConfigs,
    this.cursorStates = const {},
    this.atmosphere = const AtmosphereConfig(),
  });

  ThemeDraft copyWith({
    Map<String, ActionConfig>? actionConfigs,
    Map<String, CursorStateEntry>? cursorStates,
    AtmosphereConfig? atmosphere,
  }) {
    return ThemeDraft(
      actionConfigs: actionConfigs ?? this.actionConfigs,
      cursorStates: cursorStates ?? this.cursorStates,
      atmosphere: atmosphere ?? this.atmosphere,
    );
  }

  factory ThemeDraft.create(Map<String, ActionConfig> actionConfigs) {
    return ThemeDraft(actionConfigs: actionConfigs);
  }

  Map<String, dynamic> toJson() {
    return {
      'actionConfigs': actionConfigs.map((k, v) => MapEntry(k, v.toJson())),
      'atmosphere': atmosphere.toJson(),
      'cursorStates':
          cursorStates.map((k, v) => MapEntry(k, v.toJson())),
    };
  }

  factory ThemeDraft.fromJson(Map<String, dynamic> json) {
    final rawConfigs = json['actionConfigs'] as Map<String, dynamic>?;
    final actionConfigs = <String, ActionConfig>{};
    if (rawConfigs != null) {
      for (final entry in rawConfigs.entries) {
        actionConfigs[entry.key] =
            ActionConfig.fromJson(entry.value as Map<String, dynamic>);
      }
    }

    // Migrate old cursor fields if present
    Map<String, CursorStateEntry> cursorStates = {};
    final rawCursorStates = json['cursorStates'] as Map<String, dynamic>?;
    if (rawCursorStates != null) {
      cursorStates = rawCursorStates.map((k, v) => MapEntry(
          k, CursorStateEntry.fromJson(v as Map<String, dynamic>)));
    }

    return ThemeDraft(
      actionConfigs: actionConfigs,
      atmosphere: json['atmosphere'] != null
          ? AtmosphereConfig.fromJson(
              json['atmosphere'] as Map<String, dynamic>,
            )
          : const AtmosphereConfig(),
      cursorStates: cursorStates,
    );
  }
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
