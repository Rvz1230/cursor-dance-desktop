import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

/// 插件版 ControlSlider — 滑块 + 可编辑数值输入
class ControlSlider extends StatefulWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? suffix;
  final ValueChanged<double> onChanged;

  const ControlSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.suffix,
    required this.onChanged,
  });

  @override
  State<ControlSlider> createState() => _ControlSliderState();
}

class _ControlSliderState extends State<ControlSlider> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.round().toString());
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ControlSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      _controller.text = widget.value.round().toString();
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _controller.text = widget.value.round().toString();
    }
  }

  void _onSubmitted(String text) {
    final parsed = double.tryParse(text);
    if (parsed != null) {
      widget.onChanged(parsed.clamp(widget.min, widget.max));
    } else {
      _controller.text = widget.value.round().toString();
    }
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 6),
      decoration: BoxDecoration(
        color: cs.muted,
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        border: Border.all(color: cs.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: ShadSlider(
              initialValue: widget.value,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              label: '${widget.value.round()}${widget.suffix ?? ''}',
              onChanged: (v) {
                widget.onChanged(v);
                if (!_focusNode.hasFocus) {
                  _controller.text = v.round().toString();
                }
              },
            ),
          ),
          const SizedBox(width: Spacing.xs),
          Flexible(
            child: SizedBox(
              width: 56,
              child: Material(
                type: MaterialType.transparency,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: FontSizes.base,
                    fontWeight: FontWeight.w600,
                    fontFeatures: [FontFeature.tabularFigures()],
                    color: cs.foreground,
                    height: 1.2,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: _onSubmitted,
                ),
              ),
            ),
          ),
          if (widget.suffix != null)
            Padding(
              padding: const EdgeInsets.only(left: 1),
              child: Text(
                widget.suffix!,
                style: TextStyle(
                  fontSize: FontSizes.small,
                  color: cs.mutedForeground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
