import 'action_config.dart';
import '../services/preset_loader.dart';

class AtmosphereConfig {
  final String mode; // "none", "subtle", "medium", "intense"

  const AtmosphereConfig({this.mode = 'none'});

  AtmosphereConfig copyWith({String? mode}) {
    return AtmosphereConfig(mode: mode ?? this.mode);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AtmosphereConfig && mode == other.mode;

  @override
  int get hashCode => mode.hashCode;
}

class CursorStateAsset {
  final String imageDataUrl;
  final int hotspotX;
  final int hotspotY;
  final int size;

  const CursorStateAsset({
    this.imageDataUrl = '',
    this.hotspotX = 16,
    this.hotspotY = 32,
    this.size = 48,
  });

  CursorStateAsset copyWith({
    String? imageDataUrl,
    int? hotspotX,
    int? hotspotY,
    int? size,
  }) {
    return CursorStateAsset(
      imageDataUrl: imageDataUrl ?? this.imageDataUrl,
      hotspotX: hotspotX ?? this.hotspotX,
      hotspotY: hotspotY ?? this.hotspotY,
      size: size ?? this.size,
    );
  }

  Map<String, dynamic> toJson() => {
    'imageDataUrl': imageDataUrl,
    'hotspotX': hotspotX,
    'hotspotY': hotspotY,
    'size': size,
  };

  factory CursorStateAsset.fromJson(Map<String, dynamic> json) {
    return CursorStateAsset(
      imageDataUrl: json['imageDataUrl'] as String? ?? '',
      hotspotX: json['hotspotX'] as int? ?? 16,
      hotspotY: json['hotspotY'] as int? ?? 32,
      size: json['size'] as int? ?? 48,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CursorStateAsset &&
          imageDataUrl == other.imageDataUrl &&
          hotspotX == other.hotspotX &&
          hotspotY == other.hotspotY &&
          size == other.size;

  @override
  int get hashCode => Object.hash(imageDataUrl, hotspotX, hotspotY, size);
}

class ThemeDraft {
  final Map<String, ActionConfig> actionConfigs;
  final Map<String, String> cursorModes; // stateId -> "源" | "继承" | "覆盖"
  final Map<String, String> cursorStateActions; // stateId -> actionId
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
