import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../theme/app_tokens.dart';
import '../base/section_title.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../base/panel_utils.dart';
import '../controls/wip_badge.dart';
import '../base/panel_card.dart';
import '../base/panel_meta.dart';

class ImageFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const ImageFeedbackCard({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  String _buildSummary() {
    if (!config.imageEnabled) return '已关闭';
    return '${config.imageSize}px · ${config.imageDuration}ms';
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final enabled = config.imageEnabled;

    return PanelCard(
      id: 'image',
      title: '图片贴纸',
      meta: PanelMetaRegistry.image,
      summary: _buildSummary(),
      badge: const WipBadge(),
      action: ShadSwitch(
        value: enabled,
        onChanged: (v) => onUpdate((c) => c.copyWith(imageEnabled: v)),
      ),
      collapsible: true,
      defaultOpen: enabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: cs.muted,
              borderRadius: BorderRadius.circular(RadiusTokens.xl),
              border: Border.all(color: cs.border),
            ),
            child: Column(
              children: [
                Icon(LucideIcons.imagePlus, size: 24, color: cs.mutedForeground),
                const SizedBox(height: 8),
                Text(
                  '图片贴纸需要在桌面版中通过文件选择器上传',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: FontSizes.small,
                    color: cs.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle(title: '参数'),
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
          const PanelDivider(),
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
          const PanelDivider(),
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
          const PanelDivider(),
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
          const PanelDivider(),
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
      ),
    );
  }
}
