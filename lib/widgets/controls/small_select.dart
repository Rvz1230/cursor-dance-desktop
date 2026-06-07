import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

class SmallSelect extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String>? onChanged;

  const SmallSelect({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ShadSelect<String>(
      initialValue: value,
      selectedOptionBuilder: (context, selectedValue) {
        return Text(
          selectedValue,
          style: const TextStyle(
            fontSize: FontSizes.base,
            color: AppColors.foreground,
          ),
        );
      },
      options: options.map((opt) {
        return ShadOption(
          value: opt,
          child: Text(
            opt,
            style: const TextStyle(
              fontSize: FontSizes.base,
              color: AppColors.foreground,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged != null
          ? (String? value) {
              if (value != null) onChanged!(value);
            }
          : null,
    );
  }
}
