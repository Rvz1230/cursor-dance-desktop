import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/tokens.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Text(
        title,
        style: TextStyle(
          fontSize: FontSizes.base,
          fontWeight: FontWeight.w600,
          color: cs.foreground,
        ),
      ),
    );
  }
}
