import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// 设置占位页 — 未来版本实现
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: cs.card,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.settings, size: 48, color: cs.mutedForeground),
            const SizedBox(height: 16),
            Text(
              '设置页',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: cs.foreground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '即将到来',
              style: TextStyle(
                fontSize: 14,
                color: cs.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
