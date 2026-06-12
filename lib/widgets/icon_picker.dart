import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../theme/tokens.dart';

// ═══════════════════════════════════════════════════════════
// Icon options map
// ═══════════════════════════════════════════════════════════

const kIconOptions = <_IconOption>[
  _IconOption('Wand2', LucideIcons.wand2),
  _IconOption('Flame', LucideIcons.flame),
  _IconOption('Leaf', LucideIcons.leaf),
  _IconOption('Mountain', LucideIcons.mountain),
  _IconOption('Heart', LucideIcons.heart),
  _IconOption('CloudSun', LucideIcons.cloudSun),
  _IconOption('Sparkles', LucideIcons.sparkles),
  _IconOption('Palette', LucideIcons.palette),
  _IconOption('Star', LucideIcons.star),
  _IconOption('Zap', LucideIcons.zap),
  _IconOption('Smile', LucideIcons.smile),
  _IconOption('Moon', LucideIcons.moon),
  _IconOption('Sun', LucideIcons.sun),
  _IconOption('Music', LucideIcons.music),
  _IconOption('Camera', LucideIcons.camera),
];

class _IconOption {
  final String name;
  final IconData icon;
  const _IconOption(this.name, this.icon);
}

const _kIconMap = <String, IconData>{
  'Wand2': LucideIcons.wand2,
  'Flame': LucideIcons.flame,
  'Leaf': LucideIcons.leaf,
  'Mountain': LucideIcons.mountain,
  'Heart': LucideIcons.heart,
  'CloudSun': LucideIcons.cloudSun,
  'Sparkles': LucideIcons.sparkles,
  'Palette': LucideIcons.palette,
  'Star': LucideIcons.star,
  'Zap': LucideIcons.zap,
  'Smile': LucideIcons.smile,
  'Moon': LucideIcons.moon,
  'Sun': LucideIcons.sun,
  'Music': LucideIcons.music,
  'Camera': LucideIcons.camera,
};

IconData resolveIcon(String name) => _kIconMap[name] ?? LucideIcons.wand2;

// ═══════════════════════════════════════════════════════════
// IconPicker — grid of clickable icons
// ═══════════════════════════════════════════════════════════

class IconPicker extends StatelessWidget {
  final String selectedIcon;
  final Color toneColor;
  final ValueChanged<String> onSelect;

  const IconPicker({
    super.key,
    required this.selectedIcon,
    required this.toneColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Wrap(
        spacing: Spacing.xs,
        runSpacing: Spacing.xs,
        alignment: WrapAlignment.center,
        children: kIconOptions.map((opt) {
          final isSelected = opt.name == selectedIcon;
          return GestureDetector(
            onTap: () => onSelect(opt.name),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? toneColor.withValues(alpha: 0.2)
                    : cs.muted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(RadiusTokens.md),
                border: isSelected
                    ? Border.all(color: toneColor.withValues(alpha: 0.5))
                    : null,
              ),
              child: Icon(
                opt.icon,
                size: IconSizes.md,
                color: isSelected ? toneColor : cs.foreground,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}