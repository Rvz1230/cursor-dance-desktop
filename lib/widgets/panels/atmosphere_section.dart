import 'package:flutter/material.dart';

import '../../theme/app_tokens.dart';

class AtmosphereSection extends StatelessWidget {
  final String currentMode;
  final ValueChanged<String> onModeChanged;

  const AtmosphereSection({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '氛围预设',
            style: const TextStyle(
              fontSize: FontSizes.base,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '氛围会影响背景的微妙动效，让页面不显得空旷。',
            style: const TextStyle(
              fontSize: FontSizes.small,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
