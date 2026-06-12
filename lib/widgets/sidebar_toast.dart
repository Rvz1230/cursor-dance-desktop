import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void showSidebarToast(
  BuildContext context, {
  required String title,
  String? description,
  bool destructive = false,
}) {
  ShadToaster.of(context).show(
    destructive
        ? ShadToast.destructive(
            title: Text(title),
            description: description != null ? Text(description) : null,
          )
        : ShadToast(
            title: Text(title),
            description: description != null ? Text(description) : null,
          ),
  );
}
