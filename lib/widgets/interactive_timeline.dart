import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../theme/app_tokens.dart';

// ═══════════════════════════════════════════════════════════════
// Track data model
// ═══════════════════════════════════════════════════════════════

class _TimelineTrack {
  final String id;
  final String label;
  final Color color;
  final Color bgColor;
  final int startMs;
  final int endMs;
  final int configuredDuration;

  _TimelineTrack({
    required this.id,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.startMs,
    required this.endMs,
    required this.configuredDuration,
  });
}

class _TrackDef {
  final String id;
  final bool Function(ActionConfig) enabled;
  final int Function(ActionConfig) delay;
  final int Function(ActionConfig) duration;
  const _TrackDef(this.id, this.enabled, this.delay, this.duration);
}

const _trackColors = {
  'text': Color(0xFFF43F5E),     // rose-500
  'ripple': Color(0xFF14B8A6),   // teal-500
  'particle': Color(0xFFF59E0B), // amber-500
  'animation': Color(0xFF0EA5E9),// sky-500
  'image': Color(0xFFA855F7),    // violet-500
  'audio': Color(0xFF64748B),    // slate-500
};

const _trackBgColors = {
  'text': Color(0xFFFECDD3),     // rose-200
  'ripple': Color(0xFF99F6E4),   // teal-200
  'particle': Color(0xFFFDE68A), // amber-200
  'animation': Color(0xFFBAE6FD),// sky-200
  'image': Color(0xFFE9D5FF),    // violet-200
  'audio': Color(0xFFE2E8F0),    // slate-200
};

const _trackLabels = {
  'text': '飘字',
  'ripple': '波纹',
  'particle': '粒子',
  'animation': '动画',
  'image': '贴纸',
  'audio': '音效',
};

// ═══════════════════════════════════════════════════════════════
// InteractiveTimeline
// ═══════════════════════════════════════════════════════════════

class InteractiveTimeline extends StatelessWidget {
  final ActionConfig config;

  const InteractiveTimeline({super.key, required this.config});

  static final _trackDefs = [
    _TrackDef('text', (c) => c.textEnabled, (c) => c.textDelay, (c) => c.textDuration),
    _TrackDef('ripple', (c) => c.ripple, (c) => c.rippleDelay, (c) => c.rippleDuration),
    _TrackDef('particle', (c) => c.particle, (c) => c.particleDelay, (c) => c.particleDuration),
    _TrackDef('animation', (c) => c.animationEnabled, (c) => c.animationDelay, (c) => c.animationDuration),
    _TrackDef('image', (c) => c.imageEnabled, (c) => c.imageDelay, (c) => c.imageDuration),
    _TrackDef('audio', (c) => c.sound, (c) => c.soundDelay, (_) => 120),
  ];

  List<_TimelineTrack> _buildTracks() {
    return _trackDefs
        .where((d) => d.enabled(config))
        .map((d) {
      final delay = d.delay(config);
      final duration = d.duration(config);
      return _TimelineTrack(
        id: d.id,
        label: _trackLabels[d.id]!,
        color: _trackColors[d.id]!,
        bgColor: _trackBgColors[d.id]!,
        startMs: delay,
        endMs: delay + duration,
        configuredDuration: duration,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final tracks = _buildTracks();
    if (tracks.isEmpty) return const SizedBox.shrink();

    // Compute total timeline span (rounded up to nearest 100ms)
    final maxEnd = tracks.fold<int>(820, (max, t) => t.endMs > max ? t.endMs : max);
    final totalMs = ((maxEnd / 100).ceil()) * 100;

    return Container(
      padding: const EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, Spacing.xs),
      decoration: BoxDecoration(
        color: cs.muted.withAlpha(80),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(RadiusTokens.xl),
          bottomRight: Radius.circular(RadiusTokens.xl),
        ),
        border: Border(
          top: BorderSide(color: cs.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
            child: Text(
              '时间轴编排',
              style: TextStyle(
                fontSize: FontSizes.base,
                fontWeight: FontWeight.w600,
                color: cs.foreground,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: _TimelineView(cs: cs, tracks: tracks, totalMs: totalMs),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Timeline rendering
// ═══════════════════════════════════════════════════════════════

class _TimelineView extends StatelessWidget {
  final ShadColorScheme cs;
  final List<_TimelineTrack> tracks;
  final int totalMs;

  const _TimelineView({required this.cs, required this.tracks, required this.totalMs});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final pxPerMs = availableWidth / totalMs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tick marks
            _buildTickMarks(totalMs, availableWidth),
            const SizedBox(height: Spacing.xs),
            // Track rows
            ...tracks.map((track) => _TrackRow(
              cs: cs,
              track: track,
              pxPerMs: pxPerMs,
              totalMs: totalMs,
              labelWidth: 36,
            )),
          ],
        );
      },
    );
  }

  Widget _buildTickMarks(int totalMs, double width) {
    // Determine step size
    final step = totalMs <= 1200 ? 100 : totalMs <= 2400 ? 200 : 500;
    final pxPerMs = width / totalMs;

    return SizedBox(
      height: 16,
      child: Stack(
        children: [
          for (int t = 0; t <= totalMs; t += step)
            Positioned(
              left: t * pxPerMs - 12,
              child: SizedBox(
                width: 24,
                child: Text(
                  '${t}ms',
                  style: TextStyle(
                    fontSize: 8,
                    color: cs.mutedForeground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TrackRow extends StatelessWidget {
  final ShadColorScheme cs;
  final _TimelineTrack track;
  final double pxPerMs;
  final int totalMs;
  final double labelWidth;

  const _TrackRow({
    required this.cs,
    required this.track,
    required this.pxPerMs,
    required this.totalMs,
    required this.labelWidth,
  });

  @override
  Widget build(BuildContext context) {
    final barStart = track.startMs * pxPerMs;
    final barWidth = (track.endMs - track.startMs) * pxPerMs;
    final barHeight = 20.0;

    // Clamp to available width
    final clampedWidth = barWidth.clamp(4.0, totalMs * pxPerMs - barStart);

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Row(
        children: [
          // Label
          SizedBox(
            width: labelWidth,
            child: Text(
              track.label,
              style: TextStyle(
                fontSize: FontSizes.caption,
                fontWeight: FontWeight.w600,
                color: track.color,
              ),
            ),
          ),
          // Track area
          Expanded(
            child: SizedBox(
              height: barHeight + 12,
              child: Stack(
                children: [
                  // Background track lane
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.only(top: barHeight * 0.15),
                      decoration: BoxDecoration(
                        color: track.bgColor.withAlpha(100),
                        borderRadius: BorderRadius.circular(RadiusTokens.sm),
                      ),
                    ),
                  ),
                  // Active bar
                  Positioned(
                    left: barStart,
                    top: 0,
                    child: Container(
                      width: clampedWidth,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: track.color.withAlpha(200),
                        borderRadius: BorderRadius.circular(RadiusTokens.sm),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${track.configuredDuration}ms',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Delay label if > 0
                  if (track.startMs > 0)
                    Positioned(
                      left: 0,
                      top: barHeight + 1,
                      child: Text(
                        '延迟 ${track.startMs}ms',
                        style: TextStyle(
                          fontSize: 8,
                          color: cs.mutedForeground,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
