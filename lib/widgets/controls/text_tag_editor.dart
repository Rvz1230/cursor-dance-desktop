import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

class TextTagEditor extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;

  const TextTagEditor({
    super.key,
    required this.tags,
    required this.onChanged,
  });

  @override
  State<TextTagEditor> createState() => _TextTagEditorState();
}

class _TextTagEditorState extends State<TextTagEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTag() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onChanged([...widget.tags, text]);
    _controller.clear();
  }

  void _removeTag(int index) {
    final updated = [...widget.tags];
    updated.removeAt(index);
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          type: MaterialType.transparency,
          child: Wrap(
            spacing: Spacing.xs,
            runSpacing: Spacing.xs,
            children: [
              for (int i = 0; i < widget.tags.length; i++)
                Chip(
                  label: Text(widget.tags[i], style: theme.textTheme.small),
                  deleteIcon: Icon(LucideIcons.x, size: 12),
                  onDeleted: () => _removeTag(i),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Row(
          children: [
            Flexible(
              child: ShadInput(
                controller: _controller,
                placeholder: const Text('添加标签...'),
                onSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: Spacing.xs),
            ShadButton(
              onPressed: _addTag,
              size: ShadButtonSize.sm,
              child: Text('添加'),
            ),
          ],
        ),
      ],
    );
  }
}
