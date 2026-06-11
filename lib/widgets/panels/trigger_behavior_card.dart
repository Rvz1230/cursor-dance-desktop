import 'package:flutter/material.dart';

import '../../models/action_config.dart';
import '../../models/presets/preset_options.dart';
import '../../models/presets/timing_meta.dart';
import '../base/panel_card.dart';
import '../base/panel_meta.dart';
import '../base/panel_divider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';
import '../controls/control_slider.dart';

class TriggerBehaviorCard extends StatelessWidget {
  final String actionId;
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const TriggerBehaviorCard({
    super.key,
    required this.actionId,
    required this.config,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final meta = timingFieldMeta(actionId);
    final timingOpts = kTriggerTimingOptions[actionId] ?? ['抬起时'];
    final zoneOpts = kTriggerZoneOptions[actionId] ?? ['当前页面可点击区域'];

    return PanelCard(
      id: 'trigger',
      title: '触发行为',
      meta: PanelMetaRegistry.trigger,
      summary: '${config.triggerTiming} · ${config.triggerZone}',
      defaultOpen: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (meta.showTiming)
            FieldRow(
              label: '触发时机',
              child: SmallSelect(
                value: config.triggerTiming,
                options: timingOpts.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(triggerTiming: v));
                },
              ),
            ),
          if (meta.showTiming && meta.showZone) const PanelDivider(),
          if (meta.showZone)
            FieldRow(
              label: '作用范围',
              child: SmallSelect(
                value: config.triggerZone,
                options: zoneOpts.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(triggerZone: v));
                },
              ),
            ),
          if (meta.showZone && meta.showHold) const PanelDivider(),
          if (meta.showHold)
            FieldRow(
              label: '长按时长',
              hint: '0 = 立即触发',
              child: ControlSlider(
                value: config.holdMs,
                min: 0,
                max: 2000,
                divisions: 20,
                suffix: 'ms',
                onChanged: (v) => onUpdate((c) => c.copyWith(holdMs: v)),
              ),
            ),
        ],
      ),
    );
  }
}
