import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../providers/config_provider.dart';
import '../providers/overlay_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import 'router.dart';

class CursorDanceApp extends StatelessWidget {
  const CursorDanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProxyProvider<ThemeProvider, ConfigProvider>(
          create: (ctx) => ConfigProvider(
            themeProvider: ctx.read<ThemeProvider>(),
          ),
          update: (ctx, themeProvider, previous) =>
              previous ?? ConfigProvider(themeProvider: themeProvider),
        ),
        ChangeNotifierProxyProvider2<ThemeProvider, ConfigProvider, OverlayProvider>(
          create: (ctx) => OverlayProvider(
            themeProvider: ctx.read<ThemeProvider>(),
            configProvider: ctx.read<ConfigProvider>(),
          ),
          update: (ctx, themeProvider, configProvider, previous) =>
              previous ?? OverlayProvider(
                themeProvider: themeProvider,
                configProvider: configProvider,
              ),
        ),
      ],
      child: ShadApp.router(
        title: 'CursorDance',
        theme: appTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}
