import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'pages/config_page.dart';

void main() {
  runApp(const CursorDanceApp());
}

class CursorDanceApp extends StatelessWidget {
  const CursorDanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      title: 'CursorDance',
      debugShowCheckedModeBanner: false,
      home: const ConfigPage(),
    );
  }
}
