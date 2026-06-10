import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

class StatesWorkspace extends StatelessWidget {
  const StatesWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.mousePointer2, size: 48, color: cs.mutedForeground),
            const SizedBox(height: Spacing.lg),
            Text('光标状态管理', style: TextStyle(fontSize: FontSizes.h3, fontWeight: FontWeight.w600, color: cs.foreground)),
            const SizedBox(height: Spacing.sm),
            Text(
              'Phase 3.3 中实现 — 管理不同光标状态（默认、手型、文本等）的样式和触发动作。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FontSizes.body,
                color: cs.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
