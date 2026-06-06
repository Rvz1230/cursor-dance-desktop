import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
    final theme = ShadTheme.of(context);
    return Row(
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
            style: theme.textTheme.small.copyWith(
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
