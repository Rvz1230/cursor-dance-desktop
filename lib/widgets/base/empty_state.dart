import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

/// 空状态组件 — 图标 + 标题 + 副标题 + 可选操作按钮
///
/// 整合侧栏和配置面板中多处散落的空状态模式。
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: IconSizes.xl, color: cs.mutedForeground),
            const SizedBox(height: Spacing.sm),
            Text(
              title,
              style: TextStyle(
                fontSize: FontSizes.small,
                fontWeight: FontWeight.w600,
                color: cs.foreground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: FontSizes.caption,
                color: cs.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: Spacing.md),
              ShadButton(
                size: ShadButtonSize.sm,
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
