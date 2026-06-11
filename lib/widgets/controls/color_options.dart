import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/tokens.dart';

const kDefaultSwatches = [
  '#EF4444', '#F97316', '#F59E0B', '#EAB308',
  '#84CC16', '#22C55E', '#14B8A6', '#06B6D4',
  '#3B82F6', '#6366F1', '#8B5CF6', '#A855F7',
  '#D946EF', '#EC4899', '#F43F5E', '#78716C',
];

class ColorOptions extends StatelessWidget {
  final String value;
  final List<String> swatches;
  final ValueChanged<String> onChanged;

  const ColorOptions({
    super.key,
    required this.value,
    this.swatches = kDefaultSwatches,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SwatchButton(
          color: _parseHex(value),
          selected: true,
          onTap: () => _showPickerDialog(context),
        ),
        const SizedBox(width: Spacing.xs),
        GestureDetector(
          onTap: () => _showPickerDialog(context),
          child: Text(
            value,
            style: TextStyle(
              fontSize: FontSizes.micro,
              color: ShadTheme.of(context).colorScheme.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }

  void _showPickerDialog(BuildContext context) async {
    final result = await showShadDialog<String>(
      context: context,
      builder: (ctx) => _ColorPickerDialog(
        value: value,
        swatches: swatches,
      ),
    );
    if (result != null) onChanged(result);
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final String value;
  final List<String> swatches;

  const _ColorPickerDialog({required this.value, required this.swatches});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late String _hexValue;

  @override
  void initState() {
    super.initState();
    _hexValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text('选择颜色'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: Spacing.sm,
            runSpacing: Spacing.sm,
            children: widget.swatches.map((s) {
              return _SwatchButton(
                color: _parseHex(s),
                selected: s == _hexValue,
                size: 32,
                onTap: () => setState(() => _hexValue = s),
              );
            }).toList(),
          ),
          const SizedBox(height: Spacing.md),
          ShadInput(
            initialValue: _hexValue,
            onChanged: (v) => setState(() => _hexValue = v),
            placeholder: const Text('#RRGGBB'),
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xs,
            ),
          ),
        ],
      ),
      actions: [
        ShadButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ShadButton(
          onPressed: () => Navigator.pop(context, _hexValue),
          child: const Text('确定'),
        ),
      ],
    );
  }
}

class _SwatchButton extends StatelessWidget {
  final Color color;
  final bool selected;
  final double size;
  final VoidCallback onTap;

  const _SwatchButton({
    required this.color,
    this.selected = false,
    this.size = 20,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(color: ShadTheme.of(context).colorScheme.foreground, width: 2)
              : null,
        ),
      ),
    );
  }
}

Color _parseHex(String hex) {
  final code = hex.replaceFirst('#', '');
  return Color(int.parse('FF$code', radix: 16));
}
