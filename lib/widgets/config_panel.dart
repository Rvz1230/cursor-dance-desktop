import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../../theme/app_tokens.dart';
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
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                actionLabel,
                style: const TextStyle(
                  fontSize: FontSizes.h4,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
              if (actionHint.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    actionHint,
                    style: const TextStyle(
                      fontSize: FontSizes.small,
                      color: AppColors.mutedForeground,
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
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(RadiusTokens.lg),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.alertTriangle,
                      size: 14,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '待确认',
                      style: TextStyle(
                        fontSize: FontSizes.base,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                for (final conflict in conflicts)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      conflict,
                      style: const TextStyle(
                        fontSize: FontSizes.small,
                        color: AppColors.mutedForeground,
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
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(RadiusTokens.xl2),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(RadiusTokens.xl2),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    LucideIcons.wand2,
                    size: IconSizes.xl,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '还没有开启任何效果',
                  style: TextStyle(
                    fontSize: FontSizes.base,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '展开下方的效果卡片，打开飘字、粒子、波纹或音效中的至少一项即可看到预览变化。',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: FontSizes.small,
                      color: AppColors.mutedForeground,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _hintChip(LucideIcons.type, '飘字'),
                    const SizedBox(width: 8),
                    _hintChip(LucideIcons.waves, '粒子'),
                    const SizedBox(width: 8),
                    _hintChip(LucideIcons.circleDashed, '波纹'),
                    const SizedBox(width: 8),
                    _hintChip(LucideIcons.volume2, '音效'),
                  ],
                ),
              ],
            ),
          ),

        // Panel cards (each manages own collapse state)
        const SizedBox(height: 4),
        TriggerBehaviorCard(
          actionId: actionId,
          config: config,
          onUpdate: onUpdateConfig,
        ),
        const SizedBox(height: 8),
        TextFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ),
        const SizedBox(height: 8),
        ParticleFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ),
        const SizedBox(height: 8),
        RippleFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ),
        const SizedBox(height: 8),
        AudioFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ),
        const SizedBox(height: 8),
        AnimationFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ),
        const SizedBox(height: 8),
        ImageFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ),
        const SizedBox(height: 8),
        CursorFeedbackCard(
          config: config,
          onUpdate: onUpdateConfig,
        ),
      ],
    );
  }

  Widget _hintChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: IconSizes.xs, color: AppColors.mutedForeground),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: FontSizes.caption, color: AppColors.mutedForeground),
          ),
        ],
      ),
    );
  }
}
