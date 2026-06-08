import 'package:flutter/material.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../../theme/app_tokens.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';
import '../panels/panel_card.dart';
import '../panels/panel_meta.dart';

/// 触发行为面板（始终展开，无开关）
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
      collapsible: false,
      child: Column(
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
          _divider(),
          FieldRow(
            label: '触发区域',
            child: SmallSelect(
              label: '触发区域',
              value: config.triggerZone,
              options: options['zones']!,
              onChanged: (v) => onUpdate((c) => c.copyWith(triggerZone: v)),
            ),
          ),
          _divider(),
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
      ),
    );
  }

  Widget _divider() {
    return Container(height: 1, color: AppColors.muted);
  }
}
