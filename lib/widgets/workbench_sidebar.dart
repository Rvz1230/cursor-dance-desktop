import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../theme/tokens.dart';

class WorkbenchSidebar extends StatelessWidget {
  const WorkbenchSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: cs.card,
        border: Border(right: BorderSide(color: cs.border)),
      ),
      child: Center(
        child: Text(
          '主题库 (Phase 3)',
          style: TextStyle(fontSize: FontSizes.small, color: cs.mutedForeground),
        ),
      ),
    );
  }
}
