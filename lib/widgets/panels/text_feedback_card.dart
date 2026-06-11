import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/presets/preset_options.dart';
import '../../theme/tokens.dart';
import '../base/panel_card.dart';
import '../base/panel_meta.dart';
import '../base/panel_divider.dart';
import '../base/section_title.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';
import '../controls/control_slider.dart';
import '../controls/color_options.dart';
import '../controls/text_tag_editor.dart';

class TextFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const TextFeedbackCard({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  bool get _isNumberKind => config.textKind == '数字飘字';

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      id: 'text',
      title: '飘字反馈',
      meta: PanelMetaRegistry.text,
      summary: config.textEnabled ? '${config.textKind} · ${config.textDuration}ms' : '未启用',
      defaultOpen: config.textEnabled,
      action: ShadSwitch(
        value: config.textEnabled,
        onChanged: (v) => onUpdate((c) => c.copyWith(textEnabled: v)),
      ),
      child: Opacity(
        opacity: config.textEnabled ? 1.0 : 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: '内容'),
            FieldRow(
              label: '飘字类型',
              child: SmallSelect(
                value: config.textKind,
                options: kTextKindOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(textKind: v));
                },
              ),
            ),
            if (_isNumberKind) ...[
              const PanelDivider(),
              FieldRow(
                label: '数字样式',
                child: SmallSelect(
                  value: config.textStyle,
                  options: kTextStyleOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                  onChanged: (v) {
                    if (v != null) onUpdate((c) => c.copyWith(textStyle: v));
                  },
                ),
              ),
              const PanelDivider(),
              FieldRow(
                label: '数字模式',
                child: SmallSelect(
                  value: config.textMode,
                  options: kTextModeOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                  onChanged: (v) {
                    if (v != null) onUpdate((c) => c.copyWith(textMode: v));
                  },
                ),
              ),
              if (config.textMode == '模板模式') ...[
                const PanelDivider(),
                FieldRow(
                  label: '模板字符串',
                  hint: '用 \${number} 代表数字',
                  child: ShadInput(
                    initialValue: config.textTemplate,
                    onChanged: (v) => onUpdate((c) => c.copyWith(textTemplate: v)),
                    placeholder: const Text(r'${number}'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: 4,
                    ),
                  ),
                ),
              ],
              const PanelDivider(),
              FieldRow(
                label: '连击累加',
                child: ShadSwitch(
                  value: config.comboEnabled,
                  onChanged: (v) => onUpdate((c) => c.copyWith(comboEnabled: v)),
                ),
              ),
              if (config.comboEnabled) ...[
                const PanelDivider(),
                FieldRow(
                  label: '连击窗口',
                  child: ControlSlider(
                    value: config.comboWindowMs,
                    min: 120,
                    max: 3000,
                    divisions: 14,
                    suffix: 'ms',
                    onChanged: (v) => onUpdate((c) => c.copyWith(comboWindowMs: v)),
                  ),
                ),
              ],
            ],
            if (!_isNumberKind) ...[
              const PanelDivider(),
              FieldRow(
                label: '显示模式',
                child: SmallSelect(
                  value: config.textTagPlayMode,
                  options: kTextTagPlayModeOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                  onChanged: (v) {
                    if (v != null) onUpdate((c) => c.copyWith(textTagPlayMode: v));
                  },
                ),
              ),
              const PanelDivider(),
              FieldRow(
                label: '标签内容',
                child: TextTagEditor(
                  tags: config.textTags,
                  onChanged: (v) => onUpdate((c) => c.copyWith(textTags: v)),
                ),
              ),
            ],
            const SizedBox(height: Spacing.lg),
            const SectionTitle(title: '动画'),
            FieldRow(
              label: '持续时长',
              child: ControlSlider(
                value: config.textDuration,
                min: 300,
                max: 1800,
                divisions: 15,
                suffix: 'ms',
                onChanged: (v) => onUpdate((c) => c.copyWith(textDuration: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '缓动效果',
              child: SmallSelect(
                value: config.textEasing,
                options: kTextEasingOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(textEasing: v));
                },
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '水平偏移',
              child: ControlSlider(
                value: config.textOffsetX,
                min: -24,
                max: 24,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(textOffsetX: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '垂直偏移',
              child: ControlSlider(
                value: config.textOffsetY,
                min: -48,
                max: 12,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(textOffsetY: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '延迟',
              child: ControlSlider(
                value: config.textDelay,
                min: 0,
                max: 1000,
                divisions: 10,
                suffix: 'ms',
                onChanged: (v) => onUpdate((c) => c.copyWith(textDelay: v)),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            const SectionTitle(title: '样式'),
            FieldRow(
              label: '飘字大小',
              child: ControlSlider(
                value: config.fontSize,
                min: 14,
                max: 30,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(fontSize: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '飘字字体',
              child: SmallSelect(
                value: config.textFontFamily,
                options: kTextFontFamilyOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(textFontFamily: v));
                },
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '飘字颜色',
              child: ColorOptions(
                value: config.textColor,
                onChanged: (v) => onUpdate((c) => c.copyWith(textColor: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '透明度',
              child: ControlSlider(
                value: config.textOpacity,
                min: 20,
                max: 100,
                suffix: '%',
                onChanged: (v) => onUpdate((c) => c.copyWith(textOpacity: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '字重',
              child: SmallSelect(
                value: config.textWeight,
                options: kTextWeightOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(textWeight: v));
                },
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '描边',
              child: ControlSlider(
                value: config.textOutlineWidth,
                min: 0,
                max: 3,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(textOutlineWidth: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '阴影效果',
              child: SmallSelect(
                value: config.textShadow,
                options: kTextShadowOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(textShadow: v));
                },
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '渐变色',
              child: ShadSwitch(
                value: config.textGradient,
                onChanged: (v) => onUpdate((c) => c.copyWith(textGradient: v)),
              ),
            ),
            if (config.textGradient) ...[
              const PanelDivider(),
              FieldRow(
                label: '渐变起始',
                child: ColorOptions(
                  value: config.textGradientStart,
                  onChanged: (v) => onUpdate((c) => c.copyWith(textGradientStart: v)),
                ),
              ),
              const PanelDivider(),
              FieldRow(
                label: '渐变结束',
                child: ColorOptions(
                  value: config.textGradientEnd,
                  onChanged: (v) => onUpdate((c) => c.copyWith(textGradientEnd: v)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
