import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';

class ImageFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const ImageFeedbackCard({
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.muted,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.border, style: BorderStyle.solid),
          ),
          child: Column(
            children: [
              Icon(LucideIcons.imagePlus, size: 24, color: theme.colorScheme.mutedForeground),
              const SizedBox(height: 8),
              Text(
                '图片贴纸需要在桌面版中通过文件选择器上传',
                textAlign: TextAlign.center,
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FieldRow(
          label: '显示时长',
          child: ControlSlider(
            label: '显示时长',
            value: config.imageDuration.toDouble(),
            min: 200,
            max: 3000,
            divisions: 14,
            suffix: 'ms',
            onChanged: (v) => onUpdate((c) => c.copyWith(imageDuration: v.round())),
          ),
        ),
        FieldRow(
          label: '尺寸',
          child: ControlSlider(
            label: '尺寸',
            value: config.imageSize.toDouble(),
            min: 16,
            max: 160,
            divisions: 18,
            suffix: 'px',
            onChanged: (v) => onUpdate((c) => c.copyWith(imageSize: v.round())),
          ),
        ),
        FieldRow(
          label: '透明度',
          child: ControlSlider(
            label: '透明度',
            value: config.imageOpacity.toDouble(),
            min: 10,
            max: 100,
            divisions: 9,
            suffix: '%',
            onChanged: (v) => onUpdate((c) => c.copyWith(imageOpacity: v.round())),
          ),
        ),
        FieldRow(
          label: '偏移 X',
          child: ControlSlider(
            label: '偏移 X',
            value: config.imageOffsetX.toDouble(),
            min: -100,
            max: 100,
            divisions: 20,
            suffix: 'px',
            onChanged: (v) => onUpdate((c) => c.copyWith(imageOffsetX: v.round())),
          ),
        ),
        FieldRow(
          label: '偏移 Y',
          child: ControlSlider(
            label: '偏移 Y',
            value: config.imageOffsetY.toDouble(),
            min: -100,
            max: 100,
            divisions: 20,
            suffix: 'px',
            onChanged: (v) => onUpdate((c) => c.copyWith(imageOffsetY: v.round())),
          ),
        ),
      ],
    );
  }
}
