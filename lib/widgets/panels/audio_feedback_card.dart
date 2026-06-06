import 'package:flutter/material.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldRow(
          label: '音效文件',
          child: SmallSelect(
            label: '音效文件',
            value: config.soundFile,
            options: kSoundFileOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(soundFile: v)),
          ),
        ),
        FieldRow(
          label: '音量',
          child: ControlSlider(
            label: '音量',
            value: config.volume.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            suffix: '%',
            onChanged: (v) => onUpdate((c) => c.copyWith(volume: v.round())),
          ),
        ),
        FieldRow(
          label: '播放速率',
          child: ControlSlider(
            label: '播放速率',
            value: config.playbackRate.toDouble(),
            min: 50,
            max: 150,
            divisions: 10,
            suffix: '%',
            onChanged: (v) => onUpdate((c) => c.copyWith(playbackRate: v.round())),
          ),
        ),
        FieldRow(
          label: '淡出时长',
          child: ControlSlider(
            label: '淡出时长',
            value: config.soundFadeOut.toDouble(),
            min: 0,
            max: 500,
            divisions: 10,
            suffix: 'ms',
            onChanged: (v) => onUpdate((c) => c.copyWith(soundFadeOut: v.round())),
          ),
        ),
        FieldRow(
          label: '触发模式',
          child: SmallSelect(
            label: '触发模式',
            value: config.soundTriggerMode,
            options: kAudioTriggerOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(soundTriggerMode: v)),
          ),
        ),
        FieldRow(
          label: '混音模式',
          child: SmallSelect(
            label: '混音模式',
            value: config.soundBlendMode,
            options: kAudioBlendOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(soundBlendMode: v)),
          ),
        ),
      ],
    );
  }
}
