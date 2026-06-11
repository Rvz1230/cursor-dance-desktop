import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/tokens.dart';

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
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTag() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    if (widget.tags.contains(text)) return;
    _controller.clear();
    onChanged([...widget.tags, text]);
  }

  void _removeTag(int index) {
    final updated = [...widget.tags]..removeAt(index);
    onChanged(updated);
  }

  void onChanged(List<String> tags) => widget.onChanged(tags);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: Spacing.xs,
          runSpacing: Spacing.xs,
          children: [
            for (var i = 0; i < widget.tags.length; i++)
              _TagChip(
                label: widget.tags[i],
                onRemove: () => _removeTag(i),
              ),
          ],
        ),
        const SizedBox(height: Spacing.sm),
        Row(
          children: [
            Expanded(
              child: ShadInput(
                controller: _controller,
                placeholder: const Text('添加标签'),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: 4,
                ),
                onSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: Spacing.xs),
            ShadButton(
              size: ShadButtonSize.sm,
              onPressed: _addTag,
              child: const Text('添加'),
            ),
          ],
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _TagChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: cs.muted,
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: FontSizes.small, color: cs.foreground),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: IconSizes.sm,
              color: cs.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
