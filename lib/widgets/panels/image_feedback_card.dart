import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../theme/tokens.dart';
import '../base/panel_card.dart';
import '../base/panel_meta.dart';
import '../base/panel_divider.dart';
import '../controls/field_row.dart';
import '../controls/control_slider.dart';
import '../controls/wip_badge.dart';

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
    final cs = ShadTheme.of(context).colorScheme;

    return PanelCard(
      id: 'image',
      title: '图片特效',
      meta: PanelMetaRegistry.image,
      summary: config.imageEnabled ? '${config.imageSize}px · ${config.imageDuration}ms' : '未启用',
      badge: const WipBadge(),
      defaultOpen: config.imageEnabled,
      action: ShadSwitch(
        value: config.imageEnabled,
        onChanged: (v) => onUpdate((c) => c.copyWith(imageEnabled: v)),
      ),
      child: Opacity(
        opacity: config.imageEnabled ? 1.0 : 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload placeholder
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: cs.muted,
                borderRadius: BorderRadius.circular(RadiusTokens.xl),
                border: Border.all(color: cs.border, width: 1, strokeAlign: BorderSide.strokeAlignInside),
              ),
              child: Center(
                child: Text(
                  '点击上传图片（需要原生文件选择器）',
                  style: TextStyle(
                    fontSize: FontSizes.small,
                    color: cs.mutedForeground,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            FieldRow(
              label: '显示时长',
              child: ControlSlider(
                value: config.imageDuration,
                min: 200,
                max: 3000,
                divisions: 14,
                suffix: 'ms',
                onChanged: (v) => onUpdate((c) => c.copyWith(imageDuration: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '尺寸',
              child: ControlSlider(
                value: config.imageSize,
                min: 16,
                max: 160,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(imageSize: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '透明度',
              child: ControlSlider(
                value: config.imageOpacity,
                min: 10,
                max: 100,
                suffix: '%',
                onChanged: (v) => onUpdate((c) => c.copyWith(imageOpacity: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '偏移 X',
              child: ControlSlider(
                value: config.imageOffsetX,
                min: -100,
                max: 100,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(imageOffsetX: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '偏移 Y',
              child: ControlSlider(
                value: config.imageOffsetY,
                min: -100,
                max: 100,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(imageOffsetY: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '延迟',
              child: ControlSlider(
                value: config.imageDelay,
                min: 0,
                max: 1000,
                divisions: 10,
                suffix: 'ms',
                onChanged: (v) => onUpdate((c) => c.copyWith(imageDelay: v)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
