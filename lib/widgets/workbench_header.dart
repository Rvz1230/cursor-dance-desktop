import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../state/workbench_state.dart';
import '../../theme/app_tokens.dart';

class WorkbenchHeader extends StatelessWidget {
  final WorkbenchState state;
  final ValueChanged<bool>? onGlobalToggle;

  const WorkbenchHeader({
    super.key,
    required this.state,
    this.onGlobalToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      decoration: BoxDecoration(
        color: cs.card,
        border: Border(
          bottom: BorderSide(color: cs.border),
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
                color: cs.foreground,
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                'CursorDance',
                style: TextStyle(
                  fontSize: FontSizes.base,
                  fontWeight: FontWeight.bold,
                  color: cs.foreground,
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                '桌面版',
                style: TextStyle(
                  fontSize: FontSizes.small,
                  color: cs.mutedForeground,
                ),
              ),
            ],
          ),

          const SizedBox(width: Spacing.xl),

          // Workspace tabs
          Expanded(
            child: Row(
              children: [
                _workspaceTab(cs, 'workbench', '主题工作台', LucideIcons.wand2,
                    showActiveBg: state.workspaceId == 'workbench'),
                const SizedBox(width: Spacing.xs),
                _workspaceTab(cs, 'states', '光标状态', LucideIcons.mousePointer2,
                    showActiveBg: state.workspaceId == 'states'),
                const SizedBox(width: Spacing.xs),
                _workspaceTab(cs, 'keyboard', '键盘动效', LucideIcons.keyboard,
                    showActiveBg: state.workspaceId == 'keyboard'),
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
                    style: TextStyle(
                      fontSize: FontSizes.small,
                      color: cs.foreground,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ShadSwitch(
                    value: state.enabled,
                    onChanged: onGlobalToggle ?? (v) => state.setEnabled(v),
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
                    const SizedBox(width: Spacing.xs),
                    Text(state.unsaved ? '保存' : '已保存'),
                  ],
                ),
              ),

              if (state.saveError.isNotEmpty) ...[
                const SizedBox(width: Spacing.sm),
                Icon(LucideIcons.alertCircle, size: IconSizes.md, color: cs.destructive),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _workspaceTab(ShadColorScheme cs, String id, String label, IconData icon, {bool showActiveBg = false}) {
    final active = showActiveBg;
    return GestureDetector(
      onTap: () => state.setWorkspaceId(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(RadiusTokens.md),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: IconSizes.md,
              color: active ? cs.primaryForeground : cs.mutedForeground,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: FontSizes.small,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                color: active ? cs.primaryForeground : cs.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
