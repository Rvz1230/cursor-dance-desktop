import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/theme.dart';
import '../theme/app_tokens.dart';
import '../theme/animations.dart';
import 'controls/scale_tap.dart';
import 'icon_picker_dialog.dart';

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
    final cs = ShadTheme.of(context).colorScheme;
    final toneColor = resolveToneColor(widget.theme.tone);
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
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
                      duration: AppAnimations.fastish,
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: widget.active
                            ? cs.primary
                            : cs.card,
                        borderRadius: BorderRadius.circular(RadiusTokens.xl),
                        border: Border.all(
                          color: widget.active ? cs.primary : cs.border,
                          width: widget.active ? 1.5 : 1,
                        ),
                        boxShadow: widget.active
                            ? [BoxShadow(color: cs.primary.withValues(alpha: 0.15), blurRadius: 4)]
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
                                ? Border.all(color: cs.primaryForeground.withValues(alpha: 0.3))
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
                            color: cs.custom['success'] ?? AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: cs.card, width: 2),
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
                            color: cs.custom['warning'] ?? AppColors.warning,
                            shape: BoxShape.circle,
                            border: Border.all(color: cs.card, width: 1.5),
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
    final cs = ShadTheme.of(context).colorScheme;
    final toneColor = resolveToneColor(widget.theme.tone);

    // Badge colors: builtin → teal tint, custom → amber tint
    final (Color badgeBg, Color badgeFg, Color badgeBorder) =
        widget.theme.kind == '内置'
            ? (cs.custom['success']?.withValues(alpha: 0.2) ?? AppColors.success.withValues(alpha: 0.2),
               cs.custom['success'] ?? AppColors.success,
               cs.custom['success']?.withValues(alpha: 0.4) ?? AppColors.success.withValues(alpha: 0.4))
            : (cs.custom['warning']?.withValues(alpha: 0.2) ?? AppColors.warning.withValues(alpha: 0.2),
               cs.custom['warning'] ?? AppColors.warning,
               cs.custom['warning']?.withValues(alpha: 0.4) ?? AppColors.warning.withValues(alpha: 0.4));

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.xs),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: ScaleTap(
            child: AnimatedContainer(
              duration: AppAnimations.fastish,
              decoration: BoxDecoration(
                color: widget.active
                    ? cs.muted
                    : _hovered
                        ? cs.muted.withValues(alpha: 0.5)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(RadiusTokens.xl),
                border: widget.focused
                    ? Border.all(color: cs.ring, width: 1.5)
                    : widget.active
                        ? Border.all(color: cs.border)
                        : _hovered
                            ? Border.all(color: cs.border)
                            : Border.all(color: Colors.transparent),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: AppAnimations.fastish,
                    width: 3,
                    height: _renaming ? 44 : 52,
                    margin: const EdgeInsets.only(top: Spacing.xs, right: Spacing.sm),
                    decoration: BoxDecoration(
                      color: widget.active ? cs.primary : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(RadiusTokens.sm),
                        bottomRight: Radius.circular(RadiusTokens.sm),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: Spacing.md),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: toneColor,
                        borderRadius: BorderRadius.circular(RadiusTokens.md),
                        border: widget.active
                            ? Border.all(color: cs.primary.withValues(alpha: 0.3))
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: Spacing.sm),
                      child: _renaming
                          ? _buildRenameField(cs)
                          : _buildNameSection(cs, badgeBg, badgeFg, badgeBorder),
                    ),
                  ),
                  if (!_renaming)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: Spacing.xs),
                      child: _buildMoreActions(cs),
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

  Widget _buildRenameField(ShadColorScheme cs) {
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
        child: ShadInput(
          controller: _renameController,
          autofocus: true,
          style: TextStyle(
            fontSize: FontSizes.small,
            fontWeight: FontWeight.w600,
            color: cs.foreground,
          ),
          onSubmitted: (_) => _commitRename(),
        ),
      ),
    );
  }

  // ── Name + badge + dirty + summary ──

  Widget _buildNameSection(ShadColorScheme cs, Color badgeBg, Color badgeFg, Color badgeBorder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                widget.theme.name,
                style: TextStyle(
                  fontSize: FontSizes.small,
                  fontWeight: FontWeight.w600,
                  color: cs.foreground,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: Spacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xs, vertical: 1),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(RadiusTokens.sm),
                border: Border.all(color: badgeBorder, width: 0.5),
              ),
              child: Text(
                widget.theme.kind,
                style: TextStyle(
                  fontSize: FontSizes.micro,
                  fontWeight: FontWeight.w600,
                  color: badgeFg,
                  height: 1.2,
                ),
              ),
            ),
            if (widget.isDirty)
              Padding(
                padding: const EdgeInsets.only(left: Spacing.xs),
                child: Icon(LucideIcons.circle, size: 6, color: cs.custom['warning'] ?? AppColors.warning),
              ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                widget.theme.summary,
                style: TextStyle(
                  fontSize: FontSizes.caption,
                  color: cs.mutedForeground,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AnimatedOpacity(
              duration: AppAnimations.fastish,
              opacity: _hovered ? 1.0 : 0.0,
              child: GestureDetector(
                onTap: _startRename,
                child: Container(
                  padding: const EdgeInsets.all(Spacing.xs),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusTokens.sm),
                  ),
                  child: Icon(
                    LucideIcons.pencil,
                    size: IconSizes.xs,
                    color: cs.mutedForeground,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── More actions menu (shadcn-styled) ──

  Widget _buildMoreActions(ShadColorScheme cs) {
    return ShadContextMenuRegion(
      tapEnabled: true,
      items: [
        ShadContextMenuItem(
          leading: Icon(LucideIcons.copy, size: 14, color: cs.mutedForeground),
          onPressed: widget.onDuplicate,
          child: Text('复制', style: TextStyle(fontSize: FontSizes.small)),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.download, size: 14, color: cs.mutedForeground),
          onPressed: widget.onExport,
          child: Text('导出', style: TextStyle(fontSize: FontSizes.small)),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.palette, size: 14, color: cs.mutedForeground),
          onPressed: () => _showIconPicker(context),
          child: Text('更改图标', style: TextStyle(fontSize: FontSizes.small)),
        ),
        ShadContextMenuItem(
          leading: Icon(
            LucideIcons.trash2,
            size: 14,
            color: widget.canDelete ? cs.destructive : cs.mutedForeground,
          ),
          enabled: widget.canDelete,
          onPressed: widget.canDelete ? widget.onDelete : null,
          child: Text(
            '删除',
            style: TextStyle(
              fontSize: FontSizes.small,
              color: widget.canDelete ? cs.destructive : cs.mutedForeground,
            ),
          ),
        ),
      ],
      child: AnimatedContainer(
        duration: AppAnimations.fastish,
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
        ),
        child: Icon(
          LucideIcons.moreHorizontal,
          size: IconSizes.md,
          color: cs.mutedForeground,
        ),
      ),
    );
  }

  // ── Icon picker dialog ──

  void _showIconPicker(BuildContext context) {
    showShadDialog(
      context: context,
      builder: (_) => IconPickerDialog(
        currentIcon: widget.theme.icon,
        onUpdateIcon: widget.onUpdateIcon,
      ),
    );
  }
}
