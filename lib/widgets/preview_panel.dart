import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/action_config.dart';
import '../theme/tokens.dart';

class PreviewPanel extends StatelessWidget {
  final String actionId;
  final ActionConfig config;

  const PreviewPanel({
    super.key,
    required this.actionId,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(RadiusTokens.xl),
        ),
        child: Center(
          child: Text(
            '预览区 (Phase 2: SharedRenderer)',
            style: TextStyle(
              fontSize: FontSizes.small,
              color: Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}
