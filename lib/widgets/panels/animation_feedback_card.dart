import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../controls/color_options.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';

class AnimationFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const AnimationFeedbackCard({
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
          label: '动画样式',
          child: SmallSelect(
            label: '动画样式',
            value: config.animationStyle,
            options: kAnimationStyleOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(animationStyle: v)),
          ),
        ),
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
        FieldRow(
          label: '缓动',
          child: SmallSelect(
            label: '缓动',
            value: config.animationEasing,
            options: kAnimationEasingOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(animationEasing: v)),
          ),
        ),
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
        FieldRow(
          label: '颜色',
          child: ColorOptions(
            value: config.animationColor,
            swatches: ['#F59E0B', '#F97316', '#14B8A6', '#7C3AED', '#BE185D', '#0284C7'],
            onChanged: (v) => onUpdate((c) => c.copyWith(animationColor: v)),
          ),
        ),
        FieldRow(
          label: '辉光',
          child: ShadSwitch(
            value: config.animationGlow,
            onChanged: (v) => onUpdate((c) => c.copyWith(animationGlow: v)),
          ),
        ),
      ],
    );
  }
}
