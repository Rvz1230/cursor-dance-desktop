import 'package:flutter/material.dart';

import '../../theme/app_tokens.dart';

/// 插件版 FieldRow — 标签 + 控件双列布局
///
/// 参考插件版 WorkbenchControls.tsx:
///   md:grid-cols-[104px_minmax(0,1fr)]
///   标签: text-sm font-medium text-slate-800
///   hint: text-xs text-slate-500
class FieldRow extends StatelessWidget {
  final String label;
  final String? hint;
  final Widget child;

  const FieldRow({
    super.key,
    required this.label,
    this.hint,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: FontSizes.base,
                      fontWeight: FontWeight.w500,
                      color: AppColors.foreground,
                    ),
                  ),
                  if (hint != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        hint!,
                        style: const TextStyle(
                          fontSize: FontSizes.small,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}
