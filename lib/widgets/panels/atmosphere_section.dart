import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
    final theme = ShadTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.muted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('氛围预设', style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            '氛围会影响背景的微妙动效，让页面不显得空旷。',
            style: theme.textTheme.small.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
