import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/theme_draft.dart';
import '../theme/tokens.dart';

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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: kActionIds.map((id) {
          final selected = id == selectedActionId;
          return Padding(
            padding: const EdgeInsets.only(right: Spacing.xs),
            child: selected
                ? ShadButton(
                    onPressed: () => onActionChanged(id),
                    size: ShadButtonSize.sm,
                    child: Text(
                      kActionLabels[id] ?? id,
                      style: const TextStyle(fontSize: FontSizes.small),
                    ),
                  )
                : ShadButton.ghost(
                    onPressed: () => onActionChanged(id),
                    size: ShadButtonSize.sm,
                    child: Text(
                      kActionLabels[id] ?? id,
                      style: const TextStyle(fontSize: FontSizes.small),
                    ),
                  ),
          );
        }).toList(),
      ),
    );
  }
}
