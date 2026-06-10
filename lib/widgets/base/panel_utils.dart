import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// 效果卡片间 1px 分割线
class PanelDivider extends StatelessWidget {
  const PanelDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return SizedBox(
      height: 1,
      child: DecoratedBox(decoration: BoxDecoration(color: cs.muted)),
    );
  }
}

// ── 侧栏尺寸常量 ──

/// 侧栏折叠态宽度
const double kSidebarCollapsedWidth = 72;

/// 侧栏展开态宽度
const double kSidebarExpandedWidth = 260;
