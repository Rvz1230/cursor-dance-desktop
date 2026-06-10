import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

/// 状态指示器 — 圆点 + 文字
///
/// 用于显示启用/停用等状态，整合了 config_page 和 keyboard_workspace 中的状态横幅模式。
class StatusIndicator extends StatelessWidget {
  final bool active;
  final String label;

  const StatusIndicator({
    super.key,
    required this.active,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? (cs.custom['success'] ?? Color(0xFF10B981)) : cs.mutedForeground,
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: active ? (cs.custom['success'] ?? Color(0xFF065F46)) : cs.mutedForeground,
          ),
        ),
      ],
    );
  }
}
