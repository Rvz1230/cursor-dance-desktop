import 'package:flutter/material.dart';

import '../../state/workbench_state.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/action_tabs.dart';
import '../../widgets/config_panel.dart';
import '../../widgets/preview_panel.dart';

/// 主工作台 — 配置面板 (左) + 预览面板 (右)，支持拖拽分割
class WorkbenchWorkspace extends StatefulWidget {
  final WorkbenchState state;

  const WorkbenchWorkspace({super.key, required this.state});

  @override
  State<WorkbenchWorkspace> createState() => _WorkbenchWorkspaceState();
}

class _WorkbenchWorkspaceState extends State<WorkbenchWorkspace> {
  double _splitRatio = 0.45;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final leftFlex = (_splitRatio * 100).round();
        final rightFlex = 100 - leftFlex;

        return Row(
          children: [
            Expanded(
              flex: leftFlex,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ActionTabs(
                      selectedActionId: widget.state.selectedActionId,
                      onActionChanged: (id) => widget.state.setActionId(id),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ConfigPanel(
                          actionId: widget.state.selectedActionId,
                          config: widget.state.currentActionConfig,
                          conflicts: widget.state.currentConflicts,
                          onUpdateConfig: widget.state.updateActionConfig,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 可拖拽列分割条
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _splitRatio =
                        (_splitRatio + details.delta.dx / totalWidth).clamp(0.25, 0.75);
                  });
                },
                child: Container(
                  width: 12,
                  color: Colors.transparent,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 3,
                      height: _hovered ? 64 : 32,
                      decoration: BoxDecoration(
                        color: _hovered
                            ? AppColors.border
                            : AppColors.border.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: rightFlex,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: PreviewPanel(
                  actionId: widget.state.selectedActionId,
                  config: widget.state.currentActionConfig,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
