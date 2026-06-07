import 'package:flutter/material.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../../theme/app_tokens.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';
import '../controls/config_section.dart';
import '../panels/panel_card.dart';
import '../panels/panel_meta.dart';

class AudioFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const AudioFeedbackCard({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  String _buildSummary() {
    if (config.soundFile.isEmpty) return '未选择音效';
    return '${config.soundFile} · ${config.volume}%';
  }

  Widget _wipBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: const Text(
        '开发中',
        style: TextStyle(
          fontSize: FontSizes.caption,
          color: AppColors.warning,
          height: 1.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enabled = config.soundFile.isNotEmpty;

    return PanelCard(
      id: 'audio',
      title: '音效反馈',
      meta: PanelMetaRegistry.audio,
      summary: _buildSummary(),
      badge: _wipBadge(),
      collapsible: true,
      defaultOpen: enabled,
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: '音效'),
          FieldRow(
            label: '音效文件',
            child: SmallSelect(
              label: '音效文件',
              value: config.soundFile,
              options: kSoundFileOptions,
              onChanged: (v) => onUpdate((c) => c.copyWith(soundFile: v)),
            ),
          ),
          _divider(),
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
          _divider(),
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
          _divider(),
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
          _divider(),
          FieldRow(
            label: '触发模式',
            child: SmallSelect(
              label: '触发模式',
              value: config.soundTriggerMode,
              options: kAudioTriggerOptions,
              onChanged: (v) => onUpdate((c) => c.copyWith(soundTriggerMode: v)),
            ),
          ),
          _divider(),
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
      ),
    );
  }

  Widget _divider() {
    return Container(height: 1, color: const Color(0xFFF1F5F9));
  }
}
