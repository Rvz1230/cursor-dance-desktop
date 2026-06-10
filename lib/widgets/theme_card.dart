import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/theme.dart';
import '../theme/app_tokens.dart';
import '../theme/animations.dart';
import 'controls/inline_edit_field.dart';
import 'controls/icon_resolver.dart';
import 'icon_picker_dialog.dart';

/// 主题卡片 — V2 色调风格
///
/// - 28px 大色点，更强视觉权重
/// - 较大内边距提升呼吸感
/// - 选中态 inset 3px 色条（box-shadow）
/// - more 按钮 hover 渐显
class ThemeCard extends StatefulWidget {
  final ThemeItem theme;
  final bool active;
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
    final cs = ShadTheme.of(context).colorScheme;
    final w = widget;
    final toneColor = resolveToneColor(w.theme.tone);
    final isBuiltin = w.theme.kind == '内置';

    final (Color badgeBg, Color badgeFg, Color badgeBorder) = isBuiltin
        ? (cs.custom['success']?.withValues(alpha: 0.2) ?? AppColors.success.withValues(alpha: 0.2),
           cs.custom['success'] ?? AppColors.success,
           cs.custom['success']?.withValues(alpha: 0.4) ?? AppColors.success.withValues(alpha: 0.4))
        : (cs.custom['warning']?.withValues(alpha: 0.2) ?? AppColors.warning.withValues(alpha: 0.2),
           cs.custom['warning'] ?? AppColors.warning,
           cs.custom['warning']?.withValues(alpha: 0.4) ?? AppColors.warning.withValues(alpha: 0.4));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: w.onTap,
        child: AnimatedContainer(
          duration: AppAnimations.fastish,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: w.active
                ? cs.muted
                : _hovered ? cs.muted.withValues(alpha: 0.5) : Colors.transparent,
            borderRadius: BorderRadius.circular(RadiusTokens.xl),
            border: w.focused
                ? Border.all(color: cs.ring, width: 1.5)
                : w.active || _hovered
                    ? Border.all(color: cs.border)
                    : Border.all(color: Colors.transparent),
            boxShadow: w.active
                ? [BoxShadow(
                    color: cs.primary.withValues(alpha: 0.08),
                    blurRadius: 0,
                    offset: const Offset(3, 0),
                    spreadRadius: 0,
                  )]
                : null,
          ),
          child: Row(children: [
            // 28px tone dot
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: toneColor,
                borderRadius: BorderRadius.circular(RadiusTokens.lg),
                border: w.active
                    ? Border.all(color: cs.primary.withValues(alpha: 0.3))
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            // Name + summary
            Expanded(
              child: _renaming
                  ? InlineEditField(
                      initialValue: w.theme.name,
                      onSubmit: _finishRename,
                      onCancel: _cancelRename,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Flexible(
                            child: Text(w.theme.name,
                              style: TextStyle(
                                fontSize: FontSizes.body,
                                fontWeight: FontWeight.w600,
                                color: cs.foreground,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Kind badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
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
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(LucideIcons.circle, size: 6,
                                  color: cs.custom['warning'] ?? AppColors.warning),
                            ),
                        ]),
                        const SizedBox(height: 1),
                        Text(w.theme.summary, style: TextStyle(
                          fontSize: FontSizes.caption,
                          color: cs.mutedForeground,
                        ), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
            ),
            // More button — fades in on hover
            const SizedBox(width: 4),
            AnimatedOpacity(
              duration: AppAnimations.fastish,
              opacity: _hovered ? 1.0 : 0.0,
              child: _MoreMenu(
                canDelete: widget.canDelete,
                onDuplicate: widget.onDuplicate,
                onExport: widget.onExport,
                onChangeIcon: () => _showIconPicker(context),
                onDelete: widget.onDelete,
              ),
            ),
          ]),
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

/// More menu — ShadContextMenuRegion with hover fade
class _MoreMenu extends StatelessWidget {
  final bool canDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onExport;
  final VoidCallback onChangeIcon;
  final VoidCallback onDelete;

  const _MoreMenu({
    required this.canDelete,
    required this.onDuplicate,
    required this.onExport,
    required this.onChangeIcon,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return ShadContextMenuRegion(
      tapEnabled: true,
      items: [
        ShadContextMenuItem(
          leading: Icon(LucideIcons.copy, size: IconSizes.md, color: cs.mutedForeground),
          onPressed: onDuplicate,
          child: Text('复制', style: TextStyle(fontSize: FontSizes.small)),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.download, size: IconSizes.md, color: cs.mutedForeground),
          onPressed: onExport,
          child: Text('导出', style: TextStyle(fontSize: FontSizes.small)),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.palette, size: IconSizes.md, color: cs.mutedForeground),
          onPressed: onChangeIcon,
          child: Text('更改图标', style: TextStyle(fontSize: FontSizes.small)),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.trash2, size: IconSizes.md,
              color: canDelete ? cs.destructive : cs.mutedForeground),
          enabled: canDelete,
          onPressed: canDelete ? onDelete : null,
          child: Text('删除', style: TextStyle(
            fontSize: FontSizes.small,
            color: canDelete ? cs.destructive : cs.mutedForeground,
          )),
        ),
      ],
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusTokens.sm),
        ),
        child: Icon(
          LucideIcons.moreHorizontal,
          size: IconSizes.md,
          color: cs.mutedForeground,
        ),
      ),
    );
  }
}
