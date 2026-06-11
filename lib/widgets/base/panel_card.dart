import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/animations.dart';
import '../../theme/tokens.dart';
import 'panel_meta.dart';

class PanelCard extends StatefulWidget {
  final String id;
  final String title;
  final String? summary;
  final PanelMeta? meta;
  final Widget? badge;
  final Widget? action;
  final Widget child;
  final bool collapsible;
  final bool defaultOpen;

  const PanelCard({
    super.key,
    required this.id,
    required this.title,
    this.summary,
    this.meta,
    this.badge,
    this.action,
    required this.child,
    this.collapsible = true,
    this.defaultOpen = false,
  });

  @override
  State<PanelCard> createState() => _PanelCardState();
}

class _PanelCardState extends State<PanelCard> {
  late bool _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.defaultOpen;
  }

  @override
  void didUpdateWidget(PanelCard old) {
    super.didUpdateWidget(old);
    if (widget.defaultOpen != old.defaultOpen && widget.defaultOpen) {
      _isOpen = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final brightness = ShadTheme.of(context).brightness;

    return AnimatedContainer(
      duration: AppAnimations.normal,
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        border: Border.all(color: cs.border, width: 1),
        boxShadow: brightness == Brightness.dark
            ? ShadowTokens.darkCard
            : ShadowTokens.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(cs, brightness),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.lg,
                0,
                Spacing.lg,
                Spacing.lg,
              ),
              child: widget.child,
            ),
            crossFadeState:
                _isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: AppAnimations.normal,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ShadColorScheme cs, Brightness brightness) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.collapsible ? () => setState(() => _isOpen = !_isOpen) : null,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Row(
          children: [
            if (widget.meta != null) ...[
              Container(
                width: IconSizes.xxl + 4,
                height: IconSizes.xxl + 4,
                decoration: BoxDecoration(
                  color: widget.meta!.bg(brightness),
                  borderRadius: BorderRadius.circular(RadiusTokens.lg),
                ),
                child: Center(
                  child: Icon(
                    widget.meta!.icon,
                    size: IconSizes.lg,
                    color: widget.meta!.fg(brightness),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: FontSizes.base,
                          fontWeight: FontWeight.w600,
                          color: cs.foreground,
                        ),
                      ),
                      if (widget.badge != null) ...[
                        const SizedBox(width: Spacing.sm),
                        widget.badge!,
                      ],
                    ],
                  ),
                  if (widget.summary != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        widget.summary!,
                        style: TextStyle(
                          fontSize: FontSizes.micro,
                          color: cs.mutedForeground,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (widget.action != null) ...[
              const SizedBox(width: Spacing.sm),
              widget.action!,
            ],
            if (widget.collapsible) ...[
              const SizedBox(width: Spacing.sm),
              AnimatedRotation(
                turns: _isOpen ? 0.0 : -0.25,
                duration: AppAnimations.fast,
                child: Icon(
                  LucideIcons.chevronDown,
                  size: IconSizes.lg,
                  color: cs.mutedForeground,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
