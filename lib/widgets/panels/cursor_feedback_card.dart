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
    return PanelCard(
      id: 'cursor',
      title: '光标反馈',
      meta: PanelMetaRegistry.cursor,
      summary: config.cursorOverride == 'none' ? '无覆盖' : config.cursorOverride,
      collapsible: true,
      defaultOpen: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldRow(
            label: '光标覆盖',
            child: SmallSelect(
              value: config.cursorOverride,
              options: kCursorOverrideOptions.map((o) => SelectOption(value: o, label: o == 'none' ? '无' : o)).toList(),
              onChanged: (v) {
                if (v != null) onUpdate((c) => c.copyWith(cursorOverride: v));
              },
            ),
          ),
          const PanelDivider(),
          FieldRow(
            label: '光标尺寸',
            child: SmallSelect(
              value: config.cursorSize.toString(),
              options: kCursorSizeOptions.map((o) => SelectOption(value: o, label: '$o × $o')).toList(),
              onChanged: (v) {
                if (v != null) onUpdate((c) => c.copyWith(cursorSize: int.parse(v)));
              },
            ),
          ),
          const PanelDivider(),
          FieldRow(
            label: '拖尾效果',
            child: ShadSwitch(
              value: config.cursorTrailEnabled,
              onChanged: (v) => onUpdate((c) => c.copyWith(cursorTrailEnabled: v)),
            ),
          ),
          if (config.cursorTrailEnabled) ...[
            const PanelDivider(),
            FieldRow(
              label: '拖尾数量',
              child: ControlSlider(
                value: config.cursorTrailCount,
                min: 1,
                max: 20,
                onChanged: (v) => onUpdate((c) => c.copyWith(cursorTrailCount: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '拖尾透明度',
              child: ControlSlider(
                value: config.cursorTrailOpacity,
                min: 5,
                max: 100,
                suffix: '%',
                onChanged: (v) => onUpdate((c) => c.copyWith(cursorTrailOpacity: v)),
              ),
            ),
          ],
          const PanelDivider(),
          FieldRow(
            label: '抖动强度',
            hint: '0 = 无抖动',
            child: ControlSlider(
              value: config.shake,
              min: 0,
              max: 20,
              onChanged: (v) => onUpdate((c) => c.copyWith(shake: v)),
            ),
          ),
        ],
      ),
    );
  }
}
