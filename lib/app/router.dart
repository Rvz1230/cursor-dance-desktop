import 'package:go_router/go_router.dart';

import '../pages/config_page.dart';
import '../pages/settings_page.dart';

/// CursorDance 路由表
///
/// 当前只有单页 + 设置占位页。工作区切换保持状态驱动（不映射到路由）。
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'config',
      builder: (context, state) => const ConfigPage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
