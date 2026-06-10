import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/key_feedback_config.dart';
import '../../theme/app_tokens.dart';
import '../../theme/animations.dart';
import '../controls/color_options.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../base/panel_utils.dart';
import '../controls/small_select.dart';
import '../base/section_title.dart';
import '../base/panel_card.dart';
import '../base/panel_meta.dart';

const _kAnimationStyles = [
  ('bounce', '弹跳', '字符从底部弹跳而出，Q弹弹簧曲线'),
  ('raindrop', '雨滴', '字符如雨滴从顶部落下，带重力加速度'),
];

const _kOriginEdges = ['bottom', 'top', 'left', 'right'];
const _kOriginMappings = ['keyboardLayout', 'center'];
const _kEasingOptions = ['弹跳', '缓出', '缓入', '缓入缓出', '弹性', '线性'];
const _kFontWeights = ['标准', '中等', '半粗', '加粗'];
const _kFontFamilies = ['系统默认', 'SF Mono', 'SF Pro Rounded', 'Helvetica Neue'];

class KeyFeedbackCard extends StatelessWidget {
  final KeyFeedbackConfig config;
  final void Function(KeyFeedbackConfig Function(KeyFeedbackConfig)) onUpdate;

  const KeyFeedbackCard({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  String _buildSummary() {
    if (!config.enabled) return '已关闭';
    final styleName = _kAnimationStyles
        .firstWhere((s) => s.$1 == config.animationStyle,
            orElse: () => _kAnimationStyles.first)
        .$2;
    return '$styleName · ${config.fontSize}px · ${config.color}';
  }

  @override
  Widget build(BuildContext context) {
    final enabled = config.enabled;

    return PanelCard(
      id: 'keyFeedback',
      title: '键盘动效',
      meta: PanelMetaRegistry.keyboard,
      summary: _buildSummary(),
      action: ShadSwitch(
        value: enabled,
        onChanged: (v) => onUpdate((c) => c.copyWith(enabled: v)),
      ),
      collapsible: true,
      defaultOpen: enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Animation Style Picker ──
            const SectionTitle(title: '动画风格'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _kAnimationStyles.map((style) {
                final selected = config.animationStyle == style.$1;
                return _StyleChip(
                  label: style.$2,
                  description: style.$3,
                  selected: selected,
                  onTap: () => onUpdate(
                      (c) => c.copyWith(animationStyle: style.$1)),
                );
              }).toList(),
            ),

            const SizedBox(height: Spacing.xl),
            const SectionTitle(title: '动画参数'),
            FieldRow(
              label: '持续时长',
              child: ControlSlider(
                label: '持续时长',
                value: config.duration.toDouble(),
                min: 200,
                max: 2000,
                divisions: 18,
                suffix: 'ms',
                onChanged: (v) =>
                    onUpdate((c) => c.copyWith(duration: v.round())),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '缓动曲线',
              child: SmallSelect(
                label: '缓动曲线',
                value: config.easing,
                options: _kEasingOptions,
                onChanged: (v) => onUpdate((c) => c.copyWith(easing: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '字号大小',
              child: ControlSlider(
                label: '字号大小',
                value: config.fontSize.toDouble(),
                min: 16,
                max: 120,
                divisions: 26,
                suffix: 'px',
                onChanged: (v) =>
                    onUpdate((c) => c.copyWith(fontSize: v.round())),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '缩放倍率',
              child: ControlSlider(
                label: '缩放倍率',
                value: config.scale * 10,
                min: 5,
                max: 30,
                divisions: 25,
                suffix: 'x',
                onChanged: (v) =>
                    onUpdate((c) => c.copyWith(scale: v / 10)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '不透明度',
              child: ControlSlider(
                label: '不透明度',
                value: config.opacity.toDouble(),
                min: 10,
                max: 100,
                divisions: 9,
                suffix: '%',
                onChanged: (v) =>
                    onUpdate((c) => c.copyWith(opacity: v.round())),
              ),
            ),

            // ── Style-Specific Parameters ──
            if (config.animationStyle == 'bounce') ...[
              const SizedBox(height: Spacing.xl),
              const SectionTitle(title: '弹跳参数'),
              FieldRow(
                label: '弹跳高度',
                child: ControlSlider(
                  label: '弹跳高度',
                  value: config.bounceHeight.toDouble(),
                  min: 40,
                  max: 400,
                  divisions: 18,
                  suffix: 'px',
                  onChanged: (v) =>
                      onUpdate((c) => c.copyWith(bounceHeight: v.round())),
                ),
              ),
            ],
            if (config.animationStyle == 'raindrop') ...[
              const SizedBox(height: Spacing.xl),
              const SectionTitle(title: '雨滴参数'),
              FieldRow(
                label: '重力强度',
                child: ControlSlider(
                  label: '重力强度',
                  value: config.gravity * 10,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (v) =>
                      onUpdate((c) => c.copyWith(gravity: v / 10)),
                ),
              ),
              const PanelDivider(),
              FieldRow(
                label: '水平风力',
                child: ControlSlider(
                  label: '水平风力',
                  value: (config.wind + 1) * 5,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (v) =>
                      onUpdate((c) => c.copyWith(wind: v / 5 - 1)),
                ),
              ),
            ],

            // ── Position ──
            const SizedBox(height: Spacing.xl),
            const SectionTitle(title: '弹出位置'),
            FieldRow(
              label: '起始边缘',
              child: SmallSelect(
                label: '起始边缘',
                value: config.originEdge,
                options: _kOriginEdges,
                onChanged: (v) =>
                    onUpdate((c) => c.copyWith(originEdge: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '水平定位',
              child: SmallSelect(
                label: '水平定位',
                value: config.originMapping,
                options: _kOriginMappings,
                onChanged: (v) =>
                    onUpdate((c) => c.copyWith(originMapping: v)),
              ),
            ),
            if (config.originMapping == 'center') ...[
              const PanelDivider(),
              FieldRow(
                label: '水平偏移',
                child: ControlSlider(
                  label: '水平偏移',
                  value: config.globalOffsetX * 100,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  suffix: '%',
                  onChanged: (v) =>
                      onUpdate((c) => c.copyWith(globalOffsetX: v / 100)),
                ),
              ),
            ],

            // ── Text Style ──
            const SizedBox(height: Spacing.xl),
            const SectionTitle(title: '字符样式'),
            FieldRow(
              label: '颜色',
              child: ColorOptions(
                value: config.color,
                swatches: [
                  '#F59E0B',
                  '#10B981',
                  '#3B82F6',
                  '#EC4899',
                  '#8B5CF6',
                  '#F97316',
                ],
                onChanged: (v) => onUpdate((c) => c.copyWith(color: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '字体粗细',
              child: SmallSelect(
                label: '字体粗细',
                value: config.fontWeight,
                options: _kFontWeights,
                onChanged: (v) =>
                    onUpdate((c) => c.copyWith(fontWeight: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '字体',
              child: SmallSelect(
                label: '字体',
                value: config.fontFamily,
                options: _kFontFamilies,
                onChanged: (v) =>
                    onUpdate((c) => c.copyWith(fontFamily: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '强制大写',
              child: ShadSwitch(
                value: config.uppercase,
                onChanged: (v) =>
                    onUpdate((c) => c.copyWith(uppercase: v)),
              ),
            ),

            // ── Effects ──
            const SizedBox(height: Spacing.xl),
            const SectionTitle(title: '特效增强'),
            FieldRow(
              label: '发光',
              child: ShadSwitch(
                value: config.glow,
                onChanged: (v) =>
                    onUpdate((c) => c.copyWith(glow: v)),
              ),
            ),
            if (config.glow) ...[
              const PanelDivider(),
              FieldRow(
                label: '发光颜色',
                child: ColorOptions(
                  value: config.glowColor,
                  swatches: [
                    '#FBBF24',
                    '#F59E0B',
                    '#EC4899',
                    '#8B5CF6',
                    '#3B82F6',
                    '#10B981',
                  ],
                  onChanged: (v) =>
                      onUpdate((c) => c.copyWith(glowColor: v)),
                ),
              ),
              const PanelDivider(),
              FieldRow(
                label: '发光半径',
                child: ControlSlider(
                  label: '发光半径',
                  value: config.glowRadius,
                  min: 1,
                  max: 30,
                  divisions: 29,
                  suffix: 'px',
                  onChanged: (v) =>
                      onUpdate((c) => c.copyWith(glowRadius: v)),
                ),
              ),
            ],

            // ── Advanced ──
            const SizedBox(height: Spacing.xl),
            const SectionTitle(title: '高级'),
            FieldRow(
              label: '冷却时间',
              child: ControlSlider(
                label: '冷却时间',
                value: config.cooldownMs.toDouble(),
                min: 0,
                max: 500,
                divisions: 25,
                suffix: 'ms',
                onChanged: (v) =>
                    onUpdate((c) => c.copyWith(cooldownMs: v.round())),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '最大同显',
              child: ControlSlider(
                label: '最大同显',
                value: config.maxSimultaneous.toDouble(),
                min: 1,
                max: 50,
                divisions: 49,
                onChanged: (v) =>
                    onUpdate((c) => c.copyWith(maxSimultaneous: v.round())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small selectable chip for animation style.
class _StyleChip extends StatelessWidget {
  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _StyleChip({
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.normal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: Spacing.sm),
        decoration: BoxDecoration(
          color: selected
              ? cs.primary.withValues(alpha: 0.1)
              : cs.muted,
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          border: Border.all(
            color: selected ? cs.primary : cs.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          '$label — $description',
          style: TextStyle(
            fontSize: FontSizes.small,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            color: selected
                ? cs.primary
                : cs.mutedForeground,
          ),
        ),
      ),
    );
  }
}
