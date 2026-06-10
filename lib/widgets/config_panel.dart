import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../../theme/app_tokens.dart';
import '../../theme/animations.dart';
import 'panels/animation_feedback_card.dart';
import 'panels/audio_feedback_card.dart';
import 'panels/cursor_feedback_card.dart';
import 'panels/image_feedback_card.dart';
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
    final cs = ShadTheme.of(context).colorScheme;
    final actionLabel = kActionLabels[actionId] ?? actionId;
    final actionHint = kActionHints[actionId] ?? '';

    final hasAnyEffect = config.textEnabled ||
        config.particle ||
        config.ripple ||
        config.sound ||
        config.animationEnabled ||
        config.imageEnabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Action header
        Padding(
          padding: const EdgeInsets.only(left: Spacing.xs, bottom: Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                actionLabel,
                style: TextStyle(
                  fontSize: FontSizes.h4,
                  fontWeight: FontWeight.w600,
                  color: cs.foreground,
                ),
              ),
              if (actionHint.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: Spacing.xs),
                  child: Text(
                    actionHint,
                    style: TextStyle(
                      fontSize: FontSizes.small,
                      color: cs.mutedForeground,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Conflicts banner (amber tone)
        if (conflicts.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: Spacing.md),
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: cs.custom['warning']?.withValues(alpha: 0.08) ?? cs.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(RadiusTokens.lg),
              border: Border.all(
                color: cs.custom['warning']?.withValues(alpha: 0.2) ?? cs.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.alertTriangle,
                      size: IconSizes.md,
                      color: cs.custom['warning'] ?? cs.primary,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      '待确认',
                      style: TextStyle(
                        fontSize: FontSizes.base,
                        fontWeight: FontWeight.w600,
                        color: cs.custom['warning'] ?? cs.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                for (final conflict in conflicts)
                  Padding(
                    padding: const EdgeInsets.only(top: Spacing.xs),
                    child: Text(
                      conflict,
                      style: TextStyle(
                        fontSize: FontSizes.small,
                        color: cs.mutedForeground,
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // Empty state
        if (!hasAnyEffect && conflicts.isEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: Spacing.lg),
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: Spacing.xl),
            decoration: BoxDecoration(
              color: cs.muted,
              borderRadius: BorderRadius.circular(RadiusTokens.xl2),
              border: Border.all(color: cs.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: cs.card,
                    borderRadius: BorderRadius.circular(RadiusTokens.xl2),
                    border: Border.all(color: cs.border),
                  ),
                  child: Icon(
                    LucideIcons.wand2,
                    size: IconSizes.xl,
                    color: cs.mutedForeground,
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                Text(
                  '还没有开启任何效果',
                  style: TextStyle(
                    fontSize: FontSizes.base,
                    fontWeight: FontWeight.w600,
                    color: cs.foreground,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                  child: Text(
                    '展开下方的效果卡片，打开飘字、粒子、波纹或音效中的至少一项即可看到预览变化。',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: FontSizes.small,
                      color: cs.mutedForeground,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _hintChip(cs, LucideIcons.type, '飘字'),
                    const SizedBox(width: Spacing.sm),
                    _hintChip(cs, LucideIcons.waves, '粒子'),
                    const SizedBox(width: Spacing.sm),
                    _hintChip(cs, LucideIcons.circleDashed, '波纹'),
                    const SizedBox(width: Spacing.sm),
                    _hintChip(cs, LucideIcons.volume2, '音效'),
                  ],
                ),
              ],
            ),
          ),

        // Panel cards (each manages own collapse state)
        const SizedBox(height: Spacing.xs),
        TriggerBehaviorCard(
          actionId: actionId,
          config: config,
          onUpdate: onUpdateConfig,
        ).animate().fadeIn(duration: AppAnimations.normal).slideX(begin: 0.03, duration: AppAnimations.normal),
        const SizedBox(height: Spacing.sm),
        TextFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ).animate(delay: 30.ms).fadeIn(duration: AppAnimations.normal).slideX(begin: 0.03, duration: AppAnimations.normal),
        const SizedBox(height: Spacing.sm),
        ParticleFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ).animate(delay: 60.ms).fadeIn(duration: AppAnimations.normal).slideX(begin: 0.03, duration: AppAnimations.normal),
        const SizedBox(height: Spacing.sm),
        RippleFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ).animate(delay: 90.ms).fadeIn(duration: AppAnimations.normal).slideX(begin: 0.03, duration: AppAnimations.normal),
        const SizedBox(height: Spacing.sm),
        AudioFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ).animate(delay: 120.ms).fadeIn(duration: AppAnimations.normal).slideX(begin: 0.03, duration: AppAnimations.normal),
        const SizedBox(height: Spacing.sm),
        AnimationFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ).animate(delay: 150.ms).fadeIn(duration: AppAnimations.normal).slideX(begin: 0.03, duration: AppAnimations.normal),
        const SizedBox(height: Spacing.sm),
        ImageFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ).animate(delay: 180.ms).fadeIn(duration: AppAnimations.normal).slideX(begin: 0.03, duration: AppAnimations.normal),
        const SizedBox(height: Spacing.sm),
        CursorFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ).animate(delay: 210.ms).fadeIn(duration: AppAnimations.normal).slideX(begin: 0.03, duration: AppAnimations.normal),
      ],
    );
  }

  Widget _hintChip(ShadColorScheme cs, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: cs.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: IconSizes.xs, color: cs.mutedForeground),
          const SizedBox(width: Spacing.xs),
          Text(
            label,
            style: TextStyle(fontSize: FontSizes.caption, color: cs.mutedForeground),
          ),
        ],
      ),
    );
  }
}
