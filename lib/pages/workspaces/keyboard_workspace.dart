import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/key_feedback_config.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_tokens.dart';
import '../../theme/animations.dart';
import '../../widgets/base/panel_meta.dart';
import '../../widgets/base/status_indicator.dart';
import '../../widgets/panels/key_feedback_card.dart';

class KeyboardWorkspace extends StatelessWidget {
  const KeyboardWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final config = theme.keyFeedbackConfig;
    final cs = ShadTheme.of(context).colorScheme;

    return Column(
      children: [
        _buildHeader(cs),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusBanner(cs, config, theme),
                const SizedBox(height: Spacing.lg),
                _buildStylePickerCard(cs, config, theme),
                const SizedBox(height: Spacing.lg),
                KeyFeedbackCard(
                  config: config,
                  onUpdate: (fn) {
                    theme.updateKeyFeedbackConfig(fn(config));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ShadColorScheme cs) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      decoration: BoxDecoration(
        color: cs.card,
        border: Border(
          bottom: BorderSide(color: cs.border),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: PanelMetaRegistry.keyboard.bg,
              borderRadius: BorderRadius.circular(RadiusTokens.md),
            ),
            child: const Icon(
              LucideIcons.keyboard,
              size: 16,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(width: Spacing.md),
          Text(
            '键盘动效配置',
            style: TextStyle(
              fontSize: FontSizes.base,
              fontWeight: FontWeight.w600,
              color: cs.foreground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(ShadColorScheme cs, KeyFeedbackConfig config, ThemeProvider theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: Spacing.md),
      decoration: BoxDecoration(
        color: config.enabled
            ? (cs.custom['success']?.withValues(alpha: 0.08) ?? const Color(0xFFECFDF5))
            : cs.muted,
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        border: Border.all(
          color: config.enabled
              ? (cs.custom['success']?.withValues(alpha: 0.3) ?? const Color(0xFF6EE7B7))
              : cs.border,
        ),
      ),
      child: Row(
        children: [
          StatusIndicator(
            active: config.enabled,
            label: config.enabled ? '键盘动效已启用 — 按下任意键查看效果' : '键盘动效已停用',
          ),
          const Spacer(),
          ShadSwitch(
            value: config.enabled,
            onChanged: (v) =>
                theme.updateKeyFeedbackConfig(config.copyWith(enabled: v)),
          ),
        ],
      ),
    );
  }

  Widget _buildStylePickerCard(ShadColorScheme cs, KeyFeedbackConfig config, ThemeProvider theme) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        border: Border.all(color: cs.border.withAlpha(204)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '动画风格',
            style: TextStyle(
              fontSize: FontSizes.base,
              fontWeight: FontWeight.w600,
              color: cs.foreground,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            '选择按键后字符在屏幕上的动画表现方式',
            style: TextStyle(
              fontSize: FontSizes.small,
              color: cs.mutedForeground,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              _styleCard(
                cs: cs,
                icon: LucideIcons.snail,
                label: '弹跳',
                description: 'Q弹弹簧物理曲线',
                selected: config.animationStyle == 'bounce',
                onTap: () {
                  if (config.animationStyle != 'bounce') {
                    theme.updateKeyFeedbackConfig(
                        config.copyWith(animationStyle: 'bounce'));
                  }
                },
              ),
              const SizedBox(width: Spacing.md),
              _styleCard(
                cs: cs,
                icon: LucideIcons.cloudRain,
                label: '雨滴',
                description: '从顶部落下带重力感',
                selected: config.animationStyle == 'raindrop',
                onTap: () {
                  if (config.animationStyle != 'raindrop') {
                    theme.updateKeyFeedbackConfig(
                        config.copyWith(animationStyle: 'raindrop'));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _styleCard({
    required ShadColorScheme cs,
    required IconData icon,
    required String label,
    required String description,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppAnimations.normal,
          padding: const EdgeInsets.all(Spacing.lg),
          decoration: BoxDecoration(
            color:
                selected ? cs.primary.withValues(alpha: 0.06) : cs.muted,
            borderRadius: BorderRadius.circular(RadiusTokens.xl),
            border: Border.all(
              color: selected ? cs.primary : cs.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: selected ? cs.primary : cs.mutedForeground,
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                label,
                style: TextStyle(
                  fontSize: FontSizes.base,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: selected ? cs.primary : cs.foreground,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                description,
                style: TextStyle(
                  fontSize: FontSizes.caption,
                  color: cs.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
