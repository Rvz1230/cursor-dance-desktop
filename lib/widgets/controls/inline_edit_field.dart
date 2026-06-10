import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

/// 内联编辑字段 — 单行文本输入，支持 Enter 提交 / Escape 取消
///
/// 提取自 ThemeCard._buildRenameField，用于列表项原地重命名。
class InlineEditField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onSubmit;
  final VoidCallback? onCancel;

  const InlineEditField({
    super.key,
    required this.initialValue,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<InlineEditField> createState() => _InlineEditFieldState();
}

class _InlineEditFieldState extends State<InlineEditField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant InlineEditField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _commit() {
    final trimmed = _controller.text.trim();
    if (trimmed.isNotEmpty) {
      widget.onSubmit(trimmed);
    }
  }

  void _cancel() {
    widget.onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return SizedBox(
      height: 32,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape) {
              _cancel();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: ShadInput(
          controller: _controller,
          autofocus: true,
          style: TextStyle(
            fontSize: FontSizes.small,
            fontWeight: FontWeight.w600,
            color: cs.foreground,
          ),
          onSubmitted: (_) => _commit(),
        ),
      ),
    );
  }
}
