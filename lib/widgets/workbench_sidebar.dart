import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/theme.dart';
import '../../state/workbench_state.dart';

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
    final theme = ShadTheme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _collapsed ? 72 : 260,
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(
          right: BorderSide(color: theme.colorScheme.border),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: _collapsed ? 8 : 12),
            child: Row(
              children: [
                if (!_collapsed) ...[
                  Expanded(
                    child: Text(
                      '主题库',
                      style: theme.textTheme.p.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showCreateDialog(context),
                    child: Icon(LucideIcons.plus, size: 16, color: theme.colorScheme.mutedForeground),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _collapsed = true),
                    child: Icon(LucideIcons.panelLeftClose, size: 16, color: theme.colorScheme.mutedForeground),
                  ),
                ] else ...[
                  GestureDetector(
                    onTap: () => setState(() => _collapsed = false),
                    child: Icon(LucideIcons.panelLeftOpen, size: 16, color: theme.colorScheme.mutedForeground),
                  ),
                ],
              ],
            ),
          ),

          // Search
          if (!_collapsed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ShadInput(
                initialValue: _query,
                onChanged: (v) => setState(() => _query = v),
                placeholder: const Text('搜索主题...'),
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(LucideIcons.search, size: 14, color: theme.colorScheme.mutedForeground),
                ),
              ),
            ),

          // Theme list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 4, left: _collapsed ? 8 : 4, right: _collapsed ? 8 : 4),
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
              child: GestureDetector(
                onTap: () => _showCreateDialog(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.muted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(LucideIcons.plus, size: 18, color: theme.colorScheme.primary),
                ),
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
    final theme = ShadTheme.of(context);

    if (widget.collapsed) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: widget.active ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: widget.active ? Border.all(color: theme.colorScheme.primary) : null,
            ),
            child: Center(
              child: Text(
                widget.theme.name.length <= 2 ? widget.theme.name : widget.theme.name.substring(0, 2),
                style: theme.textTheme.small.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.active ? theme.colorScheme.primary : theme.colorScheme.mutedForeground,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: widget.onTap,
        onDoubleTap: () => setState(() => _renaming = true),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: widget.active ? theme.colorScheme.muted : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: theme.colorScheme.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  LucideIcons.wand2,
                  size: 16,
                  color: theme.colorScheme.accent,
                ),
              ),
              const SizedBox(width: 10),

              // Name + summary
              Expanded(
                child: _renaming
                    ? SizedBox(
                        height: 28,
                        child: TextField(
                          controller: _renameController,
                          autofocus: true,
                          style: theme.textTheme.small,
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
                            style: theme.textTheme.small.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.theme.summary,
                            style: theme.textTheme.small.copyWith(
                              fontSize: 10,
                              color: theme.colorScheme.mutedForeground,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
              ),

              if (widget.active && !_renaming)
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: Icon(LucideIcons.moreHorizontal, size: 14, color: theme.colorScheme.mutedForeground),
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
            ],
          ),
        ),
      ),
    );
  }
}
