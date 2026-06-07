import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../../theme/app_tokens.dart';
import '../controls/color_options.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';
import '../controls/config_section.dart';
import '../panels/panel_card.dart';
import '../panels/panel_meta.dart';

class AnimationFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const AnimationFeedbackCard({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  String _buildSummary() {
    return '${config.animationStyle} · ${config.animationDuration}ms';
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
    return PanelCard(
      id: 'animation',
      title: '动效反馈',
      meta: PanelMetaRegistry.animation,
      summary: _buildSummary(),
      badge: _wipBadge(),
      collapsible: true,
      defaultOpen: false,
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: '动效'),
          FieldRow(
            label: '动画样式',
            child: SmallSelect(
              label: '动画样式',
              value: config.animationStyle,
              options: kAnimationStyleOptions,
              onChanged: (v) => onUpdate((c) => c.copyWith(animationStyle: v)),
            ),
          ),
          _divider(),
          FieldRow(
            label: '持续时长',
            child: ControlSlider(
              label: '持续时长',
              value: config.animationDuration.toDouble(),
              min: 100,
              max: 2000,
              divisions: 19,
              suffix: 'ms',
              onChanged: (v) => onUpdate((c) => c.copyWith(animationDuration: v.round())),
            ),
          ),
          _divider(),
          FieldRow(
            label: '缓动',
            child: SmallSelect(
              label: '缓动',
              value: config.animationEasing,
              options: kAnimationEasingOptions,
              onChanged: (v) => onUpdate((c) => c.copyWith(animationEasing: v)),
            ),
          ),
          _divider(),
          FieldRow(
            label: '缩放',
            child: ControlSlider(
              label: '缩放',
              value: config.animationScale.toDouble(),
              min: 10,
              max: 200,
              divisions: 19,
              suffix: '%',
              onChanged: (v) => onUpdate((c) => c.copyWith(animationScale: v.round())),
            ),
          ),
          _divider(),
          FieldRow(
            label: '透明度',
            child: ControlSlider(
              label: '透明度',
              value: config.animationOpacity.toDouble(),
              min: 10,
              max: 100,
              divisions: 9,
              suffix: '%',
              onChanged: (v) => onUpdate((c) => c.copyWith(animationOpacity: v.round())),
            ),
          ),
          _divider(),
          FieldRow(
            label: '偏移 X',
            child: ControlSlider(
              label: '偏移 X',
              value: config.animationOffsetX.toDouble(),
              min: -100,
              max: 100,
              divisions: 20,
              suffix: 'px',
              onChanged: (v) => onUpdate((c) => c.copyWith(animationOffsetX: v.round())),
            ),
          ),
          _divider(),
          FieldRow(
            label: '偏移 Y',
            child: ControlSlider(
              label: '偏移 Y',
              value: config.animationOffsetY.toDouble(),
              min: -100,
              max: 100,
              divisions: 20,
              suffix: 'px',
              onChanged: (v) => onUpdate((c) => c.copyWith(animationOffsetY: v.round())),
            ),
          ),
          _divider(),
          FieldRow(
            label: '颜色',
            child: ColorOptions(
              value: config.animationColor,
              swatches: ['#F59E0B', '#F97316', '#14B8A6', '#7C3AED', '#BE185D', '#0284C7'],
              onChanged: (v) => onUpdate((c) => c.copyWith(animationColor: v)),
            ),
          ),
          _divider(),
          FieldRow(
            label: '辉光',
            child: ShadSwitch(
              value: config.animationGlow,
              onChanged: (v) => onUpdate((c) => c.copyWith(animationGlow: v)),
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
