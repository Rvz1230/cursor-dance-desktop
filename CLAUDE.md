# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                    # Install dependencies
flutter run -d macos               # Run desktop app on macOS
flutter build macos                # Build release for macOS
flutter analyze                    # Static analysis (zero errors/warnings target)
flutter test                       # Run Dart tests
dart run build_runner build --delete-conflicting-outputs  # Generate freezed/json code
```

## Project Architecture

**CursorDance Desktop** — Flutter 桌面特效应用。配置窗口编辑特效参数，macOS 全屏覆盖层渲染鼠标点击反馈（粒子/涟漪/飘字）+ 键盘键入动效（字符弹跳/雨滴）。

### Layered Architecture (Reboot)

```
lib/
├── main.dart                       # ShadApp 入口
├── app/
│   ├── app.dart                    # CursorDanceApp (MultiProvider + ShadApp.router)
│   └── router.dart                 # GoRouter (/ → ConfigPage, /settings)
├── theme/
│   ├── tokens.dart                 # 设计令牌 (Spacing/RadiusTokens/FontSizes/ShadowTokens/AppColors)
│   ├── animations.dart             # 动画令牌 (Duration/Curve/组合效果)
│   └── app_theme.dart              # ShadThemeData light/dark + 子主题
├── models/
│   ├── action_config.dart          # ActionConfig (@freezed, ~85字段, 8大类)
│   ├── key_feedback_config.dart    # KeyFeedbackConfig (@freezed)
│   ├── theme.dart                  # ThemeItem (@freezed) + kBuiltinThemes
│   ├── theme_draft.dart            # ThemeDraft (手写copyWith) + AtmosphereConfig + CursorStateAsset
│   └── action_config_presets.dart  # 预设常量
├── providers/
│   ├── theme_provider.dart         # 主题库 + 草稿 + 选中态 + 键盘配置 + 持久化
│   ├── config_provider.dart        # 当前动作配置 + 冲突
│   └── overlay_provider.dart       # 覆盖层启停 + 同步
├── bridge/
│   └── overlay_bridge.dart         # MethodChannel (BridgeResult 枚举返回值)
├── repository/
│   └── persistence_repository.dart # 原子写入 + schemaVersion + 备份回退
├── services/
│   ├── preset_loader.dart          # PresetRepository (factory presets + theme overrides)
│   └── theme_io_service.dart       # 主题导出/导入
├── pages/
│   ├── config_page.dart            # 主页面 (Header + Sidebar + Workspace)
│   ├── settings_page.dart          # 设置占位
│   └── workspaces/
│       └── workbench_workspace.dart # 主工作台 (配置栏 + 预览)
├── widgets/
│   ├── workbench_header.dart       # 顶栏
│   ├── workbench_sidebar.dart      # 主题库侧栏
│   ├── config_panel.dart           # 配置面板
│   ├── preview_panel.dart          # 预览面板 (Phase 2: SharedRenderer)
│   └── action_tabs.dart            # 动作 Tab 切换
└── lints/
    └── cursor_dance_lints.dart     # custom_lint (fontSize/borderRadius/spacing)

macos/Runner/ (unchanged from main)
├── OverlayManager.swift            # NSWindow 覆盖层 + 事件捕获
├── OverlayParticleFX.swift         # CAAnimation 粒子
├── OverlayRippleFX.swift           # CAAnimation 涟漪
├── OverlayTextFX.swift             # CAAnimation 飘字
├── OverlayKeyFeedbackFX.swift      # 键盘字符动画
├── OverlayCursorFX.swift           # 光标反馈
├── OverlayAnimationFX.swift        # 动画特效
├── OverlayImageFX.swift            # 图片特效
├── AnimationDriver.swift           # 手动动画引擎
├── KeyLayoutMap.swift              # keyCode 位置映射
├── PreviewPlatformView.swift       # AppKitView 预览嵌入
└── MainFlutterWindow.swift         # Flutter 窗口入口
```

### Key Architectural Principles

- **单进程双窗口**: ConfigWindow (Flutter) + OverlayWindow (原生 NSWindow, `.screenSaver` + `.ignoresMouseEvents`)
- **状态管理**: Provider + ChangeNotifier (ThemeProvider / ConfigProvider / OverlayProvider)
- **Dart ↔ Swift 通信**: MethodChannel `cursor_dance/overlay`，JSON 序列化，BridgeResult 枚举返回值
- **模型层**: freezed + json_serializable，~85 字段平铺 ActionConfig，手写 ThemeDraft.copyWith
- **持久化安全**: 原子写入 (temp→rename) + schemaVersion 迁移 + 备份回退
- **设计令牌**: Spacing (呼吸感节奏) + ShadowTokens (三档层次感) + FontSizes + RadiusTokens
- **custom_lint**: 3/5 维度 (fontSize/borderRadius/spacing)，Phase 0 后续加 Color + SizedBox

### Design Principles

1. **层次感 (Depth)**: ShadowTokens 三档 (card < cardElevated < panel)，各层级微妙色差
2. **呼吸感 (Rhythm)**: lg=20, xl=28, section=40 (非4px倍数)，制造松紧交替
3. **记忆点 (Identity)**: 深色预览"舞台" + 品牌色调

### Constraints

- 所有 UI 用 shadcn_ui 组件，禁止 Material 组件
- 颜色从 `ShadTheme.of(context).colorScheme` 取，禁止硬编码
- 尺寸从 tokens 取，禁止数字字面量
- 阴影三档: card / cardElevated / panel
- 子主题从 app_theme.dart 取，Widget 中禁止覆盖
