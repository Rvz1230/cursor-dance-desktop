import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_tokens.dart';
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
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: 240,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(LucideIcons.palette, size: IconSizes.md, color: AppColors.foreground),
                SizedBox(width: 8),
                Text(
                  '选择图标',
                  style: TextStyle(
                    fontSize: FontSizes.base,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _buildIconGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIconGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final crossAxisCount = 5;
        final childWidth =
            (constraints.maxWidth - (crossAxisCount - 1) * 4.0) / crossAxisCount;
        return Wrap(
          spacing: 4,
          runSpacing: 4,
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
                    duration: const Duration(milliseconds: 100),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(RadiusTokens.md),
                    ),
                    child: Icon(
                      iconData,
                      size: IconSizes.lg,
                      color: selected
                          ? AppColors.primaryForeground
                          : AppColors.mutedForeground,
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
