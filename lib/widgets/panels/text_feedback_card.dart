import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../controls/color_options.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';
import '../controls/config_section.dart';
import '../controls/text_tag_editor.dart';
import '../panels/panel_card.dart';
import '../panels/panel_meta.dart';

class TextFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const TextFeedbackCard({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  String _buildSummary() {
    if (!config.textEnabled) return '已关闭';
    return '${config.textKind} · ${config.fontSize}px · ${config.textColor}';
  }

  @override
  Widget build(BuildContext context) {
    final enabled = config.textEnabled;
    final isNumberKind = config.textKind == '数字飘字';

    return PanelCard(
      id: 'text',
      title: '飘字反馈',
      meta: PanelMetaRegistry.text,
      summary: _buildSummary(),
      action: ShadSwitch(
        value: enabled,
        onChanged: (v) => onUpdate((c) => c.copyWith(textEnabled: v)),
      ),
      collapsible: true,
      defaultOpen: enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: '内容'),
            FieldRow(
              label: '飘字类型',
              hint: '数字或文案。',
              child: SmallSelect(
                label: '飘字类型',
                value: config.textKind,
                options: kTextKindOptions,
                onChanged: (v) => onUpdate((c) => c.copyWith(textKind: v)),
              ),
            ),
            const SizedBox(height: 8),

            // ── 数字飘字专属字段 ──
            if (isNumberKind) ...[
              FieldRow(
                label: '数字样式',
                hint: '显示形式。',
                child: SmallSelect(
                  label: '数字样式',
                  value: config.textStyle,
                  options: kNumberStyleOptions,
                  onChanged: (v) => onUpdate((c) => c.copyWith(textStyle: v, textEnabled: true)),
                ),
              ),
              const SizedBox(height: 8),
              FieldRow(
                label: '数字模式',
                hint: '默认或模板。',
                child: SmallSelect(
                  label: '数字模式',
                  value: config.textMode,
                  options: kTextModeOptions,
                  onChanged: (v) => onUpdate((c) => c.copyWith(textMode: v, textEnabled: true)),
                ),
              ),
              if (config.textMode == '模板模式') ...[
                const SizedBox(height: 8),
                FieldRow(
                  label: '模板字符串',
                  hint: r'${number} 为占位符。',
                  child: ShadInput(
                    initialValue: config.textTemplate,
                    onChanged: (v) => onUpdate((c) => c.copyWith(textTemplate: v, textEnabled: true)),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              FieldRow(
                label: '连击累加',
                hint: '连续触发累加。',
                child: ShadSwitch(
                  value: config.comboEnabled,
                  onChanged: (v) => onUpdate((c) => c.copyWith(comboEnabled: v)),
                ),
              ),
              if (config.comboEnabled) ...[
                const SizedBox(height: 8),
                FieldRow(
                  label: '连击窗口',
                  hint: '多久以内算连续。',
                  child: ControlSlider(
                    label: '连击窗口',
                    value: config.comboWindowMs.toDouble(),
                    min: 120,
                    max: 3000,
                    divisions: 12,
                    suffix: 'ms',
                    onChanged: (v) => onUpdate((c) => c.copyWith(comboWindowMs: v.round())),
                  ),
                ),
              ],
            ],

            // ── 文本飘字专属字段 ──
            if (!isNumberKind) ...[
              FieldRow(
                label: '显示模式',
                hint: '顺序或随机。',
                child: SmallSelect(
                  label: '显示模式',
                  value: config.textTagPlayMode,
                  options: kTextTagPlayOptions,
                  onChanged: (v) => onUpdate((c) => c.copyWith(textTagPlayMode: v)),
                ),
              ),
              const SizedBox(height: 8),
              FieldRow(
                label: '标签内容',
                hint: '多条轮播。',
                child: TextTagEditor(
                  tags: config.textTags,
                  onChanged: (v) => onUpdate((c) => c.copyWith(
                    textTags: v,
                    textContent: v.isNotEmpty ? v.first : '',
                    textEnabled: true,
                  )),
                ),
              ),
            ],

            const SizedBox(height: 20),
            const SectionTitle(title: '动画'),
            FieldRow(
              label: '持续时长',
              hint: '显示时长。',
              child: ControlSlider(
                label: '持续时长',
                value: config.textDuration.toDouble(),
                min: 300,
                max: 1800,
                divisions: 10,
                suffix: 'ms',
                onChanged: (v) => onUpdate((c) => c.copyWith(textDuration: v.round())),
              ),
            ),
            const SizedBox(height: 8),
            FieldRow(
              label: '缓动效果',
              hint: '运动节奏。',
              child: SmallSelect(
                label: '缓动效果',
                value: config.textEasing,
                options: kTextEasingOptions,
                onChanged: (v) => onUpdate((c) => c.copyWith(textEasing: v)),
              ),
            ),
            const SizedBox(height: 8),
            FieldRow(
              label: '水平偏移',
              hint: '左右偏移。',
              child: ControlSlider(
                label: '水平偏移',
                value: config.textOffsetX.toDouble(),
                min: -24,
                max: 24,
                divisions: 12,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(textOffsetX: v.round())),
              ),
            ),
            const SizedBox(height: 8),
            FieldRow(
              label: '垂直偏移',
              hint: '上下偏移。',
              child: ControlSlider(
                label: '垂直偏移',
                value: config.textOffsetY.toDouble(),
                min: -48,
                max: 12,
                divisions: 12,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(textOffsetY: v.round())),
              ),
            ),

            const SizedBox(height: 20),
            const SectionTitle(title: '样式'),
            FieldRow(
              label: '飘字大小',
              hint: '字号。',
              child: ControlSlider(
                label: '飘字大小',
                value: config.fontSize.toDouble(),
                min: 14,
                max: 30,
                divisions: 8,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(fontSize: v.round())),
              ),
            ),
            const SizedBox(height: 8),
            FieldRow(
              label: '飘字字体',
              hint: '字体。',
              child: SmallSelect(
                label: '飘字字体',
                value: config.textFontFamily,
                options: kTextFontPresets,
                onChanged: (v) => onUpdate((c) => c.copyWith(textFontFamily: v)),
              ),
            ),
            const SizedBox(height: 8),
            FieldRow(
              label: '飘字颜色',
              hint: '颜色。',
              child: ColorOptions(
                value: config.textColor,
                swatches: ['#B45309', '#1E293B', '#475569', '#BE185D', '#0F766E', '#0284C7'],
                onChanged: (v) => onUpdate((c) => c.copyWith(textColor: v)),
              ),
            ),
            const SizedBox(height: 8),
            FieldRow(
              label: '透明度',
              hint: '透明度。',
              child: ControlSlider(
                label: '透明度',
                value: config.textOpacity.toDouble(),
                min: 20,
                max: 100,
                divisions: 8,
                suffix: '%',
                onChanged: (v) => onUpdate((c) => c.copyWith(textOpacity: v.round())),
              ),
            ),
            const SizedBox(height: 8),
            FieldRow(
              label: '字重',
              hint: '粗细。',
              child: SmallSelect(
                label: '字重',
                value: config.textWeight,
                options: kTextWeightOptions,
                onChanged: (v) => onUpdate((c) => c.copyWith(textWeight: v)),
              ),
            ),
            const SizedBox(height: 8),
            FieldRow(
              label: '描边',
              hint: '描边宽度。',
              child: ControlSlider(
                label: '描边',
                value: config.textOutlineWidth.toDouble(),
                min: 0,
                max: 3,
                divisions: 3,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(textOutlineWidth: v.round())),
              ),
            ),
            const SizedBox(height: 8),
            FieldRow(
              label: '阴影效果',
              hint: '阴影。',
              child: SmallSelect(
                label: '阴影效果',
                value: config.textShadow,
                options: kTextShadowOptions,
                onChanged: (v) => onUpdate((c) => c.copyWith(textShadow: v)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
