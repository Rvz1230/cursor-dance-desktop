import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../theme/tokens.dart';

class WorkbenchHeader extends StatelessWidget {
  final bool overlayEnabled;
  final bool unsaved;
  final bool isSaving;
  final VoidCallback? onToggleOverlay;
  final VoidCallback? onSave;
  final VoidCallback? onReset;

  const WorkbenchHeader({
    super.key,
    this.overlayEnabled = false,
    this.unsaved = false,
    this.isSaving = false,
    this.onToggleOverlay,
    this.onSave,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      decoration: BoxDecoration(
        color: cs.card,
        border: Border(bottom: BorderSide(color: cs.border)),
      ),
      child: Row(
        children: [
          Text(
            'CursorDance',
            style: TextStyle(
              fontSize: FontSizes.h3,
              fontWeight: FontWeight.w700,
              color: cs.foreground,
            ),
          ),
          const SizedBox(width: Spacing.lg),
          // Save button with unsaved indicator
          if (onSave != null)
            ShadButton.ghost(
              onPressed: isSaving ? null : onSave,
              size: ShadButtonSize.sm,
              leading: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSaving ? LucideIcons.loader : LucideIcons.save,
                    size: IconSizes.md,
                  ),
                  if (unsaved && !isSaving)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: cs.custom['warning'] ?? const Color(0xFFF59E0B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              child: Text(
                isSaving ? '保存中...' : '保存',
                style: TextStyle(fontSize: FontSizes.small),
              ),
            ),
          if (onReset != null) ...[
            const SizedBox(width: Spacing.xs),
            ShadButton.ghost(
              onPressed: onReset,
              size: ShadButtonSize.sm,
              leading: Icon(LucideIcons.rotateCcw, size: IconSizes.md),
              child: const SizedBox.shrink(),
            ),
          ],
          const Spacer(),
          ShadSwitch(
            value: overlayEnabled,
            onChanged: (v) => onToggleOverlay?.call(),
          ),
        ],
      ),
    );
  }
}