import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/action_config.dart';
import '../models/theme_draft.dart';
import '../theme/tokens.dart';
import 'panels/trigger_behavior_card.dart';
import 'panels/text_feedback_card.dart';
import 'panels/particle_feedback_card.dart';
import 'panels/ripple_feedback_card.dart';
import 'panels/audio_feedback_card.dart';
import 'panels/animation_feedback_card.dart';
import 'panels/image_feedback_card.dart';

class ConfigPanel extends StatelessWidget {
  final String actionId;
  final ActionConfig config;
  final List<String> conflicts;
  final ValueChanged<ActionConfig Function(ActionConfig)> onUpdateConfig;

  const ConfigPanel({
    super.key,
    required this.actionId,
    required this.config,
    required this.conflicts,
    required this.onUpdateConfig,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Action header
        Padding(
          padding: const EdgeInsets.only(bottom: Spacing.md),
          child: Row(
            children: [
              Text(
                kActionLabels[actionId] ?? actionId,
                style: TextStyle(
                  fontSize: FontSizes.h3,
                  fontWeight: FontWeight.w600,
                  color: cs.foreground,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                kActionHints[actionId] ?? '',
                style: TextStyle(
                  fontSize: FontSizes.small,
                  color: cs.mutedForeground,
                ),
              ),
            ],
          ),
        ),
        // Conflicts
        if (conflicts.isNotEmpty) ...[
          _ConflictBanner(conflicts: conflicts),
          const SizedBox(height: Spacing.md),
        ],
        // Cards
        TriggerBehaviorCard(actionId: actionId, config: config, onUpdate: onUpdateConfig),
        const SizedBox(height: Spacing.md),
        TextFeedbackCard(config: config, onUpdate: onUpdateConfig),
        const SizedBox(height: Spacing.md),
        ParticleFeedbackCard(config: config, onUpdate: onUpdateConfig),
        const SizedBox(height: Spacing.md),
        RippleFeedbackCard(config: config, onUpdate: onUpdateConfig),
        const SizedBox(height: Spacing.md),
        AudioFeedbackCard(config: config, onUpdate: onUpdateConfig),
        const SizedBox(height: Spacing.md),
        AnimationFeedbackCard(config: config, onUpdate: onUpdateConfig),
        const SizedBox(height: Spacing.md),
        ImageFeedbackCard(config: config, onUpdate: onUpdateConfig),
        const SizedBox(height: Spacing.xl),
      ],
    );
  }
}

class _ConflictBanner extends StatelessWidget {
  final List<String> conflicts;

  const _ConflictBanner({required this.conflicts});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: cs.custom['warning']?.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        border: Border.all(color: cs.custom['warning']?.withValues(alpha: 0.3) ?? cs.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final c in conflicts)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.xs),
              child: Row(
                children: [
                  Icon(LucideIcons.alertTriangle, size: IconSizes.md, color: cs.custom['warning']),
                  const SizedBox(width: Spacing.xs),
                  Expanded(
                    child: Text(
                      c,
                      style: TextStyle(fontSize: FontSizes.small, color: cs.foreground),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
