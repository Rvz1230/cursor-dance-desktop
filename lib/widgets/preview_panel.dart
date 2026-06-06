import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../effects/particle_burst.dart';
import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../../models/particle_config.dart';

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
  final ParticleBurst _burst = ParticleBurst();
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
    _burst.update(1.0 / 60);
    if (!_burst.isAlive) {
      _ticker?.stop();
    }
    setState(() {});
  }

  void _onPreviewTap(TapDownDetails details) {
    final cfg = widget.config;
    _burst.spawn(
      details.localPosition.dx,
      details.localPosition.dy,
      // ignore: deprecated_member_use
      ParticleConfig(
        color: Color(int.parse(cfg.particlePalette.first.replaceFirst('#', '0xFF'))),
        size: cfg.particleSize.toDouble(),
        speed: cfg.particleCount.toDouble(),
      ),
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
              CustomPaint(
                painter: ParticlePainter(_burst.particles),
                size: Size.infinite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
