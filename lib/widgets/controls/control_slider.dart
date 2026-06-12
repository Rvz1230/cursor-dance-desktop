import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/tokens.dart';

class ControlSlider extends StatefulWidget {
  final int value;
  final int min;
  final int max;
  final int? divisions;
  final String? suffix;
  final ValueChanged<int>? onChanged;

  const ControlSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.suffix,
    this.onChanged,
  });

  @override
  State<ControlSlider> createState() => _ControlSliderState();
}

class _ControlSliderState extends State<ControlSlider> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  late final ShadSliderController _sliderController;

  double get _normalized => (widget.value - widget.min) / (widget.max - widget.min);

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.value.toString());
    _sliderController = ShadSliderController(initialValue: _normalized);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(ControlSlider old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      _sliderController.value = _normalized;
      if (!_focusNode.hasFocus) {
        _textController.text = widget.value.toString();
      }
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) _commitInput();
  }

  void _commitInput() {
    final parsed = int.tryParse(_textController.text);
    if (parsed != null) {
      final clamped = parsed.clamp(widget.min, widget.max);
      _textController.text = clamped.toString();
      _sliderController.value = (clamped - widget.min) / (widget.max - widget.min);
      if (clamped != widget.value) widget.onChanged?.call(clamped);
    } else {
      _textController.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _textController.dispose();
    _sliderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final range = (widget.max - widget.min).toDouble();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: cs.muted,
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        border: Border.all(color: cs.border, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: ShadSlider(
              controller: _sliderController,
              min: 0,
              max: 1,
              divisions: widget.divisions,
              onChanged: widget.onChanged != null ? (v) {
                final intVal = (v * range + widget.min).round();
                _textController.text = intVal.toString();
                widget.onChanged?.call(intVal);
              } : null,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          SizedBox(
            width: 52,
            child: ShadInput(
              controller: _textController,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.xs,
                vertical: 3,
              ),
              style: TextStyle(
                fontSize: FontSizes.small,
                color: cs.foreground,
              ),
              onSubmitted: (_) => _commitInput(),
            ),
          ),
          if (widget.suffix != null)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                widget.suffix!,
                style: TextStyle(
                  fontSize: FontSizes.micro,
                  color: cs.mutedForeground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
