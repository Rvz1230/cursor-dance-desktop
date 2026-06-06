import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import 'panels/animation_feedback_card.dart';
import 'panels/audio_feedback_card.dart';
import 'panels/cursor_feedback_card.dart';
import 'panels/image_feedback_card.dart';
import 'panels/panel_card.dart';
import 'panels/particle_feedback_card.dart';
import 'panels/ripple_feedback_card.dart';
import 'panels/text_feedback_card.dart';
import 'panels/trigger_behavior_card.dart';

class ConfigPanel extends StatelessWidget {
  final String actionId;
  final ActionConfig config;
  final List<String> conflicts;
  final void Function(ActionConfig Function(ActionConfig)) onUpdateConfig;

  const ConfigPanel({
    super.key,
    required this.actionId,
    required this.config,
    required this.conflicts,
    required this.onUpdateConfig,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final actionLabel = kActionLabels[actionId] ?? actionId;
    final actionHint = kActionHints[actionId] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Action header
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(actionLabel, style: theme.textTheme.h4),
              if (actionHint.isNotEmpty)
                Text(
                  actionHint,
                  style: theme.textTheme.small.copyWith(
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
            ],
          ),
        ),

        // Conflicts banner
        if (conflicts.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '待确认',
                  style: theme.textTheme.p.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                for (final conflict in conflicts)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      conflict,
                      style: theme.textTheme.small.copyWith(
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // Empty state
        if (!config.textEnabled &&
            !config.particle &&
            !config.ripple &&
            !config.sound &&
            !config.animationEnabled &&
            !config.imageEnabled &&
            conflicts.isEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.muted,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.border),
            ),
            child: Column(
              children: [
                Icon(LucideIcons.sparkles, size: 32, color: theme.colorScheme.mutedForeground),
                const SizedBox(height: 8),
                Text(
                  '还没有开启任何效果',
                  style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '展开下方的效果卡片，打开飘字、粒子、波纹或音效中的至少一项',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.small.copyWith(
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ),

        // Accordion panel cards
        ShadAccordion.multiple(
          initialValue: const ['trigger', 'text', 'particle', 'ripple', 'audio'],
          children: [
            PanelCard(
              id: 'trigger',
              title: const Text('触发行为'),
              defaultOpen: true,
              child: TriggerBehaviorCard(
                actionId: actionId,
                config: config,
                onUpdate: onUpdateConfig,
              ),
            ),
            PanelCard(
              id: 'text',
              title: const Text('飘字'),
              action: ShadSwitch(
                value: config.textEnabled,
                onChanged: (v) => onUpdateConfig((c) => c.copyWith(textEnabled: v)),
              ),
              child: TextFeedbackCard(
                config: config,
                onUpdate: onUpdateConfig,
              ),
            ),
            PanelCard(
              id: 'particle',
              title: const Text('粒子'),
              action: ShadSwitch(
                value: config.particle,
                onChanged: (v) => onUpdateConfig((c) => c.copyWith(particle: v)),
              ),
              child: ParticleFeedbackCard(
                config: config,
                onUpdate: onUpdateConfig,
              ),
            ),
            PanelCard(
              id: 'ripple',
              title: const Text('波纹'),
              action: ShadSwitch(
                value: config.ripple,
                onChanged: (v) => onUpdateConfig((c) => c.copyWith(ripple: v)),
              ),
              child: RippleFeedbackCard(
                config: config,
                onUpdate: onUpdateConfig,
              ),
            ),
            PanelCard(
              id: 'audio',
              title: const Text('音效'),
              action: ShadSwitch(
                value: config.sound,
                onChanged: (v) => onUpdateConfig((c) => c.copyWith(sound: v)),
              ),
              child: AudioFeedbackCard(
                config: config,
                onUpdate: onUpdateConfig,
              ),
            ),
            PanelCard(
              id: 'animation',
              title: const Text('动效'),
              action: ShadSwitch(
                value: config.animationEnabled,
                onChanged: (v) => onUpdateConfig((c) => c.copyWith(animationEnabled: v)),
              ),
              child: AnimationFeedbackCard(
                config: config,
                onUpdate: onUpdateConfig,
              ),
            ),
            PanelCard(
              id: 'image',
              title: const Text('图片'),
              action: ShadSwitch(
                value: config.imageEnabled,
                onChanged: (v) => onUpdateConfig((c) => c.copyWith(imageEnabled: v)),
              ),
              child: ImageFeedbackCard(
                config: config,
                onUpdate: onUpdateConfig,
              ),
            ),
            PanelCard(
              id: 'cursor',
              title: const Text('光标反馈'),
              child: CursorFeedbackCard(
                config: config,
                onUpdate: onUpdateConfig,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
