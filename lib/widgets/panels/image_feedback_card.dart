import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../theme/app_tokens.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/config_section.dart';
import '../controls/wip_badge.dart';
import '../panels/panel_card.dart';
import '../panels/panel_meta.dart';

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
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload placeholder
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(RadiusTokens.xl),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Icon(LucideIcons.imagePlus, size: 24, color: AppColors.mutedForeground),
                  const SizedBox(height: 8),
                  Text(
                    '图片贴纸需要在桌面版中通过文件选择器上传',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: FontSizes.small,
                      color: AppColors.mutedForeground,
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
            _divider(),
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
            _divider(),
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
            _divider(),
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
            _divider(),
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
      ),
    );
  }

  Widget _divider() {
    return Container(height: 1, color: AppColors.muted);
  }
}
