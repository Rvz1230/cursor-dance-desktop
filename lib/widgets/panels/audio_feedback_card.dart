import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/presets/preset_options.dart';
import '../base/panel_card.dart';
import '../base/panel_meta.dart';
import '../base/panel_divider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';
import '../controls/control_slider.dart';
import '../controls/wip_badge.dart';

class AudioFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const AudioFeedbackCard({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      id: 'audio',
      title: '音效反馈',
      meta: PanelMetaRegistry.audio,
      summary: config.sound ? config.soundFile : '未启用',
      badge: const WipBadge(),
      defaultOpen: false,
      child: Opacity(
        opacity: 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldRow(
              label: '音效开关',
              child: ShadSwitch(
                value: config.sound,
                onChanged: null,
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '音效文件',
              child: SmallSelect(
                value: config.soundFile,
                options: kSoundFileOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: null,
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '音量',
              child: ControlSlider(
                value: config.volume,
                min: 0,
                max: 100,
                suffix: '%',
                onChanged: null,
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '播放速率',
              child: ControlSlider(
                value: config.playbackRate,
                min: 50,
                max: 150,
                suffix: '%',
                onChanged: null,
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '淡出时长',
              child: ControlSlider(
                value: config.soundFadeOut,
                min: 0,
                max: 500,
                suffix: 'ms',
                onChanged: null,
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '延迟',
              child: ControlSlider(
                value: config.soundDelay,
                min: 0,
                max: 1000,
                divisions: 10,
                suffix: 'ms',
                onChanged: null,
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '触发模式',
              child: SmallSelect(
                value: config.soundTriggerMode,
                options: kSoundTriggerModeOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: null,
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '混音模式',
              child: SmallSelect(
                value: config.soundBlendMode,
                options: kSoundBlendModeOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
