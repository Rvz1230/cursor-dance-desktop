import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../state/workbench_state.dart';
import '../../theme/app_tokens.dart';

class WorkbenchHeader extends StatelessWidget {
  final WorkbenchState state;

  const WorkbenchHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // App name + version
          Row(
            children: [
              Icon(
                LucideIcons.sparkles,
                size: IconSizes.lg,
                color: AppColors.foreground,
              ),
              const SizedBox(width: 8),
              Text(
                'CursorDance',
                style: const TextStyle(
                  fontSize: FontSizes.base,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '桌面版',
                style: const TextStyle(
                  fontSize: FontSizes.small,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),

          const SizedBox(width: 24),

          // Workspace tabs
          Expanded(
            child: Row(
              children: [
                _workspaceTab('workbench', '主题工作台', LucideIcons.wand2,
                    showActiveBg: state.workspaceId == 'workbench'),
                const SizedBox(width: 4),
                _workspaceTab('states', '光标状态', LucideIcons.mousePointer2,
                    showActiveBg: state.workspaceId == 'states'),
                const SizedBox(width: 4),
                _workspaceTab('diagnostics', '诊断面板', LucideIcons.activity,
                    showActiveBg: state.workspaceId == 'diagnostics'),
              ],
            ),
          ),

          // Right actions
          Row(
            children: [
              // Global enable switch
              Row(
                children: [
                  const Text(
                    '全局',
                    style: TextStyle(
                      fontSize: FontSizes.small,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ShadSwitch(
                    value: state.enabled,
                    onChanged: (v) => state.setEnabled(v),
                  ),
                ],
              ),

              const SizedBox(width: 14),

              // Save button
              ShadButton(
                onPressed: () => state.saveChanges(),
                size: ShadButtonSize.sm,
                enabled: state.unsaved,
                child: Row(
                  children: [
                    if (state.isSaving)
                      const SizedBox(
                        width: IconSizes.sm,
                        height: IconSizes.sm,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(LucideIcons.save, size: IconSizes.md),
                    const SizedBox(width: 4),
                    Text(state.unsaved ? '保存' : '已保存'),
                  ],
                ),
              ),

              if (state.saveError.isNotEmpty) ...[
                const SizedBox(width: 8),
                Icon(LucideIcons.alertCircle, size: IconSizes.md, color: AppColors.destructive),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _workspaceTab(String id, String label, IconData icon, {bool showActiveBg = false}) {
    final active = showActiveBg;
    return GestureDetector(
      onTap: () => state.setWorkspaceId(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(RadiusTokens.md),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: IconSizes.md,
              color: active ? AppColors.primaryForeground : AppColors.mutedForeground,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: FontSizes.small,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                color: active ? AppColors.primaryForeground : AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
