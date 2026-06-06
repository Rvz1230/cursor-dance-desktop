import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PanelPlaceholderContent extends StatelessWidget {
  final String panelName;
  final String description;

  const PanelPlaceholderContent({
    super.key,
    required this.panelName,
    this.description = '配置项将在 Phase 3.3 中实现',
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            panelName,
            style: theme.textTheme.p,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.small.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
