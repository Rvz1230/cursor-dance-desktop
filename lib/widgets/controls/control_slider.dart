import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

/// 插件版 ControlSlider — 滑块 + 可编辑数值输入
class ControlSlider extends HookWidget {
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
    final controller = useTextEditingController(text: value.round().toString());
    final focusNode = useFocusNode();

    useEffect(() {
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          controller.text = value.round().toString();
        }
      });
      return null;
    }, [focusNode]);

    useEffect(() {
      if (!focusNode.hasFocus) {
        controller.text = value.round().toString();
      }
      return null;
    }, [value]);

    void onSubmitted(String text) {
      final parsed = double.tryParse(text);
      if (parsed != null) {
        onChanged(parsed.clamp(min, max));
      } else {
        controller.text = value.round().toString();
      }
      focusNode.unfocus();
    }

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
              label: '${value.round()}${suffix ?? ''}',
              onChanged: (v) {
                onChanged(v);
                if (!focusNode.hasFocus) {
                  controller.text = v.round().toString();
                }
              },
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: SizedBox(
              width: 56,
              child: Material(
                type: MaterialType.transparency,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: FontSizes.base,
                    fontWeight: FontWeight.w600,
                    fontFeatures: [FontFeature.tabularFigures()],
                    color: AppColors.foreground,
                    height: 1.2,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: onSubmitted,
                ),
              ),
            ),
          ),
          if (suffix != null)
            Padding(
              padding: const EdgeInsets.only(left: 1),
              child: Text(
                suffix!,
                style: const TextStyle(
                  fontSize: FontSizes.small,
                  color: AppColors.mutedForeground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
