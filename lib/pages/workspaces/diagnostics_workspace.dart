import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../state/workbench_state.dart';

class DiagnosticsWorkspace extends StatelessWidget {
  final WorkbenchState state;

  const DiagnosticsWorkspace({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.activity,
              size: 48,
              color: theme.colorScheme.mutedForeground,
            ),
            const SizedBox(height: 16),
            Text(
              '诊断面板',
              style: theme.textTheme.h3,
            ),
            const SizedBox(height: 8),
            Text(
              'Phase 3.3 中实现 — 运行时错误、配置冲突、性能诊断信息。',
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
