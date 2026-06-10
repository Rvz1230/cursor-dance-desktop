import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/animations.dart';
import 'controls/icon_resolver.dart';

/// Dialog for picking a theme icon from a grid of Lucide icons.
class IconPickerDialog extends StatelessWidget {
  final String currentIcon;
  final ValueChanged<String> onUpdateIcon;

  const IconPickerDialog({
    super.key,
    required this.currentIcon,
    required this.onUpdateIcon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(Spacing.lg),
      content: SizedBox(
        width: 240,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.palette, size: IconSizes.md, color: cs.foreground),
                const SizedBox(width: Spacing.sm),
                Text(
                  '选择图标',
                  style: TextStyle(
                    fontSize: FontSizes.base,
                    fontWeight: FontWeight.w600,
                    color: cs.foreground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            const Divider(height: 1),
            const SizedBox(height: Spacing.md),
            _buildIconGrid(context, cs),
          ],
        ),
      ),
    );
  }

  Widget _buildIconGrid(BuildContext context, ShadColorScheme cs) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final crossAxisCount = 5;
        final childWidth =
            (constraints.maxWidth - (crossAxisCount - 1) * 4.0) / crossAxisCount;
        return Wrap(
          spacing: Spacing.xs,
          runSpacing: Spacing.xs,
          children: kThemeIconNames.map((name) {
            final selected = name == currentIcon;
            final iconData = resolveThemeIcon(name);
            return SizedBox(
              width: childWidth,
              height: childWidth,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(RadiusTokens.md),
                  onTap: () {
                    onUpdateIcon(name);
                    Navigator.of(context).pop();
                  },
                  child: AnimatedContainer(
                    duration: AppAnimations.fast,
                    decoration: BoxDecoration(
                      color: selected ? cs.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(RadiusTokens.md),
                    ),
                    child: Icon(
                      iconData,
                      size: IconSizes.lg,
                      color: selected
                          ? cs.primaryForeground
                          : cs.mutedForeground,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
