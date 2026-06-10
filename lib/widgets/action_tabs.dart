import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config_presets.dart';
import '../../theme/app_tokens.dart';
import 'controls/icon_resolver.dart';

class ActionTabs extends StatelessWidget {
  final String selectedActionId;
  final ValueChanged<String> onActionChanged;

  const ActionTabs({
    super.key,
    required this.selectedActionId,
    required this.onActionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kActionIds.length,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.xs),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemBuilder: (context, index) {
          final actionId = kActionIds[index];
          final active = actionId == selectedActionId;
          final label = kActionLabels[actionId] ?? actionId;
          final icon = actionIcon(actionId);
          return GestureDetector(
            onTap: () => onActionChanged(actionId),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: active ? cs.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(RadiusTokens.lg),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: IconSizes.sm,
                    color: active ? cs.primaryForeground : cs.mutedForeground,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: FontSizes.small,
                      fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                      color: active ? cs.primaryForeground : cs.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
