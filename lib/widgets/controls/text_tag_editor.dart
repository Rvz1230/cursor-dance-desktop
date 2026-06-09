import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TextTagEditor extends HookWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;

  const TextTagEditor({
    super.key,
    required this.tags,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final theme = ShadTheme.of(context);

    void addTag() {
      final text = controller.text.trim();
      if (text.isEmpty) return;
      onChanged([...tags, text]);
      controller.clear();
    }

    void removeTag(int index) {
      final updated = [...tags];
      updated.removeAt(index);
      onChanged(updated);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          type: MaterialType.transparency,
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (int i = 0; i < tags.length; i++)
                Chip(
                  label: Text(tags[i], style: theme.textTheme.small),
                  deleteIcon: Icon(LucideIcons.x, size: 12),
                  onDeleted: () => removeTag(i),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Flexible(
              child: ShadInput(
                controller: controller,
                placeholder: const Text('添加标签...'),
                onSubmitted: (_) => addTag(),
              ),
            ),
            const SizedBox(width: 4),
            ShadButton(
              onPressed: addTag,
              size: ShadButtonSize.sm,
              child: Text('添加'),
            ),
          ],
        ),
      ],
    );
  }
}
