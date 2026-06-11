import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../theme/tokens.dart';

class WorkbenchHeader extends StatelessWidget {
  final ValueChanged<bool?>? onGlobalToggle;

  const WorkbenchHeader({super.key, this.onGlobalToggle});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      decoration: BoxDecoration(
        color: cs.card,
        border: Border(bottom: BorderSide(color: cs.border)),
      ),
      child: Row(
        children: [
          Text(
            'CursorDance',
            style: TextStyle(
              fontSize: FontSizes.h3,
              fontWeight: FontWeight.w700,
              color: cs.foreground,
            ),
          ),
          const Spacer(),
          ShadSwitch(
            value: true,
            onChanged: onGlobalToggle,
          ),
        ],
      ),
    );
  }
}
