import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../pages/config_page.dart';
import '../theme/app_theme.dart';

class CursorDanceApp extends StatelessWidget {
  const CursorDanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      title: 'CursorDance',
      theme: appTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const ConfigPage(),
    );
  }
}
