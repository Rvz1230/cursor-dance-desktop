import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/presets/preset_options.dart';
import '../../theme/tokens.dart';
import '../base/panel_card.dart';
import '../base/panel_meta.dart';
import '../base/panel_divider.dart';
import '../base/section_title.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';
import '../controls/control_slider.dart';
import '../controls/color_options.dart';

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
    return PanelCard(
      id: 'ripple',
      title: '波纹反馈',
      meta: PanelMetaRegistry.ripple,
      summary: config.ripple ? '${config.rippleStyle} · ${config.rippleDuration}ms' : '未启用',
      defaultOpen: config.ripple,
      action: ShadSwitch(
        value: config.ripple,
        onChanged: (v) => onUpdate((c) => c.copyWith(ripple: v)),
      ),
      child: Opacity(
        opacity: config.ripple ? 1.0 : 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: '形态'),
            FieldRow(
              label: '波纹样式',
              child: SmallSelect(
                value: config.rippleStyle,
                options: kRippleStyleOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(rippleStyle: v));
                },
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '颜色',
              child: ColorOptions(
                value: config.rippleColor,
                onChanged: (v) => onUpdate((c) => c.copyWith(rippleColor: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '波纹大小',
              child: ControlSlider(
                value: config.rippleSize,
                min: 12,
                max: 160,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(rippleSize: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '线宽',
              child: ControlSlider(
                value: config.rippleLineWidth,
                min: 1,
                max: 8,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(rippleLineWidth: v)),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            const SectionTitle(title: '消退'),
            FieldRow(
              label: '持续时长',
              child: ControlSlider(
                value: config.rippleDuration,
                min: 200,
                max: 2000,
                divisions: 9,
                suffix: 'ms',
                onChanged: (v) => onUpdate((c) => c.copyWith(rippleDuration: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '缓动',
              child: SmallSelect(
                value: config.rippleEasing,
                options: kRippleEasingOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(rippleEasing: v));
                },
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '不透明度',
              child: ControlSlider(
                value: config.rippleOpacity,
                min: 10,
                max: 100,
                suffix: '%',
                onChanged: (v) => onUpdate((c) => c.copyWith(rippleOpacity: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '延迟',
              child: ControlSlider(
                value: config.rippleDelay,
                min: 0,
                max: 1000,
                divisions: 10,
                suffix: 'ms',
                onChanged: (v) => onUpdate((c) => c.copyWith(rippleDelay: v)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
