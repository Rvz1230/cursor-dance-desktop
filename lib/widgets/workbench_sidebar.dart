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
import 'theme_card.dart';
import 'theme_composer_modal.dart';

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
      themes = themes.where((t) {
        return t.name.toLowerCase().contains(q) ||
            t.summary.toLowerCase().contains(q);
      }).toList();
    }

    return themes;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final cs = ShadTheme.of(context).colorScheme;

    return AnimatedContainer(
      duration: AppAnimations.slow,
      width: _collapsed ? kSidebarCollapsedWidth : kSidebarExpandedWidth,
      decoration: BoxDecoration(
        color: cs.card,
        border: Border(
          right: BorderSide(color: cs.border),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(theme, cs),
          if (!_collapsed) _buildCategoryTabs(cs),
          if (!_collapsed) _buildSearch(cs),
          if (_actionError.isNotEmpty && !_collapsed)
            Padding(
              padding: const EdgeInsets.fromLTRB(Spacing.sm, 2, Spacing.sm, Spacing.xs),
              child: InfoBanner(
                message: _actionError,
                type: InfoBannerType.error,
                onDismiss: _clearError,
              ),
            ),
          Expanded(child: _buildThemeList(theme, cs)),
          if (_collapsed) _buildCollapsedCreate(cs),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeProvider theme, ShadColorScheme cs) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: _collapsed ? Spacing.sm : 10),
      child: Row(
        children: [
          if (!_collapsed) ...[
            Expanded(
              child: Text(
                '主题库',
                style: TextStyle(
                  fontSize: FontSizes.base,
                  fontWeight: FontWeight.w600,
                  color: cs.foreground,
                ),
              ),
            ),
            AppIconButton(
              icon: LucideIcons.plus,
              onTap: () {
                _clearError();
                _showComposerModal();
              },
              tooltip: '新建主题',
            ),
            const SizedBox(width: Spacing.xs),
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
    );
  }

  Widget _buildSearch(ShadColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      child: ShadInput(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        placeholder: const Text('搜索主题...'),
        leading: Padding(
          padding: const EdgeInsets.all(Spacing.sm),
          child: Icon(LucideIcons.search, size: IconSizes.md, color: cs.mutedForeground),
        ),
        trailing: _searchController.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.xs),
                  child: Icon(LucideIcons.x, size: IconSizes.sm, color: cs.mutedForeground),
                ),
              )
            : null,
      ),
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

    if (_focusedIndex >= themes.length) {
      _focusedIndex = 0;
    }

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            setState(() {
              _focusedIndex = (_focusedIndex + 1) % themes.length;
            });
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            setState(() {
              _focusedIndex = (_focusedIndex - 1 + themes.length) % themes.length;
            });
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            if (themes.isNotEmpty) {
              _handleThemeClick(themes[_focusedIndex].id);
            }
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            if (_query.isNotEmpty) {
              _searchController.clear();
              setState(() => _query = '');
              return KeyEventResult.handled;
            }
          }
        }
        return KeyEventResult.ignored;
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: Spacing.xs, left: Spacing.xs, right: Spacing.xs),
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final t = themes[index];
          final active = t.id == theme.selectedThemeId;
          final isDirty = theme.dirtyThemes[t.id] == true;
          final focused = index == _focusedIndex;
          return ThemeCard(
            key: ValueKey(t.id),
            theme: t,
            active: active,
            collapsed: _collapsed,
            focused: focused,
            isDirty: isDirty,
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

  Widget _buildCollapsedCreate(ShadColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.sm),
      child: AppIconButton(
        icon: LucideIcons.plus,
        onTap: () {
          _clearError();
          _showComposerModal();
        },
        tooltip: '新建主题',
        size: 44,
        iconSize: IconSizes.lg,
      ),
    );
  }

  Widget _buildCategoryTabs(ShadColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.sm, 2, Spacing.sm, 2),
      child: Row(
        children: [
          _buildCategoryChip(cs, '全部', 'all'),
          const SizedBox(width: Spacing.xs),
          _buildCategoryChip(cs, '内置', 'builtin'),
          const SizedBox(width: Spacing.xs),
          _buildCategoryChip(cs, '自定义', 'custom'),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(ShadColorScheme cs, String label, String value) {
    final active = _categoryFilter == value;
    return GestureDetector(
      onTap: () => setState(() {
        _categoryFilter = value;
        _focusedIndex = 0;
      }),
      child: AnimatedContainer(
        duration: AppAnimations.normal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 3),
        decoration: BoxDecoration(
          color: active ? cs.muted : Colors.transparent,
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          border: active
              ? Border.all(color: cs.border)
              : Border.all(color: Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: FontSizes.caption,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            color: active ? cs.foreground : cs.mutedForeground,
          ),
        ),
      ),
    );
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
    ShadToaster.of(context).show(
      ShadToast(
        title: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
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
    final targetName = _theme.themeLibrary
        .where((t) => t.id == targetId)
        .firstOrNull
        ?.name;
    showShadDialog(
      context: context,
      builder: (ctx) => ShadDialog.alert(
        title: const Text('未保存的更改'),
        description: Text('「$currentName」有未保存的更改。${targetName != null ? '切换到「$targetName」前要保存这些更改吗？' : ''}'),
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
}
