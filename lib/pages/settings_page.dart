import 'package:flutter/material.dart';
import '../theme/app_tokens.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// 设置占位页 — 未来版本实现
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          decoration: BoxDecoration(
            color: cs.card,
            border: Border(
              bottom: BorderSide(color: cs.border),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '设置',
              style: TextStyle(
                fontSize: FontSizes.base,
                fontWeight: FontWeight.w600,
                color: cs.foreground,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.settings, size: 48, color: cs.mutedForeground),
                const SizedBox(height: Spacing.lg),
                Text(
                  '设置页',
                  style: TextStyle(
                    fontSize: FontSizes.h2,
                    fontWeight: FontWeight.w600,
                    color: cs.foreground,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  '即将到来',
                  style: TextStyle(
                    fontSize: FontSizes.base,
                    color: cs.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
