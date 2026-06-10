import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/theme.dart';
import '../providers/theme_provider.dart';
import '../theme/app_tokens.dart';
import '../theme/animations.dart';
import 'base/empty_state.dart';
import 'base/info_banner.dart';
import 'base/panel_utils.dart';
import 'controls/app_icon_button.dart';
import 'controls/icon_resolver.dart';
import 'theme_card.dart';
import 'theme_composer_modal.dart';

/// 侧栏工作台 — V2 · 色调
///
/// - 28px 大色点，更强视觉权重
/// - pill 式筛选标签（圆角 20px）
/// - 搜索框圆角 + focus 光晕
/// - 展开/折叠双态
class WorkbenchSidebar extends StatefulWidget {
  const WorkbenchSidebar({super.key});

  @override
  State<WorkbenchSidebar> createState() => _WorkbenchSidebarState();
}

class _WorkbenchSidebarState extends State<WorkbenchSidebar> {
  bool _collapsed = false;
  String _categoryFilter = 'all';
  final _searchController = TextEditingController();
  String _query = '';
  int _focusedIndex = 0;
  String _actionError = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  ThemeProvider get _theme => context.read<ThemeProvider>();

  List<ThemeItem> get _filteredThemes {
    var themes = _theme.themeLibrary;
    switch (_categoryFilter) {
      case 'builtin':
        themes = themes.where((t) => t.kind == '内置').toList();
      case 'custom':
        themes = themes.where((t) => t.kind == '自定义').toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      themes = themes.where((t) =>
          t.name.toLowerCase().contains(q) ||
          t.summary.toLowerCase().contains(q)).toList();
    }
    return themes;
  }

  void _clearError() => setState(() => _actionError = '');

  void _runAction(String label, VoidCallback action) {
    try {
      action();
      _clearError();
    } catch (e) {
      setState(() => _actionError = '$label 失败：$e');
    }
  }

  void _handleThemeClick(String targetId) {
    if (targetId == _theme.selectedThemeId) return;
    _clearError();
    if (_theme.dirtyThemes[_theme.selectedThemeId] == true) {
      _confirmSwitchTheme(targetId);
      return;
    }
    _theme.setThemeId(targetId);
  }

  void _handleExport(ThemeItem theme) {
    _runAction('导出主题', () {
      final json = _theme.exportTheme(theme.id);
      Clipboard.setData(ClipboardData(text: json));
      _showToast('「${theme.name}」已复制到剪贴板');
    });
  }

  void _showToast(String message) {
    if (!mounted) return;
    ShadToaster.of(context).show(ShadToast(
      title: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  void _showComposerModal() {
    showShadDialog(
      context: context,
      builder: (_) => const ThemeComposerModal(),
    );
  }

  void _confirmDelete(ThemeItem theme) {
    _clearError();
    showShadDialog(
      context: context,
      builder: (ctx) => ShadDialog.alert(
        title: Text('删除「${theme.name}」？'),
        description: const Text('此操作会在下次保存时生效。'),
        actions: [
          ShadButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          ShadButton.destructive(
            onPressed: () {
              _theme.deleteTheme(theme.id);
              Navigator.of(ctx).pop();
              _showToast('已移除「${theme.name}」');
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _confirmSwitchTheme(String targetId) {
    final currentName = _theme.activeTheme.name;
    final target = _theme.themeLibrary.firstWhere((t) => t.id == targetId);
    showShadDialog(
      context: context,
      builder: (ctx) => ShadDialog.alert(
        title: const Text('未保存的更改'),
        description: Text(
          '「$currentName」有未保存的更改。'
          '切换到「${target.name}」前要保存这些更改吗？',
        ),
        actions: [
          ShadButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          ShadButton(
            onPressed: () {
              _theme.discardThemeChanges(_theme.selectedThemeId);
              _theme.setThemeId(targetId);
              Navigator.of(ctx).pop();
            },
            child: const Text('不保存直接切换'),
          ),
          ShadButton(
            onPressed: () {
              _theme.saveChanges().then((_) {
                _theme.setThemeId(targetId);
                if (ctx.mounted) Navigator.of(ctx).pop();
              });
            },
            child: const Text('保存并切换'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final cs = ShadTheme.of(context).colorScheme;

    return AnimatedContainer(
      duration: AppAnimations.slow,
      width: _collapsed ? kSidebarCollapsedWidth : kSidebarExpandedWidth,
      decoration: BoxDecoration(
        color: cs.card,
        border: Border(right: BorderSide(color: cs.border)),
      ),
      child: _collapsed
          ? _CollapsedSidebar(
              themes: _filteredThemes,
              selectedId: theme.selectedThemeId,
              onSelect: _handleThemeClick,
              onExpand: () => setState(() => _collapsed = false),
              onCreate: () {
                _clearError();
                _showComposerModal();
              },
            )
          : Column(children: [
              _ExpandedHeader(
                onCreate: () {
                  _clearError();
                  _showComposerModal();
                },
                onCollapse: () => setState(() => _collapsed = true),
              ),
              _CategoryFilter(
                current: _categoryFilter,
                onChanged: (v) => setState(() {
                  _categoryFilter = v;
                  _focusedIndex = 0;
                }),
              ),
              _SearchBar(
                controller: _searchController,
                query: _query,
                onChanged: (v) => setState(() => _query = v),
                onClear: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              ),
              if (_actionError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(Spacing.sm, 2, Spacing.sm, Spacing.xs),
                  child: InfoBanner(
                    message: _actionError,
                    type: InfoBannerType.error,
                    onDismiss: _clearError,
                  ),
                ),
              Expanded(child: _buildThemeList(theme, cs)),
            ]),
    );
  }

  Widget _buildThemeList(ThemeProvider theme, ShadColorScheme cs) {
    final themes = _filteredThemes;

    if (themes.isEmpty) {
      final (icon, title, subtitle) = switch (_categoryFilter) {
        'builtin' => (LucideIcons.package, '暂无内置主题', '所有内置主题可能已被删除。'),
        'custom' => (LucideIcons.penSquare, '暂无自定义主题', '点击上方的 + 新建一个主题。'),
        _ => (
          LucideIcons.search,
          _query.isNotEmpty ? '没有找到匹配的主题' : '暂无可用主题',
          _query.isNotEmpty ? '试试其他关键词？' : '新建一个主题，或导入已有主题包。',
        ),
      };
      return EmptyState(
        icon: icon,
        title: title,
        subtitle: subtitle,
        actionLabel: _query.isEmpty ? '新建主题' : null,
        onAction: _query.isEmpty
            ? () {
                _clearError();
                _showComposerModal();
              }
            : null,
      );
    }

    if (_focusedIndex >= themes.length) _focusedIndex = 0;

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          setState(() => _focusedIndex = (_focusedIndex + 1) % themes.length);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          setState(() =>
              _focusedIndex = (_focusedIndex - 1 + themes.length) % themes.length);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.enter && themes.isNotEmpty) {
          _handleThemeClick(themes[_focusedIndex].id);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.escape && _query.isNotEmpty) {
          _searchController.clear();
          setState(() => _query = '');
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: Spacing.xs),
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final t = themes[index];
          return ThemeCard(
            key: ValueKey(t.id),
            theme: t,
            active: t.id == theme.selectedThemeId,
            focused: index == _focusedIndex,
            isDirty: theme.dirtyThemes[t.id] == true,
            canDelete: t.kind != '内置' && theme.themeLibrary.length > 1,
            onTap: () => _handleThemeClick(t.id),
            onRename: (name) => theme.renameTheme(t.id, name),
            onDelete: () => _confirmDelete(t),
            onDuplicate: () => _runAction('复制主题', () {
              theme.duplicateTheme(t.id);
              _showToast('已复制主题「${t.name}」');
            }),
            onExport: () => _handleExport(t),
            onUpdateIcon: (icon) => theme.updateThemeIcon(t.id, icon),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Collapsed sidecar widget
// ═══════════════════════════════════════════════════════════════

class _CollapsedSidebar extends StatelessWidget {
  final List<ThemeItem> themes;
  final String selectedId;
  final ValueChanged<String> onSelect;
  final VoidCallback onExpand;
  final VoidCallback onCreate;

  const _CollapsedSidebar({
    required this.themes,
    required this.selectedId,
    required this.onSelect,
    required this.onExpand,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Column(children: [
      // Expand top
      Padding(
        padding: const EdgeInsets.only(top: Spacing.sm),
        child: AppIconButton(
          icon: LucideIcons.panelLeftOpen,
          onTap: onExpand,
          tooltip: '展开侧栏',
        ),
      ),
      const SizedBox(height: Spacing.sm),
      // Theme dots
      Expanded(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
          itemExtent: 52,
          children: themes.map((t) {
            final active = t.id == selectedId;
            final toneColor = resolveToneColor(t.tone);
            return Center(
              child: GestureDetector(
                onTap: () => onSelect(t.id),
                child: AnimatedContainer(
                  duration: AppAnimations.fastish,
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: active ? cs.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(RadiusTokens.xl),
                    border: Border.all(
                      color: active ? cs.primary : cs.border,
                      width: active ? 1.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: toneColor,
                        borderRadius: BorderRadius.circular(RadiusTokens.sm),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      // Bottom actions
      Padding(
        padding: const EdgeInsets.all(Spacing.sm),
        child: Column(children: [
          AppIconButton(
            icon: LucideIcons.plus,
            onTap: onCreate,
            tooltip: '新建主题',
            size: 44,
            iconSize: IconSizes.lg,
          ),
        ]),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════
// Expanded header
// ═══════════════════════════════════════════════════════════════

class _ExpandedHeader extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onCollapse;

  const _ExpandedHeader({
    required this.onCreate,
    required this.onCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: cs.border)),
      ),
      child: Row(children: [
        Text(
          '主题库',
          style: TextStyle(
            fontSize: FontSizes.base,
            fontWeight: FontWeight.w600,
            color: cs.foreground,
          ),
        ),
        const Spacer(),
        AppIconButton(
          icon: LucideIcons.plus,
          onTap: onCreate,
          tooltip: '新建主题',
        ),
        const SizedBox(width: 2),
        AppIconButton(
          icon: LucideIcons.panelLeftClose,
          onTap: onCollapse,
          tooltip: '收起侧栏',
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Category filter pills (pill-style, 20px radius)
// ═══════════════════════════════════════════════════════════════

class _CategoryFilter extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;

  const _CategoryFilter({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.md, 10, Spacing.md, 6),
      child: Row(children: [
        _pill(context, cs, '全部', 'all'),
        const SizedBox(width: 4),
        _pill(context, cs, '内置', 'builtin'),
        const SizedBox(width: 4),
        _pill(context, cs, '自定义', 'custom'),
      ]),
    );
  }

  Widget _pill(BuildContext context, ShadColorScheme cs, String label, String value) {
    final active = current == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: AppAnimations.fastish,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: 4),
        decoration: BoxDecoration(
          color: active ? cs.primary : cs.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? cs.primary : cs.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: FontSizes.caption,
            fontWeight: FontWeight.w500,
            color: active ? cs.primaryForeground : cs.mutedForeground,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Search bar (rounded, muted bg, focus ring)
// ═══════════════════════════════════════════════════════════════

class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.md, 8, Spacing.md, 0),
      child: AnimatedContainer(
        duration: AppAnimations.fastish,
        height: 36,
        decoration: BoxDecoration(
          color: cs.muted,
          borderRadius: BorderRadius.circular(20),
          border: _hasFocus
              ? Border.all(color: cs.ring, width: 1.5)
              : null,
        ),
        child: Row(children: [
          const SizedBox(width: 10),
          Icon(LucideIcons.search, size: IconSizes.md, color: cs.mutedForeground.withValues(alpha: 0.6)),
          const SizedBox(width: 6),
          Expanded(
            child: Focus(
              onFocusChange: (focused) {
                if (mounted) setState(() => _hasFocus = focused);
              },
              child: ShadInput(
                controller: widget.controller,
                onChanged: widget.onChanged,
                placeholder: const Text('搜索主题...'),
                decoration: const ShadDecoration(
                  border: ShadBorder.none,
                ),
              ),
            ),
          ),
          if (widget.query.isNotEmpty)
            GestureDetector(
              onTap: widget.onClear,
              child: Padding(
                padding: const EdgeInsets.all(Spacing.xs),
                child: Icon(LucideIcons.x, size: IconSizes.sm, color: cs.mutedForeground),
              ),
            ),
          const SizedBox(width: 4),
        ]),
      ),
    );
  }
}
