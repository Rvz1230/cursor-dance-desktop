import 'package:flutter/material.dart';

/// ColorOptions — 色板选择器
///
/// 插件版风格: 预设色板圆点行，选中项以 2px foreground 边框高亮。
/// 支持 #RRGGBB 和 #AARRGGBB 格式。
class ColorOptions extends StatelessWidget {
  final String value;
  final List<String> swatches;
  final ValueChanged<String> onChanged;

  const ColorOptions({
    super.key,
    required this.value,
    required this.swatches,
    required this.onChanged,
  });

  Color _parse(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final swatch in swatches)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(swatch),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _parse(swatch),
                  shape: BoxShape.circle,
                  border: swatch == value
                      ? Border.all(color: const Color(0xFF0F172A), width: 2.5)
                      : Border.all(color: const Color(0xFFE2E8F0), width: 1),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
