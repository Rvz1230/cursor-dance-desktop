import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StatesWorkspace extends StatelessWidget {
  const StatesWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.mousePointer2, size: 48, color: theme.colorScheme.mutedForeground),
            const SizedBox(height: 16),
            Text('光标状态管理', style: theme.textTheme.h3),
            const SizedBox(height: 8),
            Text(
              'Phase 3.3 中实现 — 管理不同光标状态（默认、手型、文本等）的样式和触发动作。',
              textAlign: TextAlign.center,
              style: theme.textTheme.p.copyWith(
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
