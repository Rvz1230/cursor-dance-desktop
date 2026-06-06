import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';

class CursorFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const CursorFeedbackCard({
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
          label: '光标覆盖',
          child: SmallSelect(
            label: '光标覆盖',
            value: config.cursorOverride,
            options: kCursorOverrideOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(cursorOverride: v)),
          ),
        ),
        FieldRow(
          label: '光标尺寸',
          child: SmallSelect(
            label: '光标尺寸',
            value: config.cursorSize.toString().length > 0
                ? '${config.cursorSize} × ${config.cursorSize}'
                : '48 × 48',
            options: kCursorSizeOptions,
            onChanged: (v) {
              final size = int.tryParse(v.split('×').first.trim()) ?? 48;
              onUpdate((c) => c.copyWith(cursorSize: size));
            },
          ),
        ),
        FieldRow(
          label: '启用拖尾',
          child: ShadSwitch(
            value: config.cursorTrailEnabled,
            onChanged: (v) => onUpdate((c) => c.copyWith(cursorTrailEnabled: v)),
          ),
        ),
        if (config.cursorTrailEnabled) ...[
          FieldRow(
            label: '拖尾数量',
            child: ControlSlider(
              label: '拖尾数量',
              value: config.cursorTrailCount.toDouble(),
              min: 1,
              max: 20,
              divisions: 19,
              onChanged: (v) => onUpdate((c) => c.copyWith(cursorTrailCount: v.round())),
            ),
          ),
          FieldRow(
            label: '拖尾透明度',
            child: ControlSlider(
              label: '拖尾透明度',
              value: config.cursorTrailOpacity.toDouble(),
              min: 10,
              max: 100,
              divisions: 9,
              suffix: '%',
              onChanged: (v) => onUpdate((c) => c.copyWith(cursorTrailOpacity: v.round())),
            ),
          ),
        ],
      ],
    );
  }
}
