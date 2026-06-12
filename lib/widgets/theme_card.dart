import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/theme.dart';
import '../theme/tokens.dart';
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
    _menuController.dispose();
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
          color: widget.selected ? cs.accent : Colors.transparent,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Spacing.sm, Spacing.sm, Spacing.sm, Spacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _showIconPicker(context, toneColor),
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
                                      fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
                                      color: cs.foreground,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
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
                  ShadPopover(
                    controller: _menuController,
                    closeOnTapOutside: true,
                    popover: (_) => Container(
                      width: 140,
                      padding: const EdgeInsets.all(Spacing.xs),
                      decoration: BoxDecoration(
                        color: cs.popover,
                        borderRadius: BorderRadius.circular(RadiusTokens.lg),
                        border: Border.all(color: cs.border),
                        boxShadow: ShadowTokens.cardElevated,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _MenuButton(
                            icon: LucideIcons.pencil,
                            label: '重命名',
                            onTap: () {
                              _menuController.hide();
                              _startRename();
                            },
                          ),
                          _MenuButton(
                            icon: LucideIcons.copy,
                            label: '复制',
                            onTap: () {
                              _menuController.hide();
                              widget.onDuplicate();
                            },
                          ),
                          _MenuButton(
                            icon: LucideIcons.download,
                            label: '导出 JSON',
                            onTap: () {
                              _menuController.hide();
                              widget.onExport();
                            },
                          ),
                          if (widget.canDelete)
                            _MenuButton(
                              icon: LucideIcons.trash2,
                              label: '删除',
                              destructive: true,
                              onTap: () {
                                _menuController.hide();
                                widget.onDelete?.call();
                              },
                            ),
                        ],
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => _menuController.toggle(),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          LucideIcons.moreHorizontal,
                          size: IconSizes.md,
                          color: cs.mutedForeground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
// Menu Button (used by ThemeCard popover)
// ═══════════════════════════════════════════════════════════

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool destructive;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    this.destructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xs, vertical: 5),
        child: Row(
          children: [
            Icon(icon, size: IconSizes.md, color: destructive ? cs.destructive : cs.foreground),
            const SizedBox(width: Spacing.sm),
            Text(
              label,
              style: TextStyle(
                fontSize: FontSizes.small,
                color: destructive ? cs.destructive : cs.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
