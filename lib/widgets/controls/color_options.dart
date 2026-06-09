import 'package:flutter/material.dart';

import '../../theme/app_tokens.dart';

/// 弹出式颜色选择器 — 插件版 ColorOptions 的 Flutter 实现
///
/// 点击当前色块弹出选择面板，包含:
///   预设色板（多行圆点）
///   Hex 输入框
///   颜色预览
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
    final currentColor = _parse(value);

    return GestureDetector(
      onTap: () => _showPicker(context, currentColor),
      child: ClipRect(
        child: Row(
          children: [
            // Current color indicator
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: currentColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 1),
              ),
            ),
            // Hex label
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

  void _showPicker(BuildContext context, Color currentColor) {
    showDialog(
      context: context,
      builder: (ctx) => _ColorPickerDialog(
        currentHex: value,
        swatches: swatches,
        onChanged: onChanged,
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final String currentHex;
  final List<String> swatches;
  final ValueChanged<String> onChanged;

  const _ColorPickerDialog({
    required this.currentHex,
    required this.swatches,
    required this.onChanged,
  });

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late TextEditingController _hexController;
  late Color _selectedColor;

  Color _parse(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  String _formatHex(Color color) {
    final str = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return '#${str.substring(2).toUpperCase()}';
  }

  @override
  void initState() {
    super.initState();
    _selectedColor = _parse(widget.currentHex);
    _hexController = TextEditingController(
      text: _formatHex(_selectedColor),
    );
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  void _apply(String hex) {
    widget.onChanged(hex);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.xl2),
      ),
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color preview
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(RadiusTokens.xl),
                border: Border.all(color: AppColors.border),
              ),
            ),
            const SizedBox(height: 20),

            // Label
            Text(
              '预设颜色',
              style: const TextStyle(
                fontSize: FontSizes.small,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 8),

            // Swatches grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.swatches.map((hex) {
                final color = _parse(hex);
                final isSelected = hex == _formatHex(_selectedColor);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                      _hexController.text = hex;
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.foreground
                            : AppColors.border,
                        width: isSelected ? 2.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Hex input
            Row(
              children: [
                const Text(
                  '#',
                  style: TextStyle(
                    fontSize: FontSizes.base,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    controller: _hexController,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 6,
                    style: const TextStyle(
                      fontSize: FontSizes.base,
                      fontWeight: FontWeight.w600,
                      fontFeatures: [FontFeature.tabularFigures()],
                      color: AppColors.foreground,
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: AppColors.input),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: AppColors.input),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: AppColors.ring, width: 2),
                      ),
                    ),
                    onChanged: (v) {
                      final cleaned = v.replaceAll('#', '');
                      if (cleaned.length == 6) {
                        final hex = '#$cleaned';
                        try {
                          setState(() {
                            _selectedColor = _parse(hex);
                          });
                        } catch (_) {}
                      }
                    },
                    onSubmitted: (v) {
                      final cleaned = v.replaceAll('#', '');
                      if (cleaned.length == 6) {
                        _apply('#$cleaned');
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.mutedForeground,
                  ),
                  child: const Text('取消', style: TextStyle(fontSize: FontSizes.base)),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _apply(_formatHex(_selectedColor)),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.foreground,
                  ),
                  child: const Text('确定', style: TextStyle(fontSize: FontSizes.base)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
