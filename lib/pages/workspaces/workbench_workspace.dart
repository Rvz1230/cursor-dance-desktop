import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/tokens.dart';
import '../../widgets/action_tabs.dart';
import '../../widgets/config_panel.dart';
import '../../widgets/panels/cursor_appearance_card.dart';
import '../../widgets/preview_panel.dart';
import '../../providers/config_provider.dart';
import '../../providers/theme_provider.dart';

enum WorkspaceTab { actions, cursorAppearance }

class WorkbenchWorkspace extends StatefulWidget {
  final ConfigProvider config;
  final ThemeProvider theme;

  const WorkbenchWorkspace({
    super.key,
    required this.config,
    required this.theme,
  });

  @override
  State<WorkbenchWorkspace> createState() => _WorkbenchWorkspaceState();
}

class _WorkbenchWorkspaceState extends State<WorkbenchWorkspace> {
  double _splitRatio = 0.45;
  bool _hovered = false;
  WorkspaceTab _tab = WorkspaceTab.actions;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigProvider>();
    final cs = ShadTheme.of(context).colorScheme;

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
                padding: const EdgeInsets.all(Spacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top-level tabs
                    _buildTopTabs(cs),
                    const SizedBox(height: Spacing.sm),
                    // Tab content
                    Expanded(
                      child: _tab == WorkspaceTab.actions
                          ? _buildActionsTab(config)
                          : const _CursorAppearanceTab(),
                    ),
                  ],
                ),
              ),
            ),

            // Draggable column divider
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _splitRatio =
                        (_splitRatio + details.delta.dx / totalWidth)
                            .clamp(0.25, 0.75);
                  });
                },
                child: Container(
                  width: Spacing.lg,
                  color: Colors.transparent,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 3,
                      height: _hovered ? 64 : 32,
                      decoration: BoxDecoration(
                        color: _hovered
                            ? cs.border
                            : cs.border.withValues(alpha: 0.5),
                        borderRadius:
                            BorderRadius.circular(RadiusTokens.sm),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: rightFlex,
              child: Padding(
                padding: const EdgeInsets.all(Spacing.sm),
                child: PreviewPanel(
                  actionId: config.selectedActionId,
                  config: config.currentActionConfig,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopTabs(ShadColorScheme cs) {
    return Row(
      children: [
        _TopTabButton(
          label: '动作配置',
          icon: LucideIcons.sparkles,
          selected: _tab == WorkspaceTab.actions,
          onTap: () => setState(() => _tab = WorkspaceTab.actions),
        ),
        const SizedBox(width: Spacing.xs),
        _TopTabButton(
          label: '光标外观',
          icon: LucideIcons.mousePointer2,
          selected: _tab == WorkspaceTab.cursorAppearance,
          onTap: () => setState(() => _tab = WorkspaceTab.cursorAppearance),
        ),
      ],
    );
  }

  Widget _buildActionsTab(ConfigProvider config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActionTabs(
          selectedActionId: config.selectedActionId,
          onActionChanged: (id) => config.setActionId(id),
        ),
        const SizedBox(height: Spacing.sm),
        Expanded(
          child: SingleChildScrollView(
            child: ConfigPanel(
              actionId: config.selectedActionId,
              config: config.currentActionConfig,
              conflicts: config.currentConflicts,
              onUpdateConfig: (fn) => config.updateConfig(fn),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopTabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TopTabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(RadiusTokens.lg),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: IconSizes.md,
                color: selected ? cs.primaryForeground : cs.mutedForeground,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                label,
                style: TextStyle(
                  fontSize: FontSizes.small,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? cs.primaryForeground : cs.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CursorAppearanceTab extends StatelessWidget {
  const _CursorAppearanceTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: CursorAppearanceCard(),
    );
  }
}
