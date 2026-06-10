import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

/// 插件版 FieldRow — 标签 + 控件双列布局
///
/// 参考插件版 WorkbenchControls.tsx:
///   md:grid-cols-[104px_minmax(0,1fr)]
///   标签: text-sm font-medium
///   hint: text-xs
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
    final cs = ShadTheme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Padding(
              padding: const EdgeInsets.only(top: Spacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: FontSizes.base,
                      fontWeight: FontWeight.w500,
                      color: cs.foreground,
                    ),
                  ),
                  if (hint != null)
                    Padding(
                      padding: const EdgeInsets.only(top: Spacing.xs),
                      child: Text(
                        hint!,
                        style: TextStyle(
                          fontSize: FontSizes.small,
                          color: cs.mutedForeground,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(child: child),
        ],
      ),
    );
  }
}
