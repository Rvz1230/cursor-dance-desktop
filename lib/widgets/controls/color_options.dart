import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

Color _parseHex(String hex) {
  hex = hex.replaceFirst('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}

String _formatColor(Color color) {
  final str = color.toARGB32().toRadixString(16).padLeft(8, '0');
  return '#${str.substring(2).toUpperCase()}';
}

/// Color picker using FlexColorPicker.
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

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final currentColor = _parseHex(value);
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: ClipRect(
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: Spacing.sm),
              decoration: BoxDecoration(
                color: currentColor,
                shape: BoxShape.circle,
                border: Border.all(color: cs.border, width: 1),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: FontSizes.caption,
                fontWeight: FontWeight.w500,
                color: currentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) async {
    final swatchColors = swatches.map((h) => _parseHex(h)).toList();

    final customSwatches = <ColorSwatch<Object>, String>{};
    if (swatchColors.isNotEmpty) {
      customSwatches[ColorSwatch(swatchColors.first.toARGB32(), {
        for (int i = 0; i < swatchColors.length; i++) i: swatchColors[i],
      })] = '预设';
    }

    Color color = _parseHex(value);

    final result = await showShadDialog<Color>(
      context: context,
      builder: (ctx) => ShadDialog(
        child: ColorPicker(
          color: color,
          onColorChanged: (c) => color = c,
          pickersEnabled: const <ColorPickerType, bool>{
            ColorPickerType.primary: true,
            ColorPickerType.wheel: true,
          },
          customColorSwatchesAndNames: customSwatches,
          width: 320,
        ),
        actions: [
          ShadButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          ShadButton(
            onPressed: () => Navigator.of(ctx).pop(color),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      onChanged(_formatColor(result));
    }
  }
}
