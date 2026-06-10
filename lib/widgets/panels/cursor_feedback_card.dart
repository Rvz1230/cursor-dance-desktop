import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../base/panel_utils.dart';
import '../controls/small_select.dart';
import '../base/panel_card.dart';
import '../base/panel_meta.dart';

/// Cursor 反馈（无独立开关，随动）
class CursorFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const CursorFeedbackCard({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  String _buildSummary() {
    return '${config.cursorOverride} · ${config.cursorSize}×${config.cursorSize}';
  }

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      id: 'cursor',
      title: '光标反馈',
      meta: PanelMetaRegistry.cursor,
      summary: _buildSummary(),
      collapsible: false,
      child: Column(
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
          const PanelDivider(),
          FieldRow(
            label: '光标尺寸',
            child: SmallSelect(
              label: '光标尺寸',
              value: config.cursorSize.toString().isNotEmpty
                  ? '${config.cursorSize} × ${config.cursorSize}'
                  : '48 × 48',
              options: kCursorSizeOptions,
              onChanged: (v) {
                final size = int.tryParse(v.split('×').first.trim()) ?? 48;
                onUpdate((c) => c.copyWith(cursorSize: size));
              },
            ),
          ),
          const PanelDivider(),
          FieldRow(
            label: '启用拖尾',
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
                label: '拖尾数量',
                value: config.cursorTrailCount.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                onChanged: (v) => onUpdate((c) => c.copyWith(cursorTrailCount: v.round())),
              ),
            ),
            const PanelDivider(),
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
      ),
    );
  }
}
