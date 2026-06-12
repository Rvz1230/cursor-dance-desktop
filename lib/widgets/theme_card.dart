import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/theme.dart';
import '../theme/tokens.dart';
import 'controls/dropdown_menu.dart';
import 'icon_picker.dart';

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
  final _menuController = ShadPopoverController();
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  bool _renameCommitted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ThemeCard old) {
    super.didUpdateWidget(old);
    // If the item name changed externally while editing, sync the controller
    if (_editingName && widget.item.name != old.item.name) {
      _nameController.text = widget.item.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _startRename() {
    _renameCommitted = false;
    _nameController.text = widget.item.name;
    setState(() => _editingName = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _nameFocusNode.requestFocus();
    });
  }

  void _commitRename() {
    if (!_editingName || _renameCommitted) return;
    _renameCommitted = true;
    final trimmed = _nameController.text.trim();
    setState(() => _editingName = false);
    if (trimmed.isNotEmpty && trimmed != widget.item.name) {
      widget.onRename?.call(widget.item.id, trimmed);
    }
  }

  void _cancelRename() {
    if (!_editingName) return;
    setState(() => _editingName = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final toneColor = resolveToneColor(widget.item.id);
    final icon = resolveIcon(widget.item.icon);

    return Container(
      decoration: BoxDecoration(
        color: widget.selected ? cs.accent.withValues(alpha: 0.35) : Colors.transparent,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(
          color: widget.selected ? cs.accent : Colors.transparent,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: Spacing.sm),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showIconPicker(context, toneColor),
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(top: Spacing.sm),
                  decoration: BoxDecoration(
                    color: widget.selected
                        ? toneColor.withValues(alpha: 0.25)
                        : toneColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(RadiusTokens.md),
                  ),
                  child: Icon(icon, size: IconSizes.sm, color: toneColor),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (_editingName)
                              SizedBox(
                                width: 120,
                                child: Focus(
                                  focusNode: _nameFocusNode,
                                  onFocusChange: (hasFocus) {
                                    if (!hasFocus) _commitRename();
                                  },
                                  onKeyEvent: (node, event) {
                                    if (event is KeyDownEvent &&
                                        event.logicalKey == LogicalKeyboardKey.escape) {
                                      _cancelRename();
                                      return KeyEventResult.handled;
                                    }
                                    return KeyEventResult.ignored;
                                  },
                                  child: ShadInput(
                                    controller: _nameController,
                                    maxLength: 30,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Spacing.xs,
                                      vertical: 2,
                                    ),
                                    style: TextStyle(
                                      fontSize: FontSizes.small,
                                      fontWeight: FontWeight.w600,
                                      color: cs.foreground,
                                    ),
                                    onSubmitted: (_) => _commitRename(),
                                  ),
                                ),
                              )
                            else ...[
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 120),
                                child: Text(
                                  widget.item.name,
                                  style: TextStyle(
                                    fontSize: FontSizes.small,
                                    fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
                                    color: cs.foreground,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: Spacing.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: cs.muted.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  widget.item.kind,
                                  style: TextStyle(fontSize: FontSizes.micro, color: cs.mutedForeground),
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
                              style: TextStyle(fontSize: FontSizes.micro, color: cs.mutedForeground),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.dirty)
                Padding(
                  padding: const EdgeInsets.only(top: Spacing.sm, left: 4),
                  child: Container(
                    width: IndicatorTokens.dirtyDot,
                    height: IndicatorTokens.dirtyDot,
                    decoration: BoxDecoration(
                      color: toneColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ContextDropdown(
                controller: _menuController,
                items: [
                  DropdownItem(
                    icon: LucideIcons.pencil,
                    label: '重命名',
                    onTap: _startRename,
                  ),
                  DropdownItem(
                    icon: LucideIcons.copy,
                    label: '复制',
                    onTap: widget.onDuplicate,
                  ),
                  DropdownItem(
                    icon: LucideIcons.download,
                    label: '导出 JSON',
                    onTap: widget.onExport,
                  ),
                  if (widget.canDelete)
                    DropdownItem(
                      icon: LucideIcons.trash2,
                      label: '删除',
                      destructive: true,
                      onTap: () => widget.onDelete?.call(),
                    ),
                ],
                child: Padding(
                  padding: const EdgeInsets.only(top: Spacing.sm, right: Spacing.sm, left: 4),
                  child: Icon(
                    LucideIcons.moreHorizontal,
                    size: IconSizes.md,
                    color: cs.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
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
