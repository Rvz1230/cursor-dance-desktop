import 'package:freezed_annotation/freezed_annotation.dart';

import 'action_config.dart';
import '../services/preset_loader.dart';

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
/// This is NOT freezed because [ThemeDraft.create] contains logic
/// (initializing cursor state defaults). copyWith is hand-written since
/// it uses a const constructor.
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

  factory ThemeDraft.create(String themeId) {
    return ThemeDraft(
      actionConfigs: PresetRepository.instance.defaultActionConfigs(themeId),
      cursorModes: {
        'default': '源',
        'pointer': '继承',
        'text': '继承',
        'help': '继承',
        'wait': '覆盖',
        'notAllowed': '继承',
      },
      cursorStateActions: {
        'default': 'leftClick',
        'pointer': 'leftClick',
        'text': 'leftClick',
        'help': 'leftClick',
        'wait': 'leftClick',
        'notAllowed': 'leftClick',
      },
      cursorStateAssets: {
        for (final stateId in ['default', 'pointer', 'text', 'help', 'wait', 'notAllowed'])
          stateId: const CursorStateAsset(),
      },
      atmosphere: const AtmosphereConfig(),
    );
  }
}

Map<String, ThemeDraft> buildDefaultDrafts() {
  return {
    for (final themeId in ['mono-geo', 'drift', 'molten', 'sunset'])
      themeId: ThemeDraft.create(themeId),
  };
}
