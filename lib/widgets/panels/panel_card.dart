import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PanelCard extends StatelessWidget {
  final String id;
  final Widget title;
  final Widget? action;
  final Widget child;
  final bool defaultOpen;

  const PanelCard({
    super.key,
    required this.id,
    required this.title,
    this.action,
    required this.child,
    this.defaultOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShadAccordionItem(
      value: id,
      title: Row(
        children: [
          Expanded(child: DefaultTextStyle(
            style: ShadTheme.of(context).textTheme.p.copyWith(
              fontWeight: FontWeight.w600,
            ),
            child: title,
          )),
          ?action,
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: child,
      ),
    );
  }
}
