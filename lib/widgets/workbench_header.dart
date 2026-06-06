import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../state/workbench_state.dart';

class WorkbenchHeader extends StatelessWidget {
  final WorkbenchState state;

  const WorkbenchHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.border),
        ),
      ),
      child: Row(
        children: [
          // App name + version
          Row(
            children: [
              Icon(
                LucideIcons.sparkles,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'CursorDance',
                style: theme.textTheme.p.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '桌面版',
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ],
          ),

          const SizedBox(width: 24),

          // Workspace tabs
          Expanded(
            child: Row(
              children: [
                _workspaceTab(context, 'workbench', '主题工作台', LucideIcons.wand2),
                const SizedBox(width: 4),
                _workspaceTab(context, 'states', '光标状态', LucideIcons.mousePointer2),
                const SizedBox(width: 4),
                _workspaceTab(context, 'diagnostics', '诊断面板', LucideIcons.activity),
              ],
            ),
          ),

          // Right actions
          Row(
            children: [
              // Global enable switch
              Row(
                children: [
                  Text(
                    '全局',
                    style: theme.textTheme.small,
                  ),
                  const SizedBox(width: 6),
                  ShadSwitch(
                    value: state.enabled,
                    onChanged: (v) => state.setEnabled(v),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Save button
              ShadButton(
                onPressed: () => state.saveChanges(),
                size: ShadButtonSize.sm,
                enabled: state.unsaved,
                child: Row(
                  children: [
                    if (state.isSaving)
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(LucideIcons.save, size: 14),
                    const SizedBox(width: 4),
                    Text(state.unsaved ? '保存' : '已保存'),
                  ],
                ),
              ),

              if (state.saveError.isNotEmpty) ...[
                const SizedBox(width: 8),
                Icon(LucideIcons.alertCircle, size: 14, color: theme.colorScheme.destructive),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _workspaceTab(BuildContext context, String id, String label, IconData icon) {
    final active = state.workspaceId == id;
    final theme = ShadTheme.of(context);
    return GestureDetector(
      onTap: () => state.setWorkspaceId(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: active ? theme.colorScheme.primaryForeground : theme.colorScheme.mutedForeground,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.small.copyWith(
                color: active ? theme.colorScheme.primaryForeground : theme.colorScheme.mutedForeground,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
