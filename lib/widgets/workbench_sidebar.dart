import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/theme.dart';
import '../../state/workbench_state.dart';
import '../../theme/app_tokens.dart';
import 'controls/app_icon_button.dart';

class WorkbenchSidebar extends StatefulWidget {
  final WorkbenchState state;

  const WorkbenchSidebar({super.key, required this.state});

  @override
  State<WorkbenchSidebar> createState() => _WorkbenchSidebarState();
}

class _WorkbenchSidebarState extends State<WorkbenchSidebar> {
  bool _collapsed = false;
  String _query = '';

  List<ThemeItem> get _filteredThemes {
    if (_query.isEmpty) return widget.state.themeLibrary;
    return widget.state.themeLibrary.where((t) {
      return t.name.toLowerCase().contains(_query.toLowerCase()) ||
          t.summary.toLowerCase().contains(_query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _collapsed ? 72 : 260,
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(
              horizontal: _collapsed ? 8 : 10,
            ),
            child: Row(
              children: [
                if (!_collapsed) ...[
                  Expanded(
                    child: Text(
                      '主题库',
                      style: const TextStyle(
                        fontSize: FontSizes.base,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                    ),
                  ),
                  AppIconButton(
                    icon: LucideIcons.plus,
                    onTap: () => _showCreateDialog(context),
                    tooltip: '新建主题',
                  ),
                  const SizedBox(width: 4),
                  AppIconButton(
                    icon: LucideIcons.panelLeftClose,
                    onTap: () => setState(() => _collapsed = true),
                    tooltip: '收起侧栏',
                  ),
                ] else ...[
                  AppIconButton(
                    icon: LucideIcons.panelLeftOpen,
                    onTap: () => setState(() => _collapsed = false),
                    tooltip: '展开侧栏',
                  ),
                ],
              ],
            ),
          ),

          // Search (animated collapse)
          if (!_collapsed)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: _collapsed ? 0.0 : 1.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ShadInput(
                  initialValue: _query,
                  onChanged: (v) => setState(() => _query = v),
                  placeholder: const Text('搜索主题...'),
                  leading: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(LucideIcons.search, size: IconSizes.md, color: AppColors.mutedForeground),
                  ),
                ),
              ),
            ),

          // Theme list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 4,
                left: _collapsed ? 8 : 4,
                right: _collapsed ? 8 : 4,
              ),
              itemCount: _filteredThemes.length,
              itemBuilder: (context, index) {
                final t = _filteredThemes[index];
                final active = t.id == widget.state.selectedThemeId;
                return _ThemeCard(
                  theme: t,
                  active: active,
                  collapsed: _collapsed,
                  onTap: () => widget.state.setThemeId(t.id),
                  onRename: (name) => widget.state.renameTheme(t.id, name),
                  onDelete: () {
                    if (widget.state.themeLibrary.length > 1) {
                      widget.state.deleteTheme(t.id);
                    }
                  },
                  onDuplicate: () => widget.state.duplicateTheme(t.id),
                );
              },
            ),
          ),

          // Bottom action (create button when collapsed)
          if (_collapsed)
            Padding(
              padding: const EdgeInsets.all(8),
              child: AppIconButton(
                icon: LucideIcons.plus,
                onTap: () => _showCreateDialog(context),
                tooltip: '新建主题',
                size: 44,
                iconSize: IconSizes.lg,
              ),
            ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('新建主题'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '输入主题名称',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                widget.state.createTheme(controller.text.trim());
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatefulWidget {
  final ThemeItem theme;
  final bool active;
  final bool collapsed;
  final VoidCallback onTap;
  final ValueChanged<String> onRename;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const _ThemeCard({
    required this.theme,
    required this.active,
    required this.collapsed,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  State<_ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<_ThemeCard> {
  bool _renaming = false;
  late TextEditingController _renameController;

  @override
  void initState() {
    super.initState();
    _renameController = TextEditingController(text: widget.theme.name);
  }

  @override
  void didUpdateWidget(covariant _ThemeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.theme.name != oldWidget.theme.name) {
      _renameController.text = widget.theme.name;
    }
  }

  @override
  void dispose() {
    _renameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.collapsed) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Semantics(
          button: true,
          label: widget.theme.name,
          child: Tooltip(
            message: widget.theme.name,
            preferBelow: false,
            triggerMode: TooltipTriggerMode.tap,
            child: GestureDetector(
              onTap: widget.onTap,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: widget.active
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(RadiusTokens.lg),
                    border: widget.active
                        ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      widget.theme.name.length <= 2
                          ? widget.theme.name
                          : widget.theme.name.substring(0, 2),
                      style: TextStyle(
                        fontSize: FontSizes.small,
                        fontWeight: FontWeight.bold,
                        color: widget.active
                            ? AppColors.primary
                            : AppColors.mutedForeground,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return _buildExpandedCard();
  }

  Widget _buildExpandedCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          onDoubleTap: () => setState(() => _renaming = true),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: widget.active
                  ? AppColors.muted
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(RadiusTokens.lg),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Active accent bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 3,
                  height: _renaming ? 36 : 44,
                  margin: const EdgeInsets.only(top: 4, right: 8),
                  decoration: BoxDecoration(
                    color: widget.active
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                ),

                // Icon
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: AppColors.muted,
                    borderRadius: BorderRadius.circular(RadiusTokens.md),
                  ),
                  child: Icon(
                    LucideIcons.wand2,
                    size: IconSizes.md,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(width: 8),

                // Name + summary
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                    child: _renaming
                        ? SizedBox(
                            height: 28,
                            child: TextField(
                              controller: _renameController,
                              autofocus: true,
                              style: const TextStyle(
                                fontSize: FontSizes.small,
                                color: AppColors.foreground,
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                isDense: true,
                              ),
                              onSubmitted: (v) {
                                if (v.trim().isNotEmpty) {
                                  widget.onRename(v.trim());
                                }
                                setState(() => _renaming = false);
                              },
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.theme.name,
                                style: const TextStyle(
                                  fontSize: FontSizes.small,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.foreground,
                                ),
                              ),
                              Text(
                                widget.theme.summary,
                                style: const TextStyle(
                                  fontSize: FontSizes.caption,
                                  color: AppColors.mutedForeground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                  ),
                ),

                if (widget.active && !_renaming)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        LucideIcons.moreHorizontal,
                        size: IconSizes.md,
                        color: AppColors.mutedForeground,
                      ),
                      onSelected: (v) {
                        switch (v) {
                          case 'duplicate':
                            widget.onDuplicate();
                          case 'delete':
                            widget.onDelete();
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'duplicate', child: Text('复制')),
                        const PopupMenuItem(value: 'delete', child: Text('删除')),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
