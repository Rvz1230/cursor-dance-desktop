import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/tokens.dart';

class WipBadge extends StatelessWidget {
  const WipBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: cs.custom['warning']?.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
      ),
      child: Text(
        'WIP',
        style: TextStyle(
          fontSize: FontSizes.micro,
          fontWeight: FontWeight.w700,
          color: cs.custom['warning'],
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
