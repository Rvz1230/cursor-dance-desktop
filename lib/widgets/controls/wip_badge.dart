import 'package:flutter/material.dart';

import '../../theme/app_tokens.dart';

/// "开发中" 标签 — 插件版 DataPill amber 色调
class WipBadge extends StatelessWidget {
  const WipBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: const Text(
        '开发中',
        style: TextStyle(
          fontSize: FontSizes.caption,
          color: AppColors.warning,
          height: 1.2,
        ),
      ),
    );
  }
}
