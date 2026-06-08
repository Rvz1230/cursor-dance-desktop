import 'package:flutter/material.dart';

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
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kActionIds.length,
        separatorBuilder: (_, _) => const SizedBox(width: 4),
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
                color: active ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(RadiusTokens.lg),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: IconSizes.sm,
                    color: active ? AppColors.primaryForeground : AppColors.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: FontSizes.small,
                      fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                      color: active ? AppColors.primaryForeground : AppColors.mutedForeground,
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
