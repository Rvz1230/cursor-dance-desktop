import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../controls/color_options.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';
import '../controls/text_tag_editor.dart';

class TextFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const TextFeedbackCard({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 内容 ──
        _sectionHeader(theme, '内容'),
        FieldRow(
          label: '飘字类型',
          child: SmallSelect(
            label: '飘字类型',
            value: config.textKind,
            options: kTextKindOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(textKind: v)),
          ),
        ),
        FieldRow(
          label: '计数样式',
          child: SmallSelect(
            label: '计数样式',
            value: config.textStyle,
            options: kNumberStyleOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(textStyle: v)),
          ),
        ),
        FieldRow(
          label: '模式',
          child: SmallSelect(
            label: '模式',
            value: config.textMode,
            options: kTextModeOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(textMode: v)),
          ),
        ),
        if (config.textMode == '模板模式')
          FieldRow(
            label: '模板',
            child: ShadInput(
              initialValue: config.textTemplate,
              onChanged: (v) => onUpdate((c) => c.copyWith(textTemplate: v)),
            ),
          ),
        FieldRow(
          label: '默认文字',
          child: ShadInput(
            initialValue: config.textContent,
            onChanged: (v) => onUpdate((c) => c.copyWith(textContent: v)),
          ),
        ),
        FieldRow(
          label: '标签库',
          child: TextTagEditor(
            tags: config.textTags,
            onChanged: (v) => onUpdate((c) => c.copyWith(textTags: v)),
          ),
        ),
        FieldRow(
          label: '标签模式',
          child: SmallSelect(
            label: '标签模式',
            value: config.textTagPlayMode,
            options: kTextTagPlayOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(textTagPlayMode: v)),
          ),
        ),
        FieldRow(
          label: '连击',
          child: ShadSwitch(
            value: config.comboEnabled,
            onChanged: (v) => onUpdate((c) => c.copyWith(comboEnabled: v)),
          ),
        ),
        if (config.comboEnabled)
          FieldRow(
            label: '连击窗口',
            child: ControlSlider(
              label: '连击窗口',
              value: config.comboWindowMs.toDouble(),
              min: 200,
              max: 2000,
              divisions: 9,
              suffix: 'ms',
              onChanged: (v) => onUpdate((c) => c.copyWith(comboWindowMs: v.round())),
            ),
          ),

        const SizedBox(height: 8),

        // ── 样式 ──
        _sectionHeader(theme, '样式'),
        FieldRow(
          label: '颜色',
          child: ColorOptions(
            value: config.textColor,
            swatches: ['#B45309', '#1E293B', '#475569', '#BE185D', '#0F766E', '#0284C7'],
            onChanged: (v) => onUpdate((c) => c.copyWith(textColor: v)),
          ),
        ),
        FieldRow(
          label: '字号',
          child: ControlSlider(
            label: '字号',
            value: config.fontSize.toDouble(),
            min: 10,
            max: 48,
            divisions: 19,
            suffix: 'px',
            onChanged: (v) => onUpdate((c) => c.copyWith(fontSize: v.round())),
          ),
        ),
        FieldRow(
          label: '字重',
          child: SmallSelect(
            label: '字重',
            value: config.textWeight,
            options: kTextWeightOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(textWeight: v)),
          ),
        ),
        FieldRow(
          label: '描边',
          child: ControlSlider(
            label: '描边',
            value: config.textOutlineWidth.toDouble(),
            min: 0,
            max: 4,
            divisions: 4,
            suffix: 'px',
            onChanged: (v) => onUpdate((c) => c.copyWith(textOutlineWidth: v.round())),
          ),
        ),
        FieldRow(
          label: '阴影',
          child: SmallSelect(
            label: '阴影',
            value: config.textShadow,
            options: kTextShadowOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(textShadow: v)),
          ),
        ),
        FieldRow(
          label: '字体',
          child: SmallSelect(
            label: '字体',
            value: config.textFontFamily,
            options: kTextFontPresets,
            onChanged: (v) => onUpdate((c) => c.copyWith(textFontFamily: v)),
          ),
        ),

        const SizedBox(height: 8),

        // ── 动效 ──
        _sectionHeader(theme, '动效'),
        FieldRow(
          label: '持续时长',
          child: ControlSlider(
            label: '持续时长',
            value: config.textDuration.toDouble(),
            min: 200,
            max: 3000,
            divisions: 14,
            suffix: 'ms',
            onChanged: (v) => onUpdate((c) => c.copyWith(textDuration: v.round())),
          ),
        ),
        FieldRow(
          label: '缓动',
          child: SmallSelect(
            label: '缓动',
            value: config.textEasing,
            options: kTextEasingOptions,
            onChanged: (v) => onUpdate((c) => c.copyWith(textEasing: v)),
          ),
        ),
        FieldRow(
          label: '透明度',
          child: ControlSlider(
            label: '透明度',
            value: config.textOpacity.toDouble(),
            min: 10,
            max: 100,
            divisions: 9,
            suffix: '%',
            onChanged: (v) => onUpdate((c) => c.copyWith(textOpacity: v.round())),
          ),
        ),
        FieldRow(
          label: '偏移 X',
          child: ControlSlider(
            label: '偏移 X',
            value: config.textOffsetX.toDouble(),
            min: -100,
            max: 100,
            divisions: 20,
            suffix: 'px',
            onChanged: (v) => onUpdate((c) => c.copyWith(textOffsetX: v.round())),
          ),
        ),
        FieldRow(
          label: '偏移 Y',
          child: ControlSlider(
            label: '偏移 Y',
            value: config.textOffsetY.toDouble(),
            min: -100,
            max: 100,
            divisions: 20,
            suffix: 'px',
            onChanged: (v) => onUpdate((c) => c.copyWith(textOffsetY: v.round())),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(ShadThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 2),
      child: Text(
        title,
        style: theme.textTheme.small.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.mutedForeground,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
