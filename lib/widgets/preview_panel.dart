import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/action_config.dart';
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

  @override
  Widget build(BuildContext context) {
    const stageColor = Color(0xFF1E293B);

    return ShadCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        child: Container(
          color: stageColor,
          child: Stack(
            children: [
              AppKitView(
                viewType: 'cursor_dance_preview',
                onPlatformViewCreated: _onViewCreated,
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
  }

  void _syncConfig() {
    _channel?.invokeMethod('updateConfig', {
      'config': widget.config.toJson(),
    });
  }

  @override
  void didUpdateWidget(PreviewPanel old) {
    super.didUpdateWidget(old);
    if (widget.config != old.config || widget.actionId != old.actionId) {
      _syncConfig();
    }
  }

  @override
  void dispose() {
    _channel = null;
    super.dispose();
  }
}
