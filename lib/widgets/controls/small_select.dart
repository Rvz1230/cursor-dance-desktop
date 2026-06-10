import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/app_tokens.dart';

class SmallSelect extends StatefulWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String>? onChanged;

  const SmallSelect({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    this.onChanged,
  });

  @override
  State<SmallSelect> createState() => _SmallSelectState();
}

class _SmallSelectState extends State<SmallSelect> {
  final _popoverController = ShadPopoverController();
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollPosition?.removeListener(_onScroll);
    _scrollPosition = Scrollable.maybeOf(context)?.position;
    _scrollPosition?.addListener(_onScroll);
  }

  void _onScroll() {
    if (_popoverController.isOpen) {
      _popoverController.hide();
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    _popoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return ShadSelect<String>(
      popoverController: _popoverController,
      initialValue: widget.value,
      selectedOptionBuilder: (context, selectedValue) {
        return Text(
          selectedValue,
          style: TextStyle(
            fontSize: FontSizes.base,
            color: cs.foreground,
          ),
        );
      },
      options: widget.options.map((opt) {
        return ShadOption(
          value: opt,
          child: Text(
            opt,
            style: TextStyle(
              fontSize: FontSizes.base,
              color: cs.foreground,
            ),
          ),
        );
      }).toList(),
      onChanged: widget.onChanged != null
          ? (String? value) {
              if (value != null) widget.onChanged!(value);
            }
          : null,
    );
  }
}
