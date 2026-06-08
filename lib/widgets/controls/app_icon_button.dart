import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

/// 统一的图标按钮组件。
///
/// 所有 GestureDetector + icon 的手写伪按钮都应替换为此组件。
/// 内置 hover/focus/active 状态、tooltip、Semantics。
class AppIconButton extends StatefulWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconSize = IconSizes.md,
    this.tooltip,
    this.selected = false,
    this.disabled = false,
    this.size,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double iconSize;
  final String? tooltip;
  final bool selected;
  final bool disabled;
  final double? size;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final effectiveSize = widget.size ?? 28.0;

    final button = Semantics(
      button: true,
      enabled: !widget.disabled,
      label: widget.tooltip ?? '',
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.disabled ? null : widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: effectiveSize,
            height: effectiveSize,
            decoration: BoxDecoration(
              color: widget.selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : _hovered
                      ? theme.colorScheme.muted
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(RadiusTokens.sm),
              border: widget.selected
                  ? Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3))
                  : null,
            ),
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: widget.disabled
                  ? theme.colorScheme.mutedForeground.withValues(alpha: 0.4)
                  : widget.selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.mutedForeground,
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        preferBelow: false,
        triggerMode: TooltipTriggerMode.tap,
        child: button,
      );
    }

    return button;
  }
}
