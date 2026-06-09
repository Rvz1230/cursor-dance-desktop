import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

/// 统一的图标按钮组件。
class AppIconButton extends HookWidget {
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
  Widget build(BuildContext context) {
    final hovered = useState(false);
    final theme = ShadTheme.of(context);
    final effectiveSize = size ?? 28.0;

    useEffect(() {
      if (disabled && hovered.value) {
        hovered.value = false;
      }
      return null;
    }, [disabled]);

    final button = Semantics(
      button: true,
      enabled: !disabled,
      label: tooltip ?? '',
      child: MouseRegion(
        onEnter: (_) => hovered.value = true,
        onExit: (_) => hovered.value = false,
        cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: disabled ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: effectiveSize,
            height: effectiveSize,
            decoration: BoxDecoration(
              color: selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : hovered.value
                      ? theme.colorScheme.muted
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(RadiusTokens.sm),
              border: selected
                  ? Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3))
                  : null,
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: disabled
                  ? theme.colorScheme.mutedForeground.withValues(alpha: 0.4)
                  : selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.mutedForeground,
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        preferBelow: false,
        triggerMode: TooltipTriggerMode.tap,
        child: button,
      );
    }

    return button;
  }
}
