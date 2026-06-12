import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/action_config.dart';
import '../models/theme_draft.dart';
import '../theme/tokens.dart';

class PreviewPanel extends StatefulWidget {
  final String actionId;
  final ActionConfig config;

  const PreviewPanel({
    super.key,
    required this.actionId,
    required this.config,
  });

  @override
  State<PreviewPanel> createState() => _PreviewPanelState();
}

class _PreviewPanelState extends State<PreviewPanel> {
  MethodChannel? _channel;
  bool _hasTriggered = false;

  @override
  void didUpdateWidget(PreviewPanel old) {
    super.didUpdateWidget(old);
    if (widget.actionId != old.actionId) {
      _clear();
      _syncConfig();
      _hasTriggered = false;
    } else if (widget.config != old.config) {
      _syncConfig();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final label = kActionLabels[widget.actionId] ?? widget.actionId;

    return ShadCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        child: Container(
          color: const Color(0xFF1E293B),
          child: Stack(
            children: [
              AppKitView(
                viewType: 'cursor_dance_preview',
                onPlatformViewCreated: _onViewCreated,
              ),
              if (!_hasTriggered)
                Center(
                  child: Text(
                    '点击此处预览特效',
                    style: TextStyle(
                      fontSize: FontSizes.body,
                      color: cs.mutedForeground,
                    ),
                  ),
                ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _Toolbar(
                  label: label,
                  onClear: _hasTriggered ? _clear : null,
                ),
              ),
              Positioned.fill(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: _handleTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onViewCreated(int viewId) {
    _channel = MethodChannel('cursor_dance/preview_$viewId');
    _syncConfig();
  }

  void _handleTap(TapUpDetails details) {
    _channel?.invokeMethod('trigger', {
      'x': details.localPosition.dx,
      'y': details.localPosition.dy,
    });
    if (!_hasTriggered) setState(() => _hasTriggered = true);
  }

  void _syncConfig() {
    _channel?.invokeMethod('updateConfig', {
      'config': widget.config.toJson(),
    });
  }

  void _clear() {
    _channel?.invokeMethod('clear');
  }

  @override
  void dispose() {
    _channel = null;
    super.dispose();
  }
}

class _Toolbar extends StatelessWidget {
  final String label;
  final VoidCallback? onClear;

  const _Toolbar({required this.label, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Container(
      height: LayoutTokens.previewToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: cs.custom['success'],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.small,
              fontWeight: FontWeight.w600,
              color: cs.foreground,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Text(
            '点击预览',
            style: TextStyle(
              fontSize: FontSizes.caption,
              color: cs.mutedForeground,
            ),
          ),
          const Spacer(),
          if (onClear != null)
            ShadButton.ghost(
              onPressed: onClear,
              size: ShadButtonSize.sm,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.eraser, size: IconSizes.sm),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    '清除',
                    style: TextStyle(
                      fontSize: FontSizes.caption,
                      color: cs.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
