import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/theme.dart';
import '../theme/app_tokens.dart';
import 'controls/icon_resolver.dart';
import 'controls/scale_tap.dart';

/// Theme card for the sidebar — collapsed (icon-only) or expanded.
///
/// Extracted from workbench_sidebar.dart for maintainability.
class ThemeCard extends StatefulWidget {
  final ThemeItem theme;
  final bool active;
  final bool collapsed;
  final bool focused;
  final bool isDirty;
  final bool canDelete;
  final VoidCallback onTap;
  final ValueChanged<String> onRename;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onExport;
  final ValueChanged<String> onUpdateIcon;

  const ThemeCard({
    super.key,
    required this.theme,
    required this.active,
    required this.collapsed,
    this.focused = false,
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
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> {
  bool _renaming = false;
  bool _hovered = false;
  late TextEditingController _renameController;

  @override
  void initState() {
    super.initState();
    _renameController = TextEditingController(text: widget.theme.name);
  }

  @override
  void didUpdateWidget(covariant ThemeCard oldWidget) {
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
    final toneColor = resolveToneColor(widget.theme.tone);
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
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: toneColor,
                            borderRadius: BorderRadius.circular(RadiusTokens.sm),
                            border: widget.active
                                ? Border.all(color: AppColors.primaryForeground.withValues(alpha: 0.3))
                                : null,
                          ),
                        ),
                      ),
                    ),
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
    final toneColor = resolveToneColor(widget.theme.tone);
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
                border: widget.focused
                    ? Border.all(color: AppColors.ring, width: 1.5)
                    : widget.active
                        ? Border.all(color: AppColors.border)
                        : _hovered
                            ? Border.all(color: AppColors.border)
                            : Border.all(color: Colors.transparent),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: toneColor,
                        borderRadius: BorderRadius.circular(RadiusTokens.md),
                        border: widget.active
                            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6),
                      child: _renaming
                          ? _buildRenameField()
                          : _buildNameSection(badgeStyle),
                    ),
                  ),
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
          case 'icon': _showIconPicker(context);
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
        const PopupMenuItem(
          value: 'icon',
          height: 36,
          child: Row(
            children: [
              Icon(LucideIcons.palette, size: 14, color: AppColors.mutedForeground),
              SizedBox(width: 8),
              Text('更改图标', style: TextStyle(fontSize: FontSizes.small)),
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
