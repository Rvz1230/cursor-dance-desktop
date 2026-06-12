import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/tokens.dart';

// ═══════════════════════════════════════════════════════════
// ContextDropdown — 轻量点击菜单
// ═══════════════════════════════════════════════════════════

class ContextDropdown extends StatelessWidget {
  final ShadPopoverController controller;
  final List<DropdownItem> items;
  final Widget child;

  const ContextDropdown({
    super.key,
    required this.controller,
    required this.items,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return ShadPopover(
      controller: controller,
      closeOnTapOutside: true,
      popover: (_) => IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
          decoration: BoxDecoration(
            color: cs.popover,
            borderRadius: BorderRadius.circular(RadiusTokens.md),
            border: Border.all(color: cs.border),
            boxShadow: ShadowTokens.cardElevated,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items.map((item) => _MenuItem(item: item, onClose: () => controller.hide())).toList(),
          ),
        ),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.toggle(),
        child: child,
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  final DropdownItem item;
  final VoidCallback onClose;

  const _MenuItem({required this.item, required this.onClose});

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final fg = widget.item.destructive ? cs.destructive : cs.foreground;
    final bg = _hovered
        ? (widget.item.destructive ? cs.destructive.withValues(alpha: 0.08) : cs.accent)
        : Colors.transparent;
    final hoverFg = widget.item.destructive ? cs.destructive : cs.accentForeground;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          widget.onClose();
          widget.item.onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs + 1),
          color: bg,
          child: Row(
            children: [
              Icon(widget.item.icon, size: IconSizes.md, color: _hovered ? hoverFg : fg),
              const SizedBox(width: Spacing.sm),
              Text(
                widget.item.label,
                style: TextStyle(fontSize: FontSizes.small, color: _hovered ? hoverFg : fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownItem {
  final IconData icon;
  final String label;
  final bool destructive;
  final VoidCallback onTap;

  const DropdownItem({
    required this.icon,
    required this.label,
    this.destructive = false,
    required this.onTap,
  });
}
