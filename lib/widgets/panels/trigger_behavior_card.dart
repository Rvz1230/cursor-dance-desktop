import 'package:flutter/material.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';

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
    final options = kTriggerOptions[actionId] ?? kTriggerOptions['leftClick']!;
    final timingMeta = timingFieldMeta(actionId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldRow(
          label: '触发时机',
          child: SmallSelect(
            label: '触发时机',
            value: config.triggerTiming,
            options: options['timing']!,
            onChanged: (v) => onUpdate((c) => c.copyWith(triggerTiming: v)),
          ),
        ),
        FieldRow(
          label: '触发区域',
          child: SmallSelect(
            label: '触发区域',
            value: config.triggerZone,
            options: options['zones']!,
            onChanged: (v) => onUpdate((c) => c.copyWith(triggerZone: v)),
          ),
        ),
        FieldRow(
          label: timingMeta.label,
          hint: timingMeta.hint,
          child: ControlSlider(
            label: timingMeta.label,
            value: config.holdMs.toDouble(),
            min: timingMeta.min.toDouble(),
            max: timingMeta.max.toDouble(),
            divisions: ((timingMeta.max - timingMeta.min) / 10).round(),
            suffix: 'ms',
            onChanged: (v) => onUpdate((c) => c.copyWith(holdMs: v.round())),
          ),
        ),
      ],
    );
  }
}
