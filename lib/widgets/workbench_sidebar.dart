import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/theme.dart';
import '../../state/workbench_state.dart';
import '../../theme/app_tokens.dart';
import 'controls/app_icon_button.dart';
import 'controls/icon_resolver.dart';
import 'controls/scale_tap.dart';

class WorkbenchSidebar extends StatefulWidget {
  final WorkbenchState state;

  const WorkbenchSidebar({super.key, required this.state});

  @override
  State<WorkbenchSidebar> createState() => _WorkbenchSidebarState();
}

class _WorkbenchSidebarState extends State<WorkbenchSidebar> {
  bool _collapsed = false;
  String _query = '';
  String _actionError = '';

  List<ThemeItem> get _filteredThemes {
    if (_query.isEmpty) return widget.state.themeLibrary;
    return widget.state.themeLibrary.where((t) {
      return t.name.toLowerCase().contains(_query.toLowerCase()) ||
          t.summary.toLowerCase().contains(_query.toLowerCase()) ||
          t.kind.toLowerCase().contains(_query.toLowerCase());
    }).toList();
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
    final cs = ShadTheme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _collapsed ? 72 : 260,
      decoration: BoxDecoration(
        color: cs.card,
        border: const Border(
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(cs),
          if (!_collapsed) _buildSearch(cs),
          if (_actionError.isNotEmpty && !_collapsed) _buildErrorBanner(cs),
          Expanded(child: _buildThemeList(cs)),
          if (_collapsed) _buildCollapsedCreate(cs),
        ],
      ),
    );
  }

  Widget _buildHeader(ShadColorScheme cs) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: _collapsed ? 8 : 10),
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
    );
  }

  Widget _buildSearch(ShadColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ShadInput(
        initialValue: _query,
        onChanged: (v) => setState(() => _query = v),
        placeholder: const Text('搜索主题...'),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(LucideIcons.search, size: IconSizes.md, color: cs.mutedForeground),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(ShadColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.destructive.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          border: Border.all(color: AppColors.destructive.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            const Icon(LucideIcons.alertTriangle, size: IconSizes.sm, color: AppColors.destructive),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                _actionError,
                style: const TextStyle(fontSize: FontSizes.caption, color: AppColors.destructive),
              ),
            ),
            GestureDetector(
              onTap: _clearError,
              child: const Icon(LucideIcons.x, size: IconSizes.sm, color: AppColors.destructive),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeList(ShadColorScheme cs) {
    final themes = _filteredThemes;
    if (themes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.search, size: IconSizes.xl, color: AppColors.mutedForeground),
              const SizedBox(height: 8),
              const Text(
                '没有找到匹配的主题',
                style: TextStyle(fontSize: FontSizes.small, fontWeight: FontWeight.w600, color: AppColors.foreground),
              ),
              const SizedBox(height: 4),
              const Text(
                '换个关键词，或者新建一个主题。',
                style: TextStyle(fontSize: FontSizes.caption, color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 12),
              ShadButton(
                size: ShadButtonSize.sm,
                onPressed: () {
                  _clearError();
                  _showComposerModal();
                },
                child: const Text('新建主题'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 4, left: 4, right: 4),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final t = themes[index];
        final active = t.id == widget.state.selectedThemeId;
        final isDirty = widget.state.dirtyThemes[t.id] == true;
        return _ThemeCard(
          key: ValueKey(t.id),
          theme: t,
          active: active,
          collapsed: _collapsed,
          isDirty: isDirty,
          canDelete: t.kind != '内置' && widget.state.themeLibrary.length > 1,
          onTap: () => _handleThemeClick(t.id),
          onRename: (name) => widget.state.renameTheme(t.id, name),
          onDelete: () => _confirmDelete(t),
          onDuplicate: () => _runAction('复制主题', () {
            widget.state.duplicateTheme(t.id);
            _showToast('已复制主题「${t.name}」');
          }),
          onExport: () => _handleExport(t),
          onUpdateIcon: (icon) => widget.state.updateThemeIcon(t.id, icon),
        );
      },
    );
  }

  Widget _buildCollapsedCreate(ShadColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.all(8),
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

  // ── Interactions ──

  void _handleThemeClick(String targetId) {
    if (targetId == widget.state.selectedThemeId) return;
    _clearError();
    if (widget.state.dirtyThemes[widget.state.selectedThemeId] == true) {
      _confirmSwitchTheme(targetId);
      return;
    }
    widget.state.setThemeId(targetId);
  }

  void _handleExport(ThemeItem theme) {
    _runAction('导出主题', () {
      final json = widget.state.exportTheme(theme.id);
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

  // ── Dialogs ──

  void _showComposerModal() {
    showDialog(
      context: context,
      builder: (_) => _ThemeComposerModal(
        state: widget.state,
        onShowToast: _showToast,
        onError: (msg) => setState(() => _actionError = msg),
      ),
    );
  }

  void _confirmDelete(ThemeItem theme) {
    _clearError();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('删除「${theme.name}」？'),
        content: const Text('此操作会在下次保存时生效。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.destructive),
            onPressed: () {
              widget.state.deleteTheme(theme.id);
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
    final currentName = widget.state.activeTheme.name;
    final targetName = widget.state.themeLibrary
        .where((t) => t.id == targetId)
        .firstOrNull
        ?.name;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('未保存的更改'),
        content: Text('「$currentName」有未保存的更改。${targetName != null ? '切换到「$targetName」前要保存这些更改吗？' : ''}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              widget.state.discardThemeChanges(widget.state.selectedThemeId);
              widget.state.setThemeId(targetId);
              Navigator.of(ctx).pop();
            },
            child: const Text('不保存直接切换'),
          ),
          ShadButton(
            onPressed: () {
              widget.state.saveChanges().then((_) {
                widget.state.setThemeId(targetId);
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

// ═══════════════════════════════════════════════════════════════
// ThemeComposerModal
// ═══════════════════════════════════════════════════════════════

class _ThemeComposerModal extends StatefulWidget {
  final WorkbenchState state;
  final void Function(String message) onShowToast;
  final void Function(String message) onError;

  const _ThemeComposerModal({
    required this.state,
    required this.onShowToast,
    required this.onError,
  });

  @override
  State<_ThemeComposerModal> createState() => _ThemeComposerModalState();
}

class _ThemeComposerModalState extends State<_ThemeComposerModal> {
  int _tabIndex = 0;
  final _createNameController = TextEditingController();
  final _importController = TextEditingController();
  String _createBaseThemeId = '';
  String _createError = '';
  String _importError = '';
  String _importSuccess = '';

  @override
  void initState() {
    super.initState();
    _createBaseThemeId = widget.state.selectedThemeId;
  }

  @override
  void dispose() {
    _createNameController.dispose();
    _importController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 420,
        constraints: const BoxConstraints(maxHeight: 520),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(RadiusTokens.xl2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '主题管理',
                          style: TextStyle(
                            fontSize: FontSizes.h3,
                            fontWeight: FontWeight.w600,
                            color: AppColors.foreground,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '新建一个可编辑主题，或导入现有 JSON 主题包。',
                          style: TextStyle(
                            fontSize: FontSizes.small,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: IconSizes.md),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: '关闭',
                  ),
                ],
              ),
            ),
            // Tabs (shadcn style)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  _buildTab('新建主题', 0),
                  const SizedBox(width: 4),
                  _buildTab('导入 JSON', 1),
                ],
              ),
            ),
            // Content
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: SingleChildScrollView(
                  child: _tabIndex == 0 ? _buildCreateTab() : _buildImportTab(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final active = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(RadiusTokens.md),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: FontSizes.small,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            color: active ? AppColors.primaryForeground : AppColors.mutedForeground,
          ),
        ),
      ),
    );
  }

  // ── Create Tab ──

  Widget _buildCreateTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('主题名称'),
        const SizedBox(height: 4),
        ShadInput(
          controller: _createNameController,
          placeholder: const Text('例如：极光幻彩'),
          autofocus: true,
        ),
        const SizedBox(height: 16),
        const _FieldLabel('起始模板'),
        const SizedBox(height: 4),
        _buildBaseThemeSelector(),
        const SizedBox(height: 16),
        if (_createError.isNotEmpty) ...[
          _buildErrorBox(_createError),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(RadiusTokens.sm),
                ),
                child: const Text(
                  '新主题会先进入工作台，保存后写入配置文件',
                  style: TextStyle(fontSize: FontSizes.caption, color: AppColors.warning),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ShadButton(
              onPressed: _handleCreate,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.plus, size: IconSizes.md),
                  SizedBox(width: 4),
                  Text('创建主题'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBaseThemeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _createBaseThemeId,
          isExpanded: true,
          style: const TextStyle(fontSize: FontSizes.small, color: AppColors.foreground),
          items: [
            const DropdownMenuItem(
              value: 'blank',
              child: Text('空白主题'),
            ),
            ...widget.state.themeLibrary.map((t) => DropdownMenuItem(
              value: t.id,
              child: Text(t.name),
            )),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _createBaseThemeId = v);
          },
        ),
      ),
    );
  }

  void _handleCreate() {
    final name = _createNameController.text.trim();
    if (name.isEmpty) {
      setState(() => _createError = '请输入主题名称');
      return;
    }
    setState(() => _createError = '');
    widget.state.createTheme(
      name,
      basedOnThemeId: _createBaseThemeId == 'blank' ? null : _createBaseThemeId,
    );
    widget.onShowToast('已创建主题「$name」');
    if (mounted) Navigator.of(context).pop();
  }

  // ── Import Tab ──

  Widget _buildImportTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.muted,
            borderRadius: BorderRadius.circular(RadiusTokens.xl2),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(RadiusTokens.xl),
                ),
                child: const Icon(
                  LucideIcons.fileJson,
                  size: IconSizes.lg,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '粘贴 JSON 主题包',
                style: TextStyle(fontSize: FontSizes.base, fontWeight: FontWeight.w600, color: AppColors.foreground),
              ),
              const SizedBox(height: 4),
              const Text(
                '支持直接导入单个主题对象，也支持带 themePack / theme 包裹的 JSON。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: FontSizes.small, color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 16),
              ShadInput(
                controller: _importController,
                maxLines: 4,
                placeholder: const Text('在此粘贴 JSON 内容...'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ShadButton(
                      onPressed: _handleImport,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.upload, size: IconSizes.md),
                          SizedBox(width: 4),
                          Text('导入'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ShadButton(
                      onPressed: _handlePasteFromClipboard,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.clipboardPaste, size: IconSizes.md),
                          SizedBox(width: 4),
                          Text('从剪贴板粘贴'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_importSuccess.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildSuccessBox(_importSuccess),
        ],
        if (_importError.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildErrorBox(_importError),
        ],
      ],
    );
  }

  void _handleImport() {
    final text = _importController.text.trim();
    if (text.isEmpty) {
      setState(() => _importError = '请输入或粘贴 JSON 内容');
      return;
    }
    try {
      widget.state.importThemeFromText(text, '导入主题');
      setState(() {
        _importError = '';
        _importSuccess = '已导入主题';
      });
      widget.onShowToast('已导入主题');
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _importError = '导入失败：$e');
    }
  }

  void _handlePasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      _importController.text = data.text!;
    }
  }

  Widget _buildErrorBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.destructive.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: AppColors.destructive.withValues(alpha: 0.15)),
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: FontSizes.caption, color: AppColors.destructive),
      ),
    );
  }

  Widget _buildSuccessBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.checkCircle2, size: IconSizes.sm, color: AppColors.success),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: FontSizes.caption, color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ThemeCard (rewritten for plugin-level UX)
// ═══════════════════════════════════════════════════════════════

class _ThemeCard extends StatefulWidget {
  final ThemeItem theme;
  final bool active;
  final bool collapsed;
  final bool isDirty;
  final bool canDelete;
  final VoidCallback onTap;
  final ValueChanged<String> onRename;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onExport;
  final ValueChanged<String> onUpdateIcon;

  const _ThemeCard({
    super.key,
    required this.theme,
    required this.active,
    required this.collapsed,
    this.isDirty = false,
    this.canDelete = true,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
    required this.onDuplicate,
    required this.onExport,
    required this.onUpdateIcon,
  });

  @override
  State<_ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<_ThemeCard> {
  bool _renaming = false;
  bool _hovered = false;
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

  void _startRename() {
    _renameController.text = widget.theme.name;
    setState(() => _renaming = true);
  }

  void _commitRename() {
    final trimmed = _renameController.text.trim();
    if (trimmed.isNotEmpty && trimmed != widget.theme.name) {
      widget.onRename(trimmed);
    }
    setState(() => _renaming = false);
  }

  void _cancelRename() {
    _renameController.text = widget.theme.name;
    setState(() => _renaming = false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.collapsed) return _buildCollapsedCard();
    return _buildExpandedCard();
  }

  // ── Collapsed: icon-only card ──

  Widget _buildCollapsedCard() {
    final themeIcon = resolveThemeIcon(widget.theme.icon);
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
            child: ScaleTap(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: widget.active
                            ? AppColors.primary
                            : AppColors.card,
                        borderRadius: BorderRadius.circular(RadiusTokens.xl),
                        border: Border.all(
                          color: widget.active ? AppColors.primary : AppColors.border,
                          width: widget.active ? 1.5 : 1,
                        ),
                        boxShadow: widget.active
                            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 4)]
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          themeIcon,
                          size: IconSizes.md,
                          color: widget.active
                              ? AppColors.primaryForeground
                              : AppColors.mutedForeground,
                        ),
                      ),
                    ),
                    // Selected indicator (teal dot top-right)
                    if (widget.active)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.card, width: 2),
                          ),
                        ),
                      ),
                    // Dirty dot (amber dot bottom-right)
                    if (widget.isDirty)
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.warning,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.card, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Expanded: full card ──

  Widget _buildExpandedCard() {
    final themeIcon = resolveThemeIcon(widget.theme.icon);
    final badgeStyle = kindBadgeStyle(widget.theme.kind);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: ScaleTap(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              decoration: BoxDecoration(
                color: widget.active
                    ? AppColors.muted
                    : _hovered
                        ? AppColors.muted.withValues(alpha: 0.5)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(RadiusTokens.xl),
                border: widget.active
                    ? Border.all(color: AppColors.border)
                    : _hovered
                        ? Border.all(color: AppColors.border)
                        : Border.all(color: Colors.transparent),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Active accent bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: 3,
                    height: _renaming ? 44 : 52,
                    margin: const EdgeInsets.only(top: 4, right: 8),
                    decoration: BoxDecoration(
                      color: widget.active ? AppColors.primary : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(2),
                        bottomRight: Radius.circular(2),
                      ),
                    ),
                  ),
                  // Icon (clickable → icon picker)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GestureDetector(
                      onTap: () => _showIconPicker(context),
                      child: ScaleTap(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: widget.active
                                  ? AppColors.primary
                                  : AppColors.muted,
                              borderRadius: BorderRadius.circular(RadiusTokens.md),
                              border: _hovered && !widget.active
                                  ? Border.all(color: AppColors.border)
                                  : null,
                            ),
                            child: Icon(
                              themeIcon,
                              size: IconSizes.md,
                              color: widget.active
                                  ? AppColors.primaryForeground
                                  : AppColors.mutedForeground,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Name + summary
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6),
                      child: _renaming
                          ? _buildRenameField()
                          : _buildNameSection(badgeStyle),
                    ),
                  ),
                  // More actions (hover on desktop)
                  if (!_renaming)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 2),
                      child: _buildMoreActions(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Rename inline field ──

  Widget _buildRenameField() {
    return SizedBox(
      height: 32,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event.logicalKey == LogicalKeyboardKey.escape && event is KeyDownEvent) {
            _cancelRename();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: _renameController,
          autofocus: true,
          style: const TextStyle(
            fontSize: FontSizes.small,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RadiusTokens.md),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RadiusTokens.md),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          onSubmitted: (_) => _commitRename(),
        ),
      ),
    );
  }

  // ── Name + badge + dirty + summary ──

  Widget _buildNameSection(KindBadgeStyle badgeStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                widget.theme.name,
                style: const TextStyle(
                  fontSize: FontSizes.small,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            // Kind badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: badgeStyle.bg,
                borderRadius: BorderRadius.circular(RadiusTokens.sm),
                border: Border.all(color: badgeStyle.border, width: 0.5),
              ),
              child: Text(
                widget.theme.kind,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: badgeStyle.fg,
                  height: 1.2,
                ),
              ),
            ),
            // Dirty indicator
            if (widget.isDirty)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(LucideIcons.circle, size: 6, color: AppColors.warning),
              ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                widget.theme.summary,
                style: const TextStyle(
                  fontSize: FontSizes.caption,
                  color: AppColors.mutedForeground,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Rename pencil (appears on hover for all themes)
            if (_hovered)
              GestureDetector(
                onTap: _startRename,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusTokens.sm),
                  ),
                  child: const Icon(
                    LucideIcons.pencil,
                    size: IconSizes.xs,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // ── More actions popup ──

  Widget _buildMoreActions() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
        ),
        child: const Icon(
          LucideIcons.moreHorizontal,
          size: IconSizes.md,
          color: AppColors.mutedForeground,
        ),
      ),
      onSelected: (v) {
        switch (v) {
          case 'duplicate': widget.onDuplicate();
          case 'export': widget.onExport();
          case 'delete': widget.onDelete();
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'duplicate',
          height: 36,
          child: Row(
            children: [
              Icon(LucideIcons.copy, size: 14, color: AppColors.mutedForeground),
              SizedBox(width: 8),
              Text('复制', style: TextStyle(fontSize: FontSizes.small)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'export',
          height: 36,
          child: Row(
            children: [
              Icon(LucideIcons.download, size: 14, color: AppColors.mutedForeground),
              SizedBox(width: 8),
              Text('导出', style: TextStyle(fontSize: FontSizes.small)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          height: 36,
          enabled: widget.canDelete,
          child: Row(
            children: [
              Icon(
                LucideIcons.trash2,
                size: 14,
                color: widget.canDelete ? AppColors.destructive : AppColors.mutedForeground,
              ),
              const SizedBox(width: 8),
              Text(
                '删除',
                style: TextStyle(
                  fontSize: FontSizes.small,
                  color: widget.canDelete ? AppColors.destructive : AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Icon picker dialog ──

  void _showIconPicker(BuildContext context) {
    final currentIcon = widget.theme.icon;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: 240,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.palette, size: IconSizes.md, color: AppColors.foreground),
                  SizedBox(width: 8),
                  Text(
                    '选择图标',
                    style: TextStyle(
                      fontSize: FontSizes.base,
                      fontWeight: FontWeight.w600,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _buildIconGrid(ctx, currentIcon),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconGrid(BuildContext context, String currentIcon) {
    // 5-column grid matching plugin's ICON_OPTIONS layout
    return LayoutBuilder(
      builder: (_, constraints) {
        final crossAxisCount = 5;
        final childWidth = (constraints.maxWidth - (crossAxisCount - 1) * 4.0) / crossAxisCount;
        return Wrap(
          spacing: 4,
          runSpacing: 4,
          children: kThemeIconNames.map((name) {
            final selected = name == currentIcon;
            final iconData = resolveThemeIcon(name);
            return SizedBox(
              width: childWidth,
              height: childWidth,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(RadiusTokens.md),
                  onTap: () {
                    widget.onUpdateIcon(name);
                    Navigator.of(context).pop();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(RadiusTokens.md),
                    ),
                    child: Icon(
                      iconData,
                      size: IconSizes.lg,
                      color: selected ? AppColors.primaryForeground : AppColors.mutedForeground,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FieldLabel
// ═══════════════════════════════════════════════════════════════

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: FontSizes.small,
        fontWeight: FontWeight.w500,
        color: AppColors.mutedForeground,
      ),
    );
  }
}
