import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../widgets/placeholder_workspace.dart';

class DiagnosticsWorkspace extends StatelessWidget {
  const DiagnosticsWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderWorkspace(
      icon: LucideIcons.activity,
      title: '诊断面板',
      description: 'Phase 3.3 中实现 — 运行时错误、配置冲突、性能诊断信息。',
    );
  }
}
