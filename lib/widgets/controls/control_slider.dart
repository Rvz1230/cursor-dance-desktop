import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

/// 插件版 ControlSlider — 滑块 + 数值
///
/// 匹配插件版 WorkbenchControls.tsx:
///   rounded-xl border border-slate-200 bg-slate-50 px-2 py-2
class ControlSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? suffix;
  final ValueChanged<double> onChanged;

  const ControlSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: ShadSlider(
              initialValue: value,
              min: min,
              max: max,
              divisions: divisions,
              label: '${value.round()}$suffix',
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 48,
            child: Text(
              '${value.round()}$suffix',
              style: const TextStyle(
                fontSize: FontSizes.base,
                fontWeight: FontWeight.w600,
                fontFeatures: [FontFeature.tabularFigures()],
                color: AppColors.foreground,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
