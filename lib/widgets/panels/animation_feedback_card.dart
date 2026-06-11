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
import '../controls/color_options.dart';
import '../controls/wip_badge.dart';

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
    return PanelCard(
      id: 'animation',
      title: '动画特效',
      meta: PanelMetaRegistry.animation,
      summary: config.animationEnabled ? config.animationStyle : '未启用',
      badge: const WipBadge(),
      defaultOpen: false,
      action: ShadSwitch(
        value: config.animationEnabled,
        onChanged: (v) => onUpdate((c) => c.copyWith(animationEnabled: v)),
      ),
      child: Opacity(
        opacity: config.animationEnabled ? 1.0 : 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldRow(
              label: '动画样式',
              child: SmallSelect(
                value: config.animationStyle,
                options: kAnimationStyleOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(animationStyle: v));
                },
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '持续时长',
              child: ControlSlider(
                value: config.animationDuration,
                min: 100,
                max: 2000,
                divisions: 19,
                suffix: 'ms',
                onChanged: (v) => onUpdate((c) => c.copyWith(animationDuration: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '缓动',
              child: SmallSelect(
                value: config.animationEasing,
                options: kAnimationEasingOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(animationEasing: v));
                },
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '缩放',
              child: ControlSlider(
                value: config.animationScale,
                min: 10,
                max: 200,
                suffix: '%',
                onChanged: (v) => onUpdate((c) => c.copyWith(animationScale: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '透明度',
              child: ControlSlider(
                value: config.animationOpacity,
                min: 10,
                max: 100,
                suffix: '%',
                onChanged: (v) => onUpdate((c) => c.copyWith(animationOpacity: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '偏移 X',
              child: ControlSlider(
                value: config.animationOffsetX,
                min: -100,
                max: 100,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(animationOffsetX: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '偏移 Y',
              child: ControlSlider(
                value: config.animationOffsetY,
                min: -100,
                max: 100,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(animationOffsetY: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '颜色',
              child: ColorOptions(
                value: config.animationColor,
                onChanged: (v) => onUpdate((c) => c.copyWith(animationColor: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '辉光',
              child: ShadSwitch(
                value: config.animationGlow,
                onChanged: (v) => onUpdate((c) => c.copyWith(animationGlow: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '延迟',
              child: ControlSlider(
                value: config.animationDelay,
                min: 0,
                max: 1000,
                divisions: 10,
                suffix: 'ms',
                onChanged: (v) => onUpdate((c) => c.copyWith(animationDelay: v)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
