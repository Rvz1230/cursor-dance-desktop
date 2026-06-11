import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PanelDivider extends StatelessWidget {
  const PanelDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return Divider(height: 1, thickness: 1, color: cs.muted);
  }
}
