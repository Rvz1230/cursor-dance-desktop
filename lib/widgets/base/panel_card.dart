import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';
import '../../theme/animations.dart';
import '../controls/scale_tap.dart';
import 'panel_meta.dart';

/// 插件版 Panel 风格的卡片包装器
///
/// 结构:
/// ```
/// rounded-xl border border-slate-200 bg-white shadow-sm
///   Header: border-b border-slate-100
///     [icon 36px rounded-xl tone bg/fg] [title + summary] [badge] [action] [chevron]
///   内容区 (可折叠): px-4 py-3
/// ```
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

  void _toggle() {
    if (widget.collapsible) {
      setState(() => _isOpen = !_isOpen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        border: Border.all(
          color: cs.border.withAlpha(204),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x00000000) : const Color(0x08000000),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(theme, isDark),
          if (_isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: widget.child.animate().fadeIn(duration: AppAnimations.normal).slideX(begin: 0.03, duration: AppAnimations.normal),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(ShadThemeData theme, bool isDark) {
    final hasBorder = _isOpen;
    final meta = widget.meta;
    final cs = theme.colorScheme;

    // Dark mode tone color resolution
    final effectiveMeta = meta != null && isDark
        ? PanelMetaRegistry.darkVariant(meta)
        : meta;

    return GestureDetector(
      onTap: _toggle,
      behavior: HitTestBehavior.opaque,
      child: ScaleTap(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: hasBorder
                ? Border(
                    bottom: BorderSide(color: cs.muted),
                  )
                : null,
          ),
          child: Row(
            children: [
              // Icon + title + summary
              Expanded(
                child: Row(
                  children: [
                    if (effectiveMeta != null)
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: effectiveMeta.bg,
                          borderRadius: BorderRadius.circular(RadiusTokens.xl),
                        ),
                        child: Icon(
                          effectiveMeta.icon,
                          size: 16,
                          color: effectiveMeta.fg,
                        ),
                      ),
                    if (effectiveMeta != null) const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: FontSizes.base,
                                    fontWeight: FontWeight.w600,
                                    color: cs.foreground,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.badge != null) ...[
                                const SizedBox(width: 6),
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
                                  fontSize: FontSizes.small,
                                  color: cs.mutedForeground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action (e.g., Switch)
              if (widget.action != null) ...[
                const SizedBox(width: 8),
                widget.action!,
              ],

              // Chevron
              if (widget.collapsible) ...[
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                    color: cs.mutedForeground,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
