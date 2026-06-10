import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../../theme/app_tokens.dart';
import 'controls/scale_tap.dart';
import 'interactive_timeline.dart';

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
  Timer? _autoTimer;
  bool _autoPlay = true;
  double _triggerInterval = 1200;
  int _runIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(PreviewPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.actionId != widget.actionId) _runIndex = 0;
    if (_autoPlay) _restartAutoPlay();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  void _onPlatformViewCreated(int viewId) {
    _channel = MethodChannel('cursor_dance/preview_$viewId');
  }

  void _startAutoPlay() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(
      Duration(milliseconds: _triggerInterval.round()),
      (_) => _sendTrigger(160, 120),
    );
  }

  void _stopAutoPlay() {
    _autoTimer?.cancel();
    _autoTimer = null;
  }

  void _restartAutoPlay() {
    _stopAutoPlay();
    _startAutoPlay();
  }

  void _toggleAutoPlay() {
    setState(() {
      _autoPlay = !_autoPlay;
      if (_autoPlay) {
        _startAutoPlay();
      } else {
        _stopAutoPlay();
      }
    });
  }

  void _replayOnce() {
    _stopAutoPlay();
    _sendTrigger(160, 120);
    if (_autoPlay) _startAutoPlay();
  }

  void _onIntervalChanged(double value) {
    setState(() => _triggerInterval = value);
    if (_autoPlay) _restartAutoPlay();
  }

  void _sendTrigger(double x, double y) {
    _runIndex++;
    final cfg = widget.config;
    final json = cfg.toJson();

    if (cfg.textEnabled &&
        (json['textContent'] == null ||
            (json['textContent'] as String).isEmpty)) {
      json['textContent'] = '✦';
    }

    _channel?.invokeMethod('trigger', {
      'x': x,
      'y': y,
      'config': json,
      'runIndex': _runIndex,
    });
  }

  void _onPreviewTap(TapDownDetails details) {
    _sendTrigger(details.localPosition.dx, details.localPosition.dy);
  }

  String _formatInterval(double ms) {
    if (ms < 1000) return '${ms.round()}ms';
    return '${(ms / 1000).toStringAsFixed(1)}s';
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final actionLabel = kActionLabels[widget.actionId] ?? widget.actionId;
    final cfg = widget.config;
    final hasEffects =
        cfg.textEnabled || cfg.particle || cfg.ripple || cfg.sound ||
        cfg.animationEnabled || cfg.imageEnabled;

    return Container(
      margin: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        border: Border.all(color: cs.border),
      ),
      child: Column(
        children: [
          _buildHeader(cs, actionLabel, hasEffects),
          Expanded(child: _buildStage(cs, hasEffects, actionLabel, cfg)),
          if (hasEffects)
            SizedBox(
              height: 135,
              child: SingleChildScrollView(
                child: InteractiveTimeline(config: cfg),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(ShadColorScheme cs, String actionLabel, bool hasEffects) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: Spacing.sm),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: cs.border)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.mousePointer2, size: IconSizes.md, color: cs.foreground),
          const SizedBox(width: Spacing.sm),
          Text(
            '实时预览',
            style: TextStyle(fontSize: FontSizes.base, fontWeight: FontWeight.w600, color: cs.foreground),
          ),
          if (!hasEffects)
            Container(
              margin: const EdgeInsets.only(left: Spacing.sm),
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xs, vertical: 1),
              decoration: BoxDecoration(
                color: cs.custom['warning']?.withValues(alpha: 0.1) ?? cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(RadiusTokens.sm),
              ),
              child: Text(
                '未开启效果',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: cs.custom['warning'] ?? cs.primary),
              ),
            ),
          const Spacer(),
          if (hasEffects) ...[
            _iconBtn(cs, LucideIcons.rotateCcw, '重播', _replayOnce),
            const SizedBox(width: Spacing.xs),
            _iconBtn(cs,
              _autoPlay ? LucideIcons.pause : LucideIcons.play,
              _autoPlay ? '暂停自动播放' : '开启自动播放',
              _toggleAutoPlay,
              active: _autoPlay,
            ),
            const SizedBox(width: Spacing.sm),
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  Text(
                    _formatInterval(_triggerInterval),
                    style: TextStyle(fontSize: FontSizes.caption, fontWeight: FontWeight.w600, color: cs.foreground),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Expanded(
                    child: ShadSlider(
                      initialValue: _triggerInterval,
                      min: 200,
                      max: 5000,
                      divisions: 48,
                      onChanged: _onIntervalChanged,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _iconBtn(ShadColorScheme cs, IconData icon, String tooltip, VoidCallback onTap, {bool active = false}) {
    return Tooltip(
      message: tooltip,
      preferBelow: false,
      triggerMode: TooltipTriggerMode.tap,
      child: GestureDetector(
        onTap: onTap,
        child: ScaleTap(
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: active ? cs.primary : cs.muted,
              borderRadius: BorderRadius.circular(RadiusTokens.sm),
            ),
            child: Icon(
              icon,
              size: IconSizes.sm,
              color: active ? cs.primaryForeground : cs.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStage(ShadColorScheme cs, bool hasEffects, String actionLabel, ActionConfig cfg) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(RadiusTokens.xl),
        bottomRight: Radius.circular(RadiusTokens.xl),
      ),
      child: Stack(
        children: [
          // Background dot grid
          Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter(cs)),
          ),

          if (hasEffects) ...[
            Positioned.fill(
              child: AppKitView(
                viewType: 'cursor_dance_preview',
                hitTestBehavior: PlatformViewHitTestBehavior.transparent,
                onPlatformViewCreated: _onPlatformViewCreated,
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTapDown: _onPreviewTap,
                behavior: HitTestBehavior.opaque,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: _buildEffectChips(cs, cfg),
            ),
          ] else ...[
            Center(
              child: IgnorePointer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.mousePointer2, size: IconSizes.xxl, color: cs.mutedForeground),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      '点击此处预览「$actionLabel」动效',
                      style: TextStyle(fontSize: FontSizes.base, color: cs.mutedForeground),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      '在左侧配置面板中开启飘字、粒子、波纹等效果',
                      style: TextStyle(fontSize: FontSizes.caption, color: cs.mutedForeground),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEffectChips(ShadColorScheme cs, ActionConfig cfg) {
    final chips = <Widget>[];
    if (cfg.particle) chips.add(_chip(cs, cfg.particleStyle, LucideIcons.sparkles));
    if (cfg.textEnabled) chips.add(_chip(cs, '飘字', LucideIcons.type));
    if (cfg.ripple) chips.add(_chip(cs, cfg.rippleStyle, LucideIcons.circleDashed));
    if (cfg.sound) chips.add(_chip(cs, '音效', LucideIcons.volume2));
    if (chips.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: chips,
    );
  }

  Widget _chip(ShadColorScheme cs, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.xs),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
        decoration: BoxDecoration(
          color: cs.card.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(RadiusTokens.sm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: IconSizes.xs, color: cs.foreground),
            const SizedBox(width: Spacing.xs),
            Text(label, style: TextStyle(fontSize: FontSizes.caption, color: cs.foreground)),
          ],
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final ShadColorScheme cs;
  _DotGridPainter(this.cs);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cs.border.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    const spacing = 20.0;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) => false;
}
