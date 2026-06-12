import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/theme.dart';
import '../providers/theme_provider.dart';
import '../theme/tokens.dart';
import 'icon_picker.dart';
import 'sidebar_toast.dart';
import 'theme_card.dart';
import 'theme_composer_dialog.dart';

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

  T? _runThemeAction<T>(T Function() action) {
    try {
      final result = action();
      setState(() => _actionError = '');
      return result;
    } catch (e) {
      setState(() => _actionError = e.toString());
      showSidebarToast(
        context,
        title: '主题操作失败',
        description: e.toString().replaceFirst('Exception: ', ''),
        destructive: true,
      );
      return null;
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
          showSidebarToast(
            context,
            title: '已保存并切换主题',
          );
        } else {
          showSidebarToast(
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
      showSidebarToast(
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
    final ok = _runThemeAction(() { theme.duplicateTheme(themeId); return true; });
    if (ok != null) {
      showSidebarToast(context, title: '已复制主题');
    }
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
              final ok = _runThemeAction(() {
                theme.deleteTheme(item.id);
                return item.name;
              });
              if (ok != null) {
                showSidebarToast(
                  context,
                  title: '已移除主题',
                  description: '$ok 将在保存后从配置中删除。',
                );
              }
            },
            child: const Text('删除'),
          ),
        ],
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
        ? _buildCollapsed(context, cs, theme, filtered, selectedId)
        : _buildExpanded(context, cs, theme, library, filtered, selectedId);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: _collapsed ? 76.0 : 260.0,
      decoration: BoxDecoration(
        color: cs.card,
        border: Border(right: BorderSide(color: cs.border)),
        boxShadow: ShadowTokens.card,
      ),
      child: Column(
        children: [
          Expanded(child: sidebar),
          _SidebarFooter(
            collapsed: _collapsed,
            onNewTheme: () => _openComposer('create'),
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
    List<ThemeItem> filtered,
    String selectedId,
  ) {
    return Column(
      children: [
        const SizedBox(height: Spacing.sm),
        // Expand button
        ShadIconButton.ghost(
          onPressed: () => setState(() => _collapsed = false),
          icon: const Icon(LucideIcons.panelLeftOpen),
        ),
        const SizedBox(height: Spacing.xs),
        // New theme button
        ShadIconButton.ghost(
          onPressed: () => _openComposer('create'),
          icon: const Icon(LucideIcons.plus),
        ),
        const SizedBox(height: Spacing.sm),
        // Theme icons
        Expanded(
          child: filtered.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
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
          searchController: _searchController,
          onCollapse: () => setState(() => _collapsed = true),
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
  final TextEditingController searchController;
  final VoidCallback onCollapse;

  const _SidebarHeader({
    required this.searchController,
    required this.onCollapse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(Spacing.sm, Spacing.sm, Spacing.sm, Spacing.sm),
      child: Row(
        children: [
          ShadIconButton.ghost(
            onPressed: onCollapse,
            icon: const Icon(LucideIcons.panelLeftClose),
          ),
          const SizedBox(width: Spacing.xs),
          Expanded(
            child: ShadInput(
              controller: searchController,
              placeholder: const Text('搜索主题包'),
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Import Footer
// ═══════════════════════════════════════════════════════════

class _SidebarFooter extends StatelessWidget {
  final bool collapsed;
  final VoidCallback onNewTheme;

  const _SidebarFooter({required this.collapsed, required this.onNewTheme});

  @override
  Widget build(BuildContext context) {
    if (collapsed) return const SizedBox.shrink();
    final cs = ShadTheme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cs.border)),
      ),
      child: ShadButton(
        onPressed: onNewTheme,
        width: double.infinity,
        size: ShadButtonSize.sm,
        leading: const Icon(LucideIcons.plus, size: IconSizes.md),
        child: const Text('新建主题', style: TextStyle(fontSize: FontSizes.small)),
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