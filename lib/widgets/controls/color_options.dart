import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
    final theme = ShadTheme.of(context);
    return Row(
      children: [
        for (final swatch in swatches)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => onChanged(swatch),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _parse(swatch),
                  shape: BoxShape.circle,
                  border: swatch == value
                      ? Border.all(color: theme.colorScheme.foreground, width: 2)
                      : null,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
