import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/action_config.dart';
import '../models/theme_draft.dart';
import '../theme/tokens.dart';

enum PreviewBackgroundMode { dark, light }

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
  PreviewBackgroundMode _bgMode = PreviewBackgroundMode.dark;
  bool _autoPreview = false;
  Size _viewSize = Size.zero;

  static const _bgColors = {
    PreviewBackgroundMode.dark: Color(0xFF1E293B),
    PreviewBackgroundMode.light: Color(0xFFF1F5F9),
  };

  @override
  void didUpdateWidget(PreviewPanel old) {
    super.didUpdateWidget(old);
    if (widget.actionId != old.actionId) {
      _clear();
      _syncConfig();
      _hasTriggered = false;
    } else if (widget.config != old.config) {
      _syncConfig();
      if (_autoPreview) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _autoTrigger());
      }
    }
  }

  void _autoTrigger() {
    if (_viewSize == Size.zero) return;
    _channel?.invokeMethod('trigger', {
      'x': _viewSize.width / 2,
      'y': _viewSize.height / 2,
    });
    if (!_hasTriggered) setState(() => _hasTriggered = true);
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final label = kActionLabels[widget.actionId] ?? widget.actionId;
    final bgColor = _bgColors[_bgMode]!;

    return ShadCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        child: Container(
          color: bgColor,
          child: Stack(
            children: [
              LayoutBuilder(builder: (context, box) {
                _viewSize = box.biggest;
                return AppKitView(
                  viewType: 'cursor_dance_preview',
                  onPlatformViewCreated: _onViewCreated,
                );
              }),
              if (!_hasTriggered)
                Center(
                  child: Text(
                    '点击此处预览特效',
                    style: TextStyle(
                      fontSize: FontSizes.body,
                      color: _bgMode == PreviewBackgroundMode.dark
                          ? cs.mutedForeground
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
              // Tap area — placed BELOW toolbar so toolbar buttons stay clickable
              Positioned.fill(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapUp: _handleTap,
                  ),
                ),
              ),
              // Toolbar — on top of tap area
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _Toolbar(
                  label: label,
                  bgMode: _bgMode,
                  autoPreview: _autoPreview,
                  onBgModeChanged: (m) => setState(() => _bgMode = m),
                  onAutoPreviewChanged: (v) {
                    setState(() => _autoPreview = v);
                    if (v) _autoTrigger();
                  },
                  onClear: _hasTriggered ? _clear : null,
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
  final PreviewBackgroundMode bgMode;
  final bool autoPreview;
  final ValueChanged<PreviewBackgroundMode> onBgModeChanged;
  final ValueChanged<bool> onAutoPreviewChanged;
  final VoidCallback? onClear;

  const _Toolbar({
    required this.label,
    required this.bgMode,
    required this.autoPreview,
    required this.onBgModeChanged,
    required this.onAutoPreviewChanged,
    required this.onClear,
  });

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
            width: IndicatorTokens.dirtyDot,
            height: IndicatorTokens.dirtyDot,
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
          _ToolbarIconButton(
            icon: LucideIcons.play,
            label: autoPreview ? '自动预览: 开' : '自动预览: 关',
            active: autoPreview,
            onPressed: () => onAutoPreviewChanged(!autoPreview),
          ),
          const SizedBox(width: Spacing.xs),
          _ToolbarIconButton(
            icon: bgMode == PreviewBackgroundMode.dark
                ? LucideIcons.moon
                : LucideIcons.sun,
            label: bgMode == PreviewBackgroundMode.dark ? '暗色背景' : '亮色背景',
            active: false,
            onPressed: () => onBgModeChanged(
              bgMode == PreviewBackgroundMode.dark
                  ? PreviewBackgroundMode.light
                  : PreviewBackgroundMode.dark,
            ),
          ),
          if (onClear != null) ...[
            const SizedBox(width: Spacing.xs),
            _ToolbarIconButton(
              icon: LucideIcons.eraser,
              label: '清除',
              active: false,
              onPressed: onClear!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onPressed;

  const _ToolbarIconButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return ShadTooltip(
      builder: (_) => Text(label),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: active
              ? BoxDecoration(
                  border: Border.all(
                    color: cs.foreground.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(RadiusTokens.sm),
                )
              : null,
          child: Icon(icon, size: IconSizes.md, color: cs.foreground),
        ),
      ),
    );
  }
}
