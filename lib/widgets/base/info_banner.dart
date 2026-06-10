import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

/// 信息横幅组件 — 支持 error / warning / success 三种变体
///
/// 整合了项目中多处散落的横幅样式：
/// - 错误横幅（destructive 色系）
/// - 冲突/警告横幅（warning 色系）
/// - 成功横幅（success 色系）
class InfoBanner extends StatelessWidget {
  final String message;
  final InfoBannerType type;
  final VoidCallback? onDismiss;

  const InfoBanner({
    super.key,
    required this.message,
    this.type = InfoBannerType.warning,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    final (Color bg, Color border, Color fg, IconData icon) = switch (type) {
      InfoBannerType.error => (
        cs.destructive.withValues(alpha: 0.06),
        cs.destructive.withValues(alpha: 0.15),
        cs.destructive,
        LucideIcons.alertTriangle,
      ),
      InfoBannerType.warning => (
        cs.custom['warning']?.withValues(alpha: 0.08) ?? cs.primary.withValues(alpha: 0.08),
        cs.custom['warning']?.withValues(alpha: 0.2) ?? cs.primary.withValues(alpha: 0.2),
        cs.custom['warning'] ?? cs.primary,
        LucideIcons.alertTriangle,
      ),
      InfoBannerType.success => (
        cs.custom['success']?.withValues(alpha: 0.06) ?? AppColors.success.withValues(alpha: 0.06),
        cs.custom['success']?.withValues(alpha: 0.2) ?? const Color(0xFF6EE7B7).withValues(alpha: 0.2),
        cs.custom['success'] ?? const Color(0xFF065F46),
        LucideIcons.checkCircle2,
      ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: Spacing.sm),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 14, color: fg),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: FontSizes.small, color: fg),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: Padding(
                padding: const EdgeInsets.only(left: Spacing.xs),
                child: Icon(LucideIcons.x, size: IconSizes.sm, color: fg),
              ),
            ),
        ],
      ),
    );
  }
}

enum InfoBannerType { error, warning, success }
