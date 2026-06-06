import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
    final theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.small.copyWith(fontWeight: FontWeight.w500),
                  ),
                  if (hint != null)
                    Text(
                      hint!,
                      style: theme.textTheme.small.copyWith(
                        fontSize: 10,
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}
