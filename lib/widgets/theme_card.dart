import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/theme.dart';
import '../theme/app_tokens.dart';
import '../theme/animations.dart';
import 'controls/inline_edit_field.dart';
import 'controls/icon_resolver.dart';
import 'icon_picker_dialog.dart';

/// 主题卡片 — 折叠态显示为纯色圆点，展开态显示完整信息行。
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

  void _startRename() => setState(() => _renaming = true);

  void _finishRename(String newName) {
    if (newName.isNotEmpty && newName != widget.theme.name) {
      widget.onRename(newName);
    }
    setState(() => _renaming = false);
  }

  void _cancelRename() => setState(() => _renaming = false);

  @override
  Widget build(BuildContext context) {
    return widget.collapsed ? _CollapsedCard(this) : _ExpandedCard(this);
  }

  // ── More actions context menu ──

  Widget _buildMoreActions(ShadColorScheme cs) {
    return ShadContextMenuRegion(
      tapEnabled: true,
      items: [
        ShadContextMenuItem(
          leading: Icon(LucideIcons.copy, size: IconSizes.md, color: cs.mutedForeground),
          onPressed: widget.onDuplicate,
          child: Text('复制', style: TextStyle(fontSize: FontSizes.small)),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.download, size: IconSizes.md, color: cs.mutedForeground),
          onPressed: widget.onExport,
          child: Text('导出', style: TextStyle(fontSize: FontSizes.small)),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.palette, size: IconSizes.md, color: cs.mutedForeground),
          onPressed: () => _showIconPicker(context),
          child: Text('更改图标', style: TextStyle(fontSize: FontSizes.small)),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.trash2, size: IconSizes.md,
              color: widget.canDelete ? cs.destructive : cs.mutedForeground),
          enabled: widget.canDelete,
          onPressed: widget.canDelete ? widget.onDelete : null,
          child: Text('删除', style: TextStyle(
            fontSize: FontSizes.small,
            color: widget.canDelete ? cs.destructive : cs.mutedForeground,
          )),
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

// ═══════════════════════════════════════════════════════════════════
// Collapsed variant — tone dot with active/dirty badges
// ═══════════════════════════════════════════════════════════════════

class _CollapsedCard extends StatelessWidget {
  final _ThemeCardState s;
  const _CollapsedCard(this.s);

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final toneColor = resolveToneColor(s.widget.theme.tone);
    final w = s.widget;

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Semantics(
        button: true,
        label: w.theme.name,
        child: Tooltip(
          message: w.theme.name,
          preferBelow: false,
          triggerMode: TooltipTriggerMode.tap,
          child: GestureDetector(
            onTap: w.onTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: AppAnimations.fastish,
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                  decoration: BoxDecoration(
                    color: w.active ? cs.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(RadiusTokens.xl),
                    border: Border.all(
                      color: w.active ? cs.primary : cs.border,
                      width: w.active ? 1.5 : 1,
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
                if (w.active)
                  Positioned(right: 10, top: -2,
                    child: _dot(cs.custom['success'] ?? AppColors.success, cs.card, 2),
                  ),
                if (w.isDirty)
                  Positioned(right: 10, bottom: -2,
                    child: _dot(cs.custom['warning'] ?? AppColors.warning, cs.card, 1.5),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dot(Color color, Color borderColor, double borderWidth) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Expanded variant — full info row
// ═══════════════════════════════════════════════════════════════════

class _ExpandedCard extends StatelessWidget {
  final _ThemeCardState s;
  const _ExpandedCard(this.s);

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final w = s.widget;
    final toneColor = resolveToneColor(w.theme.tone);

    final (Color badgeBg, Color badgeFg, Color badgeBorder) = w.theme.kind == '内置'
        ? (cs.custom['success']?.withValues(alpha: 0.2) ?? AppColors.success.withValues(alpha: 0.2),
           cs.custom['success'] ?? AppColors.success,
           cs.custom['success']?.withValues(alpha: 0.4) ?? AppColors.success.withValues(alpha: 0.4))
        : (cs.custom['warning']?.withValues(alpha: 0.2) ?? AppColors.warning.withValues(alpha: 0.2),
           cs.custom['warning'] ?? AppColors.warning,
           cs.custom['warning']?.withValues(alpha: 0.4) ?? AppColors.warning.withValues(alpha: 0.4));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => s.setState(() => s._hovered = true),
        onExit: (_) => s.setState(() => s._hovered = false),
        child: GestureDetector(
          onTap: w.onTap,
          child: AnimatedContainer(
            duration: AppAnimations.fastish,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.md),
            decoration: BoxDecoration(
              color: w.active
                  ? cs.muted
                  : s._hovered ? cs.muted.withValues(alpha: 0.5) : Colors.transparent,
              borderRadius: BorderRadius.circular(RadiusTokens.xl),
              border: w.focused
                  ? Border.all(color: cs.ring, width: 1.5)
                  : w.active || s._hovered
                      ? Border.all(color: cs.border)
                      : Border.all(color: Colors.transparent),
            ),
            child: Row(children: [
              // Tone color dot
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: toneColor,
                  borderRadius: BorderRadius.circular(RadiusTokens.md),
                  border: w.active
                      ? Border.all(color: cs.primary.withValues(alpha: 0.3))
                      : null,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              // Name + summary
              Expanded(
                child: s._renaming
                    ? InlineEditField(
                        initialValue: w.theme.name,
                        onSubmit: s._finishRename,
                        onCancel: s._cancelRename,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Flexible(
                              child: Text(w.theme.name,
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
                              child: Text(w.theme.kind, style: TextStyle(
                                fontSize: FontSizes.micro,
                                fontWeight: FontWeight.w600,
                                color: badgeFg,
                                height: 1.2,
                              )),
                            ),
                            if (w.isDirty)
                              Padding(
                                padding: const EdgeInsets.only(left: Spacing.xs),
                                child: Icon(LucideIcons.circle, size: 6,
                                    color: cs.custom['warning'] ?? AppColors.warning),
                              ),
                          ]),
                          const SizedBox(height: 2),
                          Row(children: [
                            Expanded(
                              child: Text(w.theme.summary, style: TextStyle(
                                fontSize: FontSizes.caption,
                                color: cs.mutedForeground,
                              ), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                            AnimatedOpacity(
                              duration: AppAnimations.fastish,
                              opacity: s._hovered ? 1.0 : 0.0,
                              child: GestureDetector(
                                onTap: s._startRename,
                                child: Padding(
                                  padding: const EdgeInsets.all(Spacing.xs),
                                  child: Icon(LucideIcons.pencil,
                                      size: IconSizes.xs, color: cs.mutedForeground),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
              ),
              // More actions
              const SizedBox(width: Spacing.xs),
              if (!s._renaming) s._buildMoreActions(cs),
            ]),
          ),
        ),
      ),
    );
  }
}
