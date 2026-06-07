import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../../theme/app_tokens.dart';

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

  void _onPlatformViewCreated(int viewId) {
    _channel = MethodChannel('cursor_dance/preview_$viewId');
  }

  void _onPreviewTap(TapDownDetails details) {
    final cfg = widget.config;
    final json = cfg.toJson();

    // Ensure text content is meaningful for native-side rendering
    if (cfg.textEnabled &&
        (json['textContent'] == null ||
            (json['textContent'] as String).isEmpty)) {
      json['textContent'] = '✦';
    }

    _channel?.invokeMethod('trigger', {
      'x': details.localPosition.dx,
      'y': details.localPosition.dy,
      'config': json,
    });
  }

  @override
  Widget build(BuildContext context) {
    final actionLabel = kActionLabels[widget.actionId] ?? widget.actionId;
    final cfg = widget.config;
    final hasEffects = cfg.textEnabled || cfg.particle || cfg.ripple;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        child: Stack(
          children: [
            // Hint text — always present behind transparent AppKitView
            // Opacity/visibility is static; never toggled via setState to
            // avoid widget tree churn that would flicker the native view.
            Center(
              child: IgnorePointer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.mousePointer2,
                      size: IconSizes.xxl,
                      color: AppColors.mutedForeground,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '点击此处预览「$actionLabel」动效',
                      style: const TextStyle(
                        fontSize: FontSizes.base,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Native platform view — renders effects via shared Swift FX classes
            Positioned.fill(
              child: AppKitView(
                viewType: 'cursor_dance_preview',
                hitTestBehavior: PlatformViewHitTestBehavior.transparent,
                onPlatformViewCreated: _onPlatformViewCreated,
              ),
            ),

            // Tap catcher overlay on top of the platform view
            Positioned.fill(
              child: GestureDetector(
                onTapDown: _onPreviewTap,
                behavior: HitTestBehavior.opaque,
              ),
            ),

            // Effect indicator chips — always shown when config has effects
            if (hasEffects)
              Positioned(
                top: 8,
                right: 8,
                child: _buildEffectChips(cfg),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEffectChips(ActionConfig cfg) {
    final chips = <Widget>[];
    if (cfg.particle) chips.add(_chip(cfg.particleStyle, LucideIcons.sparkles));
    if (cfg.textEnabled) chips.add(_chip('飘字', LucideIcons.type));
    if (cfg.ripple) chips.add(_chip(cfg.rippleStyle, LucideIcons.circleDashed));
    if (chips.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: chips,
    );
  }

  Widget _chip(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.card.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(RadiusTokens.sm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: IconSizes.xs, color: AppColors.foreground),
            const SizedBox(width: 3),
            Text(
              label,
              style: const TextStyle(
                fontSize: FontSizes.caption,
                color: AppColors.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
