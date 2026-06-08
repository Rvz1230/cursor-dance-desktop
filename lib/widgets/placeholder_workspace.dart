import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// 占位工作区 — 用于暂未实现的 workspace 页面。
/// 显示居中图标 + 标题 + 描述，Phase 3.3 后替换为实际内容。
class PlaceholderWorkspace extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const PlaceholderWorkspace({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.mutedForeground),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.h3),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.p.copyWith(
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
