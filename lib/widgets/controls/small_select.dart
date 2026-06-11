import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../theme/tokens.dart';

class SmallSelect extends StatefulWidget {
  final String value;
  final List<SelectOption> options;
  final ValueChanged<String?>? onChanged;

  const SmallSelect({
    super.key,
    required this.value,
    required this.options,
    this.onChanged,
  });

  @override
  State<SmallSelect> createState() => _SmallSelectState();
}

class _SmallSelectState extends State<SmallSelect> {
  late final ShadSelectController<String> _selectController;
  late final ShadPopoverController _popoverController;
  ScrollPosition? _scrollPosition;

  void _onScroll() {
    if (_popoverController.isOpen) _popoverController.hide();
  }

  void _attachScrollListener() {
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) return;
    _scrollPosition = scrollable.position;
    _scrollPosition?.addListener(_onScroll);
  }

  void _detachScrollListener() {
    _scrollPosition?.removeListener(_onScroll);
    _scrollPosition = null;
  }

  @override
  void initState() {
    super.initState();
    _selectController = ShadSelectController(initialValue: {widget.value});
    _popoverController = ShadPopoverController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _attachScrollListener());
  }

  @override
  void didUpdateWidget(SmallSelect old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      _selectController.value = {widget.value};
    }
  }

  @override
  void dispose() {
    _detachScrollListener();
    _popoverController.dispose();
    _selectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadSelect<String>(
      controller: _selectController,
      popoverController: _popoverController,
      onChanged: widget.onChanged,
      selectedOptionBuilder: (context, v) => Text(
        v,
        style: const TextStyle(fontSize: FontSizes.small),
      ),
      options: widget.options
          .map((o) => ShadOption(value: o.value, child: Text(o.label)))
          .toList(),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: 5,
      ),
    );
  }
}

class SelectOption {
  final String value;
  final String label;

  const SelectOption({required this.value, required this.label});
}
