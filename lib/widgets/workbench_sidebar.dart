import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/theme.dart';
import '../providers/theme_provider.dart';
import '../theme/tokens.dart';
import 'icon_picker.dart';

// ═══════════════════════════════════════════════════════════
// WorkbenchSidebar — 主题库侧边栏
// ═══════════════════════════════════════════════════════════

class WorkbenchSidebar extends StatefulWidget {
  final Future<AsyncSaveResult> Function()? onSave;

  const WorkbenchSidebar({super.key, this.onSave});

  @override
  State<WorkbenchSidebar> createState() => _WorkbenchSidebarState();
}

class _WorkbenchSidebarState extends State<WorkbenchSidebar> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _prevSelectedId;

  bool _collapsed = false;
  String _actionError = '';

  // Switch-with-unsaved
  String? _pendingSwitchThemeId;
  bool _isSwitching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String? get _query {
    final q = _searchController.text.trim().toLowerCase();
    return q.isEmpty ? null : q;
  }

  List<ThemeItem> _filtered(List<ThemeItem> all) {
    final q = _query;
    if (q == null) return all;
    return all.where((t) {
      final name = t.name.toLowerCase();
      final summary = t.summary.toLowerCase();
      final kind = t.kind.toLowerCase();
      return name.contains(q) || summary.contains(q) || kind.contains(q);
    }).toList();
  }

  void _scrollToSelected(List<ThemeItem> library, String selectedId) {
    if (!_scrollController.hasClients) return;
    final idx = library.indexWhere((t) => t.id == selectedId);
    if (idx < 0) return;
    const cardHeight = 64.0;
    final target = idx * cardHeight;
    final maxScroll = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      target.clamp(0, maxScroll),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  /// Run a theme action and catch errors.
  void _runThemeAction(VoidCallback action) {
    try {
      action();
      setState(() => _actionError = '');
    } catch (e) {
      setState(() => _actionError = e.toString());
      _showToast(
        context,
        title: '主题操作失败',
        description: e.toString().replaceFirst('Exception: ', ''),
        destructive: true,
      );
    }
  }

  // ── Handlers ─────────────────────────────────────────---

  void _handleThemeClick(String targetId, ThemeProvider theme) {
    if (targetId == theme.selectedThemeId) return;
    if ((theme.dirtyThemes[theme.selectedThemeId] ?? false)) {
      setState(() => _pendingSwitchThemeId = targetId);
      showSwitchConfirmDialog(
        context: context,
        currentThemeName: theme.activeTheme.name,
        isSaving: theme.isSaving || _isSwitching,
        onSaveAndSwitch: () => _handleSaveAndSwitch(theme),
        onDiscardAndSwitch: () => _handleDiscardAndSwitch(theme),
        onCancel: () => setState(() => _pendingSwitchThemeId = null),
      );
      return;
    }
    theme.setThemeId(targetId);
  }

  Future<void> _handleSaveAndSwitch(ThemeProvider theme) async {
    if (_pendingSwitchThemeId == null) return;
    setState(() => _isSwitching = true);
    try {
      if (widget.onSave != null) {
        final result = await widget.onSave!();
        if (!mounted) return;
        if (result.ok) {
          theme.setThemeId(_pendingSwitchThemeId!);
          _showToast(
            context,
            title: '已保存并切换主题',
          );
        } else {
          _showToast(
            context,
            title: '保存失败',
            description: result.error ?? '请稍后重试',
            destructive: true,
          );
        }
      } else {
        theme.saveChanges();
        theme.setThemeId(_pendingSwitchThemeId!);
      }
    } catch (e) {
      if (!mounted) return;
      _showToast(
        context,
        title: '保存失败',
        description: e.toString().replaceFirst('Exception: ', ''),
        destructive: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSwitching = false;
          _pendingSwitchThemeId = null;
        });
      }
    }
  }

  void _handleDiscardAndSwitch(ThemeProvider theme) {
    if (_pendingSwitchThemeId == null) return;
    theme.discardThemeChanges(theme.selectedThemeId);
    theme.setThemeId(_pendingSwitchThemeId!);
    setState(() => _pendingSwitchThemeId = null);
  }

  void _handleExportTheme(String themeId, ThemeProvider theme) {
    final jsonText = theme.exportTheme(themeId);
    _showExportDialog(context, jsonText);
  }

  void _handleDuplicateTheme(String themeId, ThemeProvider theme) {
    _runThemeAction(() => theme.duplicateTheme(themeId));
    _showToast(context, title: '已复制主题');
  }

  void _handleDeleteTheme(ThemeItem item, ThemeProvider theme) {
    showShadDialog(
      context: context,
      builder: (ctx) => ShadDialog(
        title: Text('删除「${item.name}」？'),
        description: const Text('删除后无法恢复，确认要继续吗？'),
        actions: [
          ShadButton.ghost(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          ShadButton.destructive(
            onPressed: () {
              Navigator.of(ctx).pop();
              _runThemeAction(() {
                theme.deleteTheme(item.id);
                _showToast(
                  context,
                  title: '已移除主题',
                  description: '${item.name} 将在保存后从配置中删除。',
                );
              });
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  // ── Toast helper ────────────────────────────────────────

  static void _showToast(
    BuildContext context, {
    required String title,
    String? description,
    bool destructive = false,
  }) {
    ShadToaster.of(context).show(
      destructive
          ? ShadToast.destructive(
              title: Text(title),
              description: description != null ? Text(description) : null,
            )
          : ShadToast(
              title: Text(title),
              description: description != null ? Text(description) : null,
            ),
    );
  }

  // ═════════════════════════════════════════════════════════
  // Build
  // ═════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final theme = context.watch<ThemeProvider>();
    final library = theme.themeLibrary;
    final selectedId = theme.selectedThemeId;
    final filtered = _filtered(library);

    // Auto-scroll to selected
    if (selectedId != _prevSelectedId) {
      _prevSelectedId = selectedId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelected(filtered, selectedId);
      });
    }

    final sidebar = _collapsed
        ? _buildCollapsed(context, cs, theme, library, selectedId)
        : _buildExpanded(context, cs, theme, library, filtered, selectedId);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: _collapsed ? 76.0 : 304.0,
      decoration: BoxDecoration(
        color: cs.card,
        border: Border(right: BorderSide(color: cs.border)),
        boxShadow: ShadowTokens.card,
      ),
      child: Column(
        children: [
          Expanded(child: sidebar),
          _ImportFooter(
            collapsed: _collapsed,
            onImport: () => _openComposer('import'),
          ),
        ],
      ),
    );
  }

  // ── Collapsed layout ────────────────────────────────────

  Widget _buildCollapsed(
    BuildContext context,
    ShadColorScheme cs,
    ThemeProvider theme,
    List<ThemeItem> library,
    String selectedId,
  ) {
    return Column(
      children: [
        const SizedBox(height: Spacing.sm),
        // Expand button
        ShadButton.ghost(
          onPressed: () => setState(() => _collapsed = false),
          size: ShadButtonSize.sm,
          padding: const EdgeInsets.all(Spacing.sm),
          leading: const Icon(LucideIcons.panelLeftOpen, size: IconSizes.md),
          child: const SizedBox.shrink(),
        ),
        const SizedBox(height: Spacing.xs),
        // New theme button
        ShadButton.ghost(
          onPressed: () => _openComposer('create'),
          size: ShadButtonSize.sm,
          padding: const EdgeInsets.all(Spacing.sm),
          leading: const Icon(LucideIcons.plus, size: IconSizes.md),
          child: const SizedBox.shrink(),
        ),
        const SizedBox(height: Spacing.sm),
        // Theme icons
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
            itemCount: library.length,
            itemBuilder: (context, index) {
              final item = library[index];
              final selected = item.id == selectedId;
              final dirty = theme.dirtyThemes[item.id] ?? false;
              return Padding(
                padding: const EdgeInsets.only(bottom: Spacing.xs),
                child: _CollapsedThemeIcon(
                  item: item,
                  selected: selected,
                  dirty: dirty,
                  onTap: () => _handleThemeClick(item.id, theme),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Expanded layout ─────────────────────────────────────

  Widget _buildExpanded(
    BuildContext context,
    ShadColorScheme cs,
    ThemeProvider theme,
    List<ThemeItem> library,
    List<ThemeItem> filtered,
    String selectedId,
  ) {
    return Column(
      children: [
        // Header: collapse + search + new
        _SidebarHeader(
          collapsed: false,
          searchController: _searchController,
          onCollapse: () => setState(() => _collapsed = true),
          onNewTheme: () => _openComposer('create'),
        ),

        // Action error banner
        if (_actionError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.sm, 0, Spacing.sm, Spacing.xs),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.sm),
              decoration: BoxDecoration(
                color: cs.destructive.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(RadiusTokens.lg),
                border: Border.all(color: cs.destructive.withValues(alpha: 0.3)),
              ),
              child: Text(
                _actionError,
                style: TextStyle(fontSize: FontSizes.micro, color: cs.destructive),
              ),
            ),
          ),

        // Theme list
        Expanded(
          child: filtered.isEmpty
              ? _EmptyState(
                  onNewTheme: () => _openComposer('create'),
                  hasQuery: _query != null,
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(Spacing.sm, 0, Spacing.sm, Spacing.sm),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final selected = item.id == selectedId;
                    final dirty = theme.dirtyThemes[item.id] ?? false;
                    final canDelete = item.kind != '内置' && library.length > 1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.xs),
                      child: ThemeCard(
                        item: item,
                        selected: selected,
                        dirty: dirty,
                        canDelete: canDelete,
                        onTap: () => _handleThemeClick(item.id, theme),
                        onDuplicate: () => _handleDuplicateTheme(item.id, theme),
                        onExport: () => _handleExportTheme(item.id, theme),
                        onDelete: canDelete
                            ? () => _handleDeleteTheme(item, theme)
                            : null,
                        onRename: (id, name) => theme.renameTheme(id, name),
                        onUpdateIcon: (id, icon) => theme.updateThemeIcon(id, icon),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ═════════════════════════════════════════════════════════
  // Dialogs (built as methods so they can use this.state)
  // ═════════════════════════════════════════════════════════

  /// Open ThemeComposerDialog in create or import mode.
  void _openComposer(String mode) {
    showShadDialog(
      context: context,
      builder: (ctx) => ThemeComposerDialog(
        mode: mode,
        onClose: () => Navigator.of(ctx).pop(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Sidebar Header (expanded)
// ═══════════════════════════════════════════════════════════

class _SidebarHeader extends StatelessWidget {
  final bool collapsed;
  final TextEditingController searchController;
  final VoidCallback onCollapse;
  final VoidCallback onNewTheme;

  const _SidebarHeader({
    required this.collapsed,
    required this.searchController,
    required this.onCollapse,
    required this.onNewTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(Spacing.sm, Spacing.sm, Spacing.sm, Spacing.sm),
      child: Row(
        children: [
          ShadButton.ghost(
            onPressed: onCollapse,
            size: ShadButtonSize.sm,
            padding: const EdgeInsets.all(Spacing.sm),
            leading: const Icon(LucideIcons.panelLeftClose, size: IconSizes.md),
            child: const SizedBox.shrink(),
          ),
          const SizedBox(width: Spacing.xs),
          Expanded(
            child: ShadInput(
              controller: searchController,
              placeholder: const Text('搜索主题包'),
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
            ),
          ),
          const SizedBox(width: Spacing.xs),
          ShadButton(
            onPressed: onNewTheme,
            size: ShadButtonSize.sm,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
            leading: const Icon(LucideIcons.plus, size: IconSizes.md),
            child: const Text('新建', style: TextStyle(fontSize: FontSizes.small)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Import Footer
// ═══════════════════════════════════════════════════════════

class _ImportFooter extends StatelessWidget {
  final bool collapsed;
  final VoidCallback onImport;

  const _ImportFooter({required this.collapsed, required this.onImport});

  @override
  Widget build(BuildContext context) {
    if (collapsed) return const SizedBox.shrink();
    final cs = ShadTheme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cs.border)),
      ),
      child: ShadButton.outline(
        onPressed: onImport,
        width: double.infinity,
        size: ShadButtonSize.sm,
        leading: const Icon(LucideIcons.upload, size: IconSizes.md),
        child: const Text('导入主题', style: TextStyle(fontSize: FontSizes.small)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Empty State
// ═══════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final VoidCallback onNewTheme;
  final bool hasQuery;

  const _EmptyState({required this.onNewTheme, required this.hasQuery});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.search, size: 24, color: cs.mutedForeground),
            const SizedBox(height: Spacing.sm),
            Text(
              hasQuery ? '没有找到匹配的主题' : '暂无主题',
              style: TextStyle(
                fontSize: FontSizes.small,
                fontWeight: FontWeight.w600,
                color: cs.foreground,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              hasQuery ? '换个关键词，或者新建一个主题继续编辑。' : '点击上方按钮创建你的第一个主题。',
              style: TextStyle(fontSize: FontSizes.micro, color: cs.mutedForeground),
              textAlign: TextAlign.center,
            ),
            if (hasQuery) ...[
              const SizedBox(height: Spacing.md),
              ShadButton.outline(
                onPressed: onNewTheme,
                size: ShadButtonSize.sm,
                leading: const Icon(LucideIcons.plus, size: IconSizes.md),
                child: const Text('新建一个主题', style: TextStyle(fontSize: FontSizes.small)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Collapsed Theme Icon
// ═══════════════════════════════════════════════════════════

class _CollapsedThemeIcon extends StatelessWidget {
  final ThemeItem item;
  final bool selected;
  final bool dirty;
  final VoidCallback onTap;

  const _CollapsedThemeIcon({
    required this.item,
    required this.selected,
    required this.dirty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final toneColor = resolveToneColor(item.id);
    final icon = resolveIcon(item.icon);

    return Tooltip(
      message: item.name,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: selected ? toneColor.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(RadiusTokens.lg),
            border: selected
                ? Border.all(color: toneColor.withValues(alpha: 0.4))
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(icon, size: IconSizes.md, color: toneColor),
              ),
              if (selected)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              if (dirty)
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: toneColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ThemeCard — 完整功能卡片
// ═══════════════════════════════════════════════════════════

class ThemeCard extends StatefulWidget {
  final ThemeItem item;
  final bool selected;
  final bool dirty;
  final bool canDelete;
  final VoidCallback onTap;
  final VoidCallback onDuplicate;
  final VoidCallback onExport;
  final VoidCallback? onDelete;
  final void Function(String id, String name)? onRename;
  final void Function(String id, String icon)? onUpdateIcon;

  const ThemeCard({
    super.key,
    required this.item,
    required this.selected,
    required this.dirty,
    required this.canDelete,
    required this.onTap,
    required this.onDuplicate,
    required this.onExport,
    this.onDelete,
    this.onRename,
    this.onUpdateIcon,
  });

  @override
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> {
  bool _editingName = false;
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus && _editingName) {
        _commitRename();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _startRename() {
    _nameController.text = widget.item.name;
    setState(() => _editingName = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocusNode.requestFocus();
    });
  }

  void _commitRename() {
    if (!_editingName) return;
    final trimmed = _nameController.text.trim();
    setState(() => _editingName = false);
    if (trimmed.isNotEmpty && trimmed != widget.item.name) {
      widget.onRename?.call(widget.item.id, trimmed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final toneColor = resolveToneColor(widget.item.id);
    final icon = resolveIcon(widget.item.icon);

    return Container(
      decoration: BoxDecoration(
        color: widget.selected ? cs.accent.withValues(alpha: 0.5) : Colors.transparent,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(
          color: widget.selected
              ? cs.accent
              : Colors.transparent,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main clickable area
          GestureDetector(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Spacing.sm, Spacing.sm, Spacing.sm, Spacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon (clickable for picker)
                  GestureDetector(
                    onTap: () {
                      _showIconPicker(context, toneColor);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: widget.selected
                            ? toneColor.withValues(alpha: 0.2)
                            : toneColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(RadiusTokens.md),
                      ),
                      child: Icon(icon, size: IconSizes.sm, color: toneColor),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  // Name + summary (fixed width, no Expanded in ListView)
                  SizedBox(
                    width: 152,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (_editingName)
                              SizedBox(
                                width: 120,
                                height: 24,
                                child: TextField(
                                  controller: _nameController,
                                  focusNode: _nameFocusNode,
                                  maxLength: 30,
                                  style: TextStyle(
                                    fontSize: FontSizes.small,
                                    fontWeight: FontWeight.w600,
                                    color: cs.foreground,
                                    decoration: TextDecoration.none,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: Spacing.xs,
                                      vertical: 0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(RadiusTokens.sm),
                                      borderSide: BorderSide(color: cs.border),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(RadiusTokens.sm),
                                      borderSide: BorderSide(color: cs.ring),
                                    ),
                                    counterText: '',
                                  ),
                                  onSubmitted: (_) => _commitRename(),
                                ),
                              )
                            else ...[
                              GestureDetector(
                                onDoubleTap: _startRename,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 100),
                                  child: Text(
                                    widget.item.name,
                                    style: TextStyle(
                                      fontSize: FontSizes.small,
                                      fontWeight: widget.selected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: cs.foreground,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // Edit icon button
                              GestureDetector(
                                onTap: _startRename,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Icon(
                                    LucideIcons.pencil,
                                    size: 10,
                                    color: cs.mutedForeground.withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                            ],
                            if (!_editingName) ...[
                              const SizedBox(width: Spacing.xs),
                              // Kind badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: cs.muted.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  widget.item.kind,
                                  style: TextStyle(
                                    fontSize: FontSizes.micro,
                                    color: cs.mutedForeground,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (widget.item.summary.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              widget.item.summary,
                              style: TextStyle(
                                fontSize: FontSizes.micro,
                                color: cs.mutedForeground,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Dirty dot
                  if (widget.dirty)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Container(
                        width: IndicatorTokens.dirtyDot,
                        height: IndicatorTokens.dirtyDot,
                        decoration: BoxDecoration(
                          color: toneColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  // More menu
                  PopupMenuButton<String>(
                    tooltip: '更多操作',
                    padding: EdgeInsets.zero,
                    iconSize: IconSizes.md,
                    icon: Icon(
                      LucideIcons.moreHorizontal,
                      size: IconSizes.md,
                      color: cs.mutedForeground,
                    ),
                    color: cs.popover,
                    onSelected: (value) {
                      switch (value) {
                        case 'rename':
                          _startRename();
                          break;
                        case 'duplicate':
                          widget.onDuplicate();
                          break;
                        case 'export':
                          widget.onExport();
                          break;
                        case 'delete':
                          widget.onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'rename',
                        height: 32,
                        child: Text('重命名', style: TextStyle(fontSize: FontSizes.small)),
                      ),
                      const PopupMenuItem(
                        value: 'duplicate',
                        height: 32,
                        child: Text('复制', style: TextStyle(fontSize: FontSizes.small)),
                      ),
                      const PopupMenuItem(
                        value: 'export',
                        height: 32,
                        child: Text('导出 JSON', style: TextStyle(fontSize: FontSizes.small)),
                      ),
                      if (widget.canDelete)
                        PopupMenuItem(
                          value: 'delete',
                          height: 32,
                          child: Text(
                            '删除',
                            style: TextStyle(
                              fontSize: FontSizes.small,
                              color: cs.destructive,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Divider
          if (!widget.selected)
            Divider(height: 0, thickness: 0.5, color: cs.border.withValues(alpha: 0.3)),
        ],
      ),
    );
  }

  void _showIconPicker(BuildContext context, Color toneColor) {
    showShadDialog(
      context: context,
      builder: (ctx) => ShadDialog(
        title: const Text('更换图标'),
        description: const Text('选择一个图标来代表这个主题'),
        actions: [
          ShadButton.ghost(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
        ],
        child: IconPicker(
          selectedIcon: widget.item.icon,
          toneColor: toneColor,
          onSelect: (name) {
            widget.onUpdateIcon?.call(widget.item.id, name);
            Navigator.of(ctx).pop();
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ThemeComposerDialog — 新建 + 导入
// ═══════════════════════════════════════════════════════════

class ThemeComposerDialog extends StatefulWidget {
  final String mode; // 'create' | 'import'
  final VoidCallback onClose;

  const ThemeComposerDialog({
    super.key,
    required this.mode,
    required this.onClose,
  });

  @override
  State<ThemeComposerDialog> createState() => _ThemeComposerDialogState();
}

class _ThemeComposerDialogState extends State<ThemeComposerDialog> {
  String _mode = 'create';

  // Create fields
  final _nameController = TextEditingController();
  String? _baseThemeId;
  String? _createError;

  // Import fields
  final _importController = TextEditingController();
  String? _importError;

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
    final theme = context.read<ThemeProvider>();
    _baseThemeId = theme.selectedThemeId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _importController.dispose();
    super.dispose();
  }

  List<_TemplateOption> _templateOptions(BuildContext context) {
    final theme = context.read<ThemeProvider>();
    return [
      const _TemplateOption(id: 'blank', label: '空白主题'),
      ...theme.themeLibrary.map(
        (t) => _TemplateOption(id: t.id, label: t.name),
      ),
    ];
  }

  void _handleCreate() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final theme = context.read<ThemeProvider>();
    try {
      theme.createTheme(name, basedOnThemeId: _baseThemeId);
      setState(() => _createError = null);
      widget.onClose();
      _showToast(context, title: '已创建主题', description: name);
    } catch (e) {
      setState(() => _createError = e.toString());
    }
  }

  void _handleImport() {
    final text = _importController.text.trim();
    if (text.isEmpty) return;
    final theme = context.read<ThemeProvider>();
    try {
      final error = theme.importThemeFromText(text, 'imported');
      if (error != null) {
        setState(() => _importError = error);
      } else {
        widget.onClose();
        _showToast(context, title: '已导入主题');
      }
    } catch (e) {
      setState(() => _importError = e.toString());
    }
  }

  static void _showToast(BuildContext context, {required String title, String? description}) {
    ShadToaster.of(context).show(
      ShadToast(title: Text(title), description: description != null ? Text(description) : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final options = _templateOptions(context);

    return ShadDialog(
      title: Text(_mode == 'create' ? '新建主题' : '导入主题'),
      description: Text(
        _mode == 'create'
            ? '新建一个可编辑主题'
            : '粘贴主题 JSON 配置',
      ),
      actions: [
        ShadButton.ghost(
          onPressed: widget.onClose,
          child: const Text('取消'),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab bar
          Container(
            decoration: BoxDecoration(
              color: cs.muted,
              borderRadius: BorderRadius.circular(RadiusTokens.lg),
            ),
            child: Row(
              children: [
                _TabButton(
                  label: '新建主题',
                  selected: _mode == 'create',
                  onTap: () => setState(() => _mode = 'create'),
                ),
                _TabButton(
                  label: '导入 JSON',
                  selected: _mode == 'import',
                  onTap: () => setState(() => _mode = 'import'),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),

          if (_mode == 'create') ...[
            // Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('主题名称',
                    style: TextStyle(fontSize: FontSizes.micro, fontWeight: FontWeight.w500, color: cs.mutedForeground)),
                const SizedBox(height: 4),
                ShadInput(
                  controller: _nameController,
                  placeholder: const Text('例如：Warm Click Studio'),
                  autofocus: true,
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            // Template
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('起始模板',
                    style: TextStyle(fontSize: FontSizes.micro, fontWeight: FontWeight.w500, color: cs.mutedForeground)),
                const SizedBox(height: 4),
                DropdownButton<String>(
                  value: _baseThemeId,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  items: options.map((opt) {
                    return DropdownMenuItem(
                      value: opt.id,
                      child: Text(opt.label, style: const TextStyle(fontSize: FontSizes.small)),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _baseThemeId = v);
                  },
                ),
              ],
            ),
            if (_createError != null) ...[
              const SizedBox(height: Spacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: cs.destructive.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(RadiusTokens.lg),
                ),
                child: Text(_createError!, style: TextStyle(fontSize: FontSizes.micro, color: cs.destructive)),
              ),
            ],
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(Spacing.sm),
                    decoration: BoxDecoration(
                      color: cs.muted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(RadiusTokens.lg),
                    ),
                    child: Text(
                      '新主题会先进入工作台，保存后写入配置。',
                      style: TextStyle(fontSize: FontSizes.micro, color: cs.mutedForeground),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                ShadButton(
                  onPressed: _handleCreate,
                  leading: const Icon(LucideIcons.plus, size: IconSizes.md),
                  child: const Text('创建主题'),
                ),
              ],
            ),
          ] else ...[
            // Import tab
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                border: Border.all(color: cs.border, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(RadiusTokens.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Spacing.sm),
                        decoration: BoxDecoration(
                          color: cs.muted,
                          borderRadius: BorderRadius.circular(RadiusTokens.lg),
                        ),
                        child: Icon(LucideIcons.fileJson, size: IconSizes.md, color: cs.foreground),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('粘贴本地 JSON 主题配置',
                                style: TextStyle(fontSize: FontSizes.small, fontWeight: FontWeight.w500, color: cs.foreground)),
                            const SizedBox(height: 2),
                            Text('支持单个主题对象或带 themePack 包裹的 JSON。',
                                style: TextStyle(fontSize: FontSizes.micro, color: cs.mutedForeground)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  ShadInput(
                    controller: _importController,
                    placeholder: const Text('粘贴 JSON...'),
                    maxLines: 4,
                    minLines: 2,
                  ),
                  if (_importError != null) ...[
                    const SizedBox(height: Spacing.sm),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Spacing.sm),
                      decoration: BoxDecoration(
                        color: cs.destructive.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(RadiusTokens.lg),
                      ),
                      child: Text(_importError!, style: TextStyle(fontSize: FontSizes.micro, color: cs.destructive)),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: ShadButton(
                onPressed: _handleImport,
                leading: const Icon(LucideIcons.upload, size: IconSizes.md),
                child: const Text('导入'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TemplateOption {
  final String id;
  final String label;
  const _TemplateOption({required this.id, required this.label});
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: selected ? cs.card : Colors.transparent,
            borderRadius: BorderRadius.circular(RadiusTokens.lg),
            border: selected ? Border.all(color: cs.border) : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FontSizes.small,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
              color: selected ? cs.foreground : cs.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Export dialog (standalone)
// ═══════════════════════════════════════════════════════════

void _showExportDialog(BuildContext context, String jsonText) {
  showShadDialog(
    context: context,
    builder: (ctx) => ShadDialog(
      title: const Text('导出主题'),
      description: const Text('复制以下 JSON 保存主题配置'),
      actions: [
        ShadButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: jsonText));
            Navigator.of(ctx).pop();
          },
          leading: const Icon(LucideIcons.copy, size: IconSizes.md),
          child: const Text('复制'),
        ),
      ],
      child: Container(
        constraints: const BoxConstraints(maxHeight: 200),
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: ShadTheme.of(ctx).colorScheme.muted,
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
        ),
        child: SingleChildScrollView(
          child: SelectableText(
            jsonText,
            style: TextStyle(
              fontSize: FontSizes.micro,
              fontFamily: 'monospace',
              color: ShadTheme.of(ctx).colorScheme.foreground,
            ),
          ),
        ),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════
// SwitchConfirmDialog — built inline via builder
// ═══════════════════════════════════════════════════════════

// The switch confirm dialog is shown from the sidebar state directly.
// We export a builder function for use in ConfigPage.

void showSwitchConfirmDialog({
  required BuildContext context,
  required String currentThemeName,
  required bool isSaving,
  required VoidCallback onSaveAndSwitch,
  required VoidCallback onDiscardAndSwitch,
  required VoidCallback onCancel,
}) {
  showShadDialog(
    context: context,
    builder: (ctx) => ShadDialog(
      title: Text('「$currentThemeName」有未保存的更改'),
      description: const Text(
        '切换主题前要保存这些更改吗？不保存的更改不会丢失，但关闭页面后会消失。',
      ),
      actions: [
        ShadButton.ghost(
          onPressed: () {
            onCancel();
            Navigator.of(ctx).pop();
          },
          child: const Text('取消'),
        ),
        ShadButton.ghost(
          onPressed: () {
            onDiscardAndSwitch();
            Navigator.of(ctx).pop();
          },
          child: const Text('不保存直接切换'),
        ),
        ShadButton(
          onPressed: isSaving
              ? null
              : () {
                  onSaveAndSwitch();
                  Navigator.of(ctx).pop();
                },
          child: Text(isSaving ? '保存中...' : '保存并切换'),
        ),
      ],
    ),
  );
}