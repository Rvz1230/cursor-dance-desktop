import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../widgets/placeholder_workspace.dart';

class StatesWorkspace extends StatelessWidget {
  const StatesWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderWorkspace(
      icon: LucideIcons.mousePointer2,
      title: '光标状态管理',
      description: 'Phase 3.3 中实现 — 管理不同光标状态（默认、手型、文本等）的样式和触发动作。',
    );
  }
}
