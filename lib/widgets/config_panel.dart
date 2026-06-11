import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/action_config.dart';
import '../theme/tokens.dart';

class ConfigPanel extends StatelessWidget {
  final String actionId;
  final ActionConfig config;
  final List<String> conflicts;
  final ValueChanged<ActionConfig Function(ActionConfig)> onUpdateConfig;

  const ConfigPanel({
    super.key,
    required this.actionId,
    required this.config,
    required this.conflicts,
    required this.onUpdateConfig,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '配置面板 (Phase 3)',
              style: TextStyle(
                fontSize: FontSizes.h4,
                fontWeight: FontWeight.w600,
                color: cs.mutedForeground,
              ),
            ),
            if (conflicts.isNotEmpty) ...[
              const SizedBox(height: Spacing.sm),
              for (final c in conflicts)
                Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.xs),
                  child: Text(
                    '⚠ $c',
                    style: TextStyle(
                      fontSize: FontSizes.small,
                      color: cs.destructive,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
