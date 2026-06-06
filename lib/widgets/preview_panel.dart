import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../effects/effects_engine.dart';
import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';

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

class _PreviewPanelState extends State<PreviewPanel> with TickerProviderStateMixin {
  final EffectsEngine _engine = EffectsEngine();
  Ticker? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    _engine.update(1.0 / 60);
    if (!_engine.isAlive) {
      _ticker?.stop();
    }
    setState(() {});
  }

  void _onPreviewTap(TapDownDetails details) {
    _engine.trigger(
      details.localPosition.dx,
      details.localPosition.dy,
      widget.config,
    );
    if (!_ticker!.isActive) {
      _ticker?.start();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final actionLabel = kActionLabels[widget.actionId] ?? widget.actionId;
    final cfg = widget.config;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.muted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTapDown: _onPreviewTap,
          child: Stack(
            children: [
              // Hint text (shown when no effects are active)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.mousePointer2,
                      size: 32,
                      color: theme.colorScheme.mutedForeground,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '点击此处预览「$actionLabel」动效',
                      style: theme.textTheme.p.copyWith(
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),

              // Effects overlay
              CustomPaint(
                painter: EffectsPainter(_engine),
                size: Size.infinite,
              ),

              // Active effects indicator
              if (_engine.isAlive)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildEffectChips(theme, cfg),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEffectChips(ShadThemeData theme, ActionConfig cfg) {
    final chips = <Widget>[];
    if (cfg.particle) chips.add(_chip(theme, '${cfg.particleStyle}', LucideIcons.sparkles));
    if (cfg.textEnabled) chips.add(_chip(theme, '飘字', LucideIcons.type));
    if (cfg.ripple) chips.add(_chip(theme, '${cfg.rippleStyle}', LucideIcons.circleDashed));
    if (chips.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: chips,
    );
  }

  Widget _chip(ShadThemeData theme, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: theme.colorScheme.background.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10, color: theme.colorScheme.foreground),
            const SizedBox(width: 3),
            Text(
              label,
              style: theme.textTheme.small.copyWith(fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
