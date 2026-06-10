import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Section 标题（text-sm font-semibold）
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: cs.foreground,
        ),
      ),
    );
  }
}
