import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

/// "开发中" 标签 — 插件版 DataPill amber 色调
class WipBadge extends StatelessWidget {
  const WipBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 1),
      decoration: BoxDecoration(
        color: cs.custom['warning']?.withValues(alpha: 0.15) ?? cs.destructive.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
        border: Border.all(
          color: cs.custom['warning']?.withValues(alpha: 0.3) ?? cs.destructive.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        '开发中',
        style: TextStyle(
          fontSize: FontSizes.caption,
          color: cs.custom['warning'] ?? cs.destructive,
          height: 1.2,
        ),
      ),
    );
  }
}
