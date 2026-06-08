# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                    # Install dependencies
flutter run -d macos               # Run desktop app on macOS
flutter build macos                # Build release for macOS
flutter analyze                    # Static analysis (zero errors/warnings target)
flutter test                       # Run Dart tests
flutter pub upgrade --major-versions  # Upgrade dependencies
```

## Project Architecture

**CursorDance Desktop** — Flutter 桌面特效应用。配置窗口编辑特效参数，macOS 全屏覆盖层渲染鼠标点击反馈（粒子/涟漪/飘字）+ 键盘键入动效（字符弹跳/雨滴）。

### Layered Architecture

```
lib/
├── main.dart                       # ShadApp 入口
├── app/app.dart                    # CursorDanceApp Widget
├── pages/config_page.dart          # 三栏布局 orchestration（侧栏 | 内容 | 底部状态栏）
│   └── workspaces/
│       ├── workbench_workspace.dart # 主工作台
│       └── states_workspace.dart    # 光标状态管理
├── state/workbench_state.dart      # ChangeNotifier — 全局状态（主题/动作/配置/持久化 + KeyFeedbackConfig）
├── models/
│   ├── theme.dart                  # ThemeItem（内置主题列表）
│   ├── theme_draft.dart            # ThemeDraft（主题完整配置 + AtmosphereConfig）
│   ├── action_config.dart          # ActionConfig（~85 字段平铺，8 大类效果配置）
│   ├── action_config_presets.dart  # 各主题的默认动作预设
│   └── key_feedback_config.dart    # KeyFeedbackConfig（键盘键入动效独立配置）
├── widgets/
│   ├── workbench_header.dart       # 顶栏（Logo/Workspace Tabs/启用/保存）
│   ├── workbench_sidebar.dart      # 主题库侧栏（搜索/卡片/新建/导入导出）
│   ├── config_panel.dart           # 中间配置栏
│   ├── preview_panel.dart          # 预览面板
│   ├── action_tabs.dart            # 动作 Tab 切换
│   └── panels/                     # 各效果类型的配置卡片
│       ├── trigger_behavior_card.dart
│       ├── particle_feedback_card.dart
│       ├── ripple_feedback_card.dart
│       ├── text_feedback_card.dart
│       ├── audio_feedback_card.dart
│       ├── cursor_feedback_card.dart
│       ├── animation_feedback_card.dart
│       └── image_feedback_card.dart
│   └── controls/                   # 通用控件
│       ├── control_slider.dart
│       ├── color_options.dart
│       ├── field_row.dart
│       └── text_tag_editor.dart
├── effects/
│   └── effects_engine.dart         # EffectsEngine（粒子/涟漪/文字动画 + EffectsPainter）
└── bridge/
    └── overlay_bridge.dart         # MethodChannel 桥接（start/stop/updateConfig/updateKeyFeedbackConfig）

macos/
└── Runner/
    ├── OverlayManager.swift         # NSWindow 覆盖层 + 鼠标/键盘事件捕获
    ├── OverlayParticleFX.swift      # CAAnimation 粒子特效
    ├── OverlayRippleFX.swift        # CAAnimation 涟漪特效
    ├── OverlayTextFX.swift          # CAAnimation 飘字特效
    ├── OverlayKeyFeedbackFX.swift   # 键盘键入字符块动画（bounce/raindrop）
    ├── KeyLayoutMap.swift           # macOS keyCode → 归一化水平位置映射表
    ├── AnimationDriver.swift        # 手动动画引擎（含 KeyRecord）
    └── MainFlutterWindow.swift      # Flutter 配置窗口入口
```

### Key Architectural Principles

- **单进程双窗口**: ConfigWindow (Flutter) + OverlayWindow (原生 NSWindow, `.floating` + `.ignoresMouseEvents`)
- **状态管理**: ChangeNotifier，无 Provider/Riverpod，`WorkbenchState` 单例驱动所有 UI
- **Dart ↔ Swift 通信**: MethodChannel `cursor_dance/overlay`，JSON 序列化配置传递
- **渲染双轨制**: Flutter 侧 EffectsPainter (CustomPainter) 负责配置窗口内预览；macOS 侧 CAAnimation CALayer 负责全屏覆盖层
- **预览对齐**: 两端 easing 函数精确映射（cubic bezier Newton-Raphson 与 CAMediaTimingFunction 一致）；粒子/涟漪/文字从速度模型改为终点插值模型保证参数语义一致
- **ActionConfig**: 平铺 ~85 字段不嵌套，`toJson`/`fromJson` 序列化，不可变 class + `copyWith`

### Data Flow

```
用户编辑配置 → WorkbenchState.updateActionConfig()
                      ↓
          notifyListeners() → UI 重渲染
                      ↓
          OverlayBridge.updateConfig() → MethodChannel
                      ↓
          OverlayManager (Swift) → 解析 JSON → CAAnimation 更新

点击事件流:
          NSEvent.addGlobalMonitorForEvents(.leftMouseDown)
                      ↓
          OverlayManager.handleClick()
                      ↓
          particleFX / textFX / rippleFX → CALayer 动画

键盘事件流:
          NSEvent.addGlobalMonitorForEvents(.keyDown)
                      ↓
          OverlayManager.handleKeyPress()
                      ↓
          KeyLayoutMap 查表 → 归一化 X 坐标
                      ↓
          OverlayKeyFeedbackFX.spawn() → CATextLayer + KeyRecord
                      ↓
          AnimationDriver.advance() → bounce/raindrop 逐帧动画
```

### State Shape

`WorkbenchState`（继承 ChangeNotifier）:
- 选中主题 / 选中动作 / 选中光标状态
- `themeLibrary: List<ThemeItem>` — 主题列表
- `draftsByTheme: Map<String, ThemeDraft>` — 每个主题的编辑草稿
- `currentActionConfig` — 当前选中动作的配置（派生）
- `keyFeedbackConfig: KeyFeedbackConfig` — 键盘键入动效独立配置（独立于 ActionConfig）
- 持久化：`~/.cursordance/config.json`
