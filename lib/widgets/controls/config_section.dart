import 'package:flutter/material.dart';

import '../../theme/app_tokens.dart';

/// 插件版 SettingSection — 简洁的 border-top 分隔
///
/// 结构:
///   border-t border-slate-100 pt-4 (首个 section 无 top border)
///   disabled → opacity-50
class SettingSection extends StatelessWidget {
  final bool disabled;
  final Widget child;

  const SettingSection({
    super.key,
    this.disabled = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: child,
    );
  }
}

/// Section 标题（text-sm font-semibold text-slate-900）
///
/// 使用方式: 在 SettingSection 内的首个 element。
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: FontSizes.base,
          fontWeight: FontWeight.w600,
          color: AppColors.foreground,
        ),
      ),
    );
  }
}
