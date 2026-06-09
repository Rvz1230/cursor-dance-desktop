import 'package:flutter/material.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';
import '../panels/panel_card.dart';
import '../panels/panel_meta.dart';

/// 触发行为面板 — 定义动作的触发条件、作用范围和延迟阈值
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

  String _buildSummary() {
    final options = kTriggerOptions[actionId] ?? kTriggerOptions['leftClick']!;
    final timingLabels = options['timing'] ?? [];
    final timing = timingLabels.contains(config.triggerTiming)
        ? config.triggerTiming
        : (timingLabels.isNotEmpty ? timingLabels.first : '');
    final zoneLabels = options['zones'] ?? [];
    final zone = zoneLabels.contains(config.triggerZone)
        ? config.triggerZone
        : (zoneLabels.isNotEmpty ? zoneLabels.first : '');
    return '$timing · $zone';
  }

  @override
  Widget build(BuildContext context) {
    final options = kTriggerOptions[actionId] ?? kTriggerOptions['leftClick']!;
    final timingMeta = timingFieldMeta(actionId);

    return PanelCard(
      id: 'trigger',
      title: '触发行为',
      meta: PanelMetaRegistry.trigger,
      summary: _buildSummary(),
      collapsible: true,
      defaultOpen: true,
      child: Column(
        children: [
          FieldRow(
            label: '触发时机',
            hint: '触发节点。',
            child: SmallSelect(
              label: '触发时机',
              value: config.triggerTiming,
              options: options['timing']!,
              onChanged: (v) => onUpdate((c) => c.copyWith(triggerTiming: v)),
            ),
          ),
          const SizedBox(height: 8),
          FieldRow(
            label: '作用范围',
            hint: '监听目标。',
            child: SmallSelect(
              label: '作用范围',
              value: config.triggerZone,
              options: options['zones']!,
              onChanged: (v) => onUpdate((c) => c.copyWith(triggerZone: v)),
            ),
          ),
          if (timingMeta.min != timingMeta.max) ...[
            const SizedBox(height: 8),
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
        ],
      ),
    );
  }
}
