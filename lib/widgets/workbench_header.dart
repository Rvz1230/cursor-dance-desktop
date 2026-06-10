import 'package:flutter/material.dart';
import '../../theme/animations.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../providers/overlay_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_tokens.dart';

class WorkbenchHeader extends StatelessWidget {
  final ValueChanged<bool>? onGlobalToggle;

  const WorkbenchHeader({
    super.key,
    this.onGlobalToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final overlay = context.watch<OverlayProvider>();
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
                _workspaceTab(cs, theme, 'workbench', '主题工作台', LucideIcons.wand2),
                const SizedBox(width: Spacing.xs),
                _workspaceTab(cs, theme, 'states', '光标状态', LucideIcons.mousePointer2),
                const SizedBox(width: Spacing.xs),
                _workspaceTab(cs, theme, 'keyboard', '键盘动效', LucideIcons.keyboard),
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
                  const SizedBox(width: Spacing.sm),
                  ShadSwitch(
                    value: overlay.enabled,
                    onChanged: onGlobalToggle ?? (v) => overlay.setEnabled(v),
                  ),
                ],
              ),

              const SizedBox(width: Spacing.lg),

              // Save button
              ShadButton(
                onPressed: () => theme.saveChanges(),
                size: ShadButtonSize.sm,
                enabled: theme.unsaved,
                child: Row(
                  children: [
                    if (theme.isSaving)
                      const SizedBox(
                        width: IconSizes.sm,
                        height: IconSizes.sm,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(LucideIcons.save, size: IconSizes.md),
                    const SizedBox(width: Spacing.xs),
                    Text(theme.unsaved ? '保存' : '已保存'),
                  ],
                ),
              ),

              if (theme.saveError.isNotEmpty) ...[
                const SizedBox(width: Spacing.sm),
                Icon(LucideIcons.alertCircle, size: IconSizes.md, color: cs.destructive),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _workspaceTab(ShadColorScheme cs, ThemeProvider theme, String id, String label, IconData icon) {
    final active = theme.workspaceId == id;
    return GestureDetector(
      onTap: () => theme.setWorkspaceId(id),
      child: AnimatedContainer(
        duration: AppAnimations.normal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: Spacing.sm),
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
