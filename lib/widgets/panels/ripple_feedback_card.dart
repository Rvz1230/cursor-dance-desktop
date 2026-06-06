import 'package:flutter/material.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../controls/color_options.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';

class RippleFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const RippleFeedbackCard({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 形态 ──
        FieldRow(
          label: '波纹样式',
          child: SmallSelect(
            label: '波纹样式',
            value: config.rippleStyle,
            options: kRippleStyleOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(rippleStyle: v)),
          ),
        ),
        FieldRow(
          label: '颜色',
          child: ColorOptions(
            value: config.rippleColor,
            swatches: ['#F59E0B', '#334155', '#14B8A6', '#F97316', '#FB7185', '#0284C7'],
            onChanged: (v) => onUpdate((c) => c.copyWith(rippleColor: v)),
          ),
        ),
        FieldRow(
          label: '波纹大小',
          child: ControlSlider(
            label: '波纹大小',
            value: config.rippleSize.toDouble(),
            min: 12,
            max: 160,
            divisions: 18,
            suffix: 'px',
            onChanged: (v) => onUpdate((c) => c.copyWith(rippleSize: v.round())),
          ),
        ),
        FieldRow(
          label: '线宽',
          child: ControlSlider(
            label: '线宽',
            value: config.rippleLineWidth.toDouble(),
            min: 1,
            max: 8,
            divisions: 7,
            suffix: 'px',
            onChanged: (v) => onUpdate((c) => c.copyWith(rippleLineWidth: v.round())),
          ),
        ),

        // ── 消退 ──
        FieldRow(
          label: '持续时长',
          child: ControlSlider(
            label: '持续时长',
            value: config.rippleDuration.toDouble(),
            min: 200,
            max: 2000,
            divisions: 18,
            suffix: 'ms',
            onChanged: (v) => onUpdate((c) => c.copyWith(rippleDuration: v.round())),
          ),
        ),
        FieldRow(
          label: '缓动',
          child: SmallSelect(
            label: '缓动',
            value: config.rippleEasing,
            options: kRippleEasingOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(rippleEasing: v)),
          ),
        ),
        FieldRow(
          label: '不透明度',
          child: ControlSlider(
            label: '不透明度',
            value: config.rippleOpacity.toDouble(),
            min: 10,
            max: 100,
            divisions: 9,
            suffix: '%',
            onChanged: (v) => onUpdate((c) => c.copyWith(rippleOpacity: v.round())),
          ),
        ),
      ],
    );
  }
}
