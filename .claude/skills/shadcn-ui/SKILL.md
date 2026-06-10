---
name: shadcn-ui
description: Shadcn UI 组件库（Flutter — shadcn_ui 0.54.0）。管理 shadcn 组件、设计令牌、主题配置、样式约束。当项目中涉及任何 UI 开发、组件选择、设计令牌使用时触发。
---

# CursorDance Flutter — shadcn_ui Skill

**适用项目：** CursorDance Desktop（Flutter 桌面应用）
**shadcn_ui 版本：** 0.54.0
**设计体系：** Soft-Minimal Linear（灵感来自 Linear、Radix UI、Apple HIG）

---

## 核心原则

所有 UI 开发遵循以下优先级链：

```
shadcn_ui 内置组件 ＞ ShadThemeData 子主题 ＞ app_tokens.dart 设计令牌 ＞ DESIGN_GUIDE.md 规则
```

**任何 UI 工作前，必须先执行以下检查清单（顺序不可变）：**

1. 打开 `DESIGN_GUIDE.md`（项目根目录），确认没有违反禁止项
2. 查阅本文档「组件决策表」，确认使用正确的 shadcn_ui 组件
3. 查阅 `lib/theme/app_tokens.dart`，确认所有尺寸/字体/圆角/间距引用正确的 token
4. 查阅 `lib/theme/app_theme.dart`，确认子主题配置是否已覆盖当前场景
5. 如果 shadcn_ui 无对应组件，才考虑用 `ShadPopover` / `ShadDecorator` 等底层组件封装

---

## 组件决策表

**禁止使用 Material 组件。** 以下是完整映射：

| UI 需求 | ✅ 使用 | ❌ 禁止 |
|---------|---------|---------|
| 弹出菜单（右键/点击） | `ShadContextMenuRegion(tapEnabled: true)` | `PopupMenuButton` |
| 下拉选择 | `ShadSelect<T>` | `DropdownButton` / `DropdownMenu` |
| 弹出层/气泡 | `ShadPopover` | `Overlay` / `PopupRoute` |
| 弹出层内菜单项 | `ShadContextMenuItem` | 手写 `Container + GestureDetector` |
| 卡片/面板 | `PanelCard`（项目封装） | `Card`（Material） |
| 手风琴/折叠 | `ShadAccordion` | `ExpansionTile` |
| 开关 | `ShadSwitch` | `Switch`（Material） |
| 输入框 | `ShadInput` | `TextField`（Material） |
| 按钮 | `ShadButton` | `ElevatedButton` / `TextButton` |
| 图标按钮 | `AppIconButton`（项目封装） | `IconButton`（Material） |
| 对话框 | `ShadDialog` / `AlertDialog` | `Dialog`（Material） |
| 标签/Tab | `ShadTabs` | `TabBar`（Material） |
| 滑块 | `ControlSlider`（项目封装，含 `ShadSlider`） | `Slider`（Material） |
| 提示 | `ShadTooltip` | `Tooltip`（Material） |
| 分隔线 | `ShadSeparator` / `PanelDivider`（项目封装） | `Divider`（Material） |
| Toast | `ShadToast` + `ShadToaster` | `SnackBar` |
| 复选框 | `ShadCheckbox` | `Checkbox`（Material） |
| 单选 | `ShadRadio` | `Radio`（Material） |
| 徽标 | `ShadBadge` | 手写 `Container` 徽标 |
| 头像 | `ShadAvatar` | `CircleAvatar` |
| 表格 | `ShadTable` | `DataTable` |
| 进度 | `ShadProgress` | `LinearProgressIndicator` |

**关键项目封装组件（优先使用，不要重复造轮子）：**
- `PanelCard` — 可折叠效果卡片（`lib/widgets/base/panel_card.dart`）
- `FieldRow` — 标签 + 控件双列布局（`lib/widgets/controls/field_row.dart`）
- `ControlSlider` — 滑块 + 数值显示（`lib/widgets/controls/control_slider.dart`）
- `ColorOptions` — 色板选择（`lib/widgets/controls/color_options.dart`）
- `SmallSelect` — 小号下拉选择（`lib/widgets/controls/small_select.dart`）
- `AppIconButton` — 统一图标按钮（`lib/widgets/controls/app_icon_button.dart`）
- `SectionTitle` — Section 标题（`lib/widgets/base/section_title.dart`）
- `PanelDivider` — 卡片内分隔线（`lib/widgets/base/panel_utils.dart`）
- `StatusIndicator` — 状态指示器（`lib/widgets/base/status_indicator.dart`）

---

## 主题系统

### ShadThemeData 配置（`lib/theme/app_theme.dart`）

当前已配置的子主题：
- `colorScheme` — ✅ 浅色 + 深色
- `textTheme` — ✅ h2/h3/h4/p/small/muted
- `radius` — ✅ 默认 `RadiusTokens.xl`（12px）
- `primaryToastTheme` — ✅

**所有 shadcn_ui 组件通过 `ShadTheme.of(context)` 自动获取主题。禁止在 Widget 构建方法中硬编码颜色、字体、圆角值。**

```dart
// ✅ 正确：从主题取
final cs = ShadTheme.of(context).colorScheme;
Text('标题', style: ShadTheme.of(context).textTheme.h4);

// ❌ 错误：硬编码
Text('标题', style: TextStyle(fontSize: 14, color: Color(0xFF0F172A)));
```

### 设计令牌（`lib/theme/app_tokens.dart`）

这是项目唯一的设计令牌源。任何 Widget 不得使用数字字面量。

| 令牌类 | 用途 | 禁止 |
|--------|------|------|
| `FontSizes` | micro(9) → caption(11) → small(12) → body(13) → base(14) → h4(14) → h3(16) → h2(18) | 禁止 `fontSize: 12` |
| `Spacing` | xs(4) → sm(8) → md(12) → lg(16) → xl(24) → xxl(32) → xxxl(48) | 禁止 `EdgeInsets.all(8)` |
| `RadiusTokens` | sm(4) → md(6) → lg(8) → xl(12) → xl2(16) | 禁止 `BorderRadius.circular(8)` |
| `IconSizes` | xs(10) → sm(12) → md(14) → lg(18) → xl(24) → xxl(32) → xxxl(48) | 禁止 `size: 14` |

---

## 禁止清单

以下操作在项目中严禁出现。详细规则见 `rules/` 目录。

### 样式禁止项（详见 `rules/styling.md`）
- ❌ 硬编码 `fontSize`、`BorderRadius`、`EdgeInsets` 数字字面量
- ❌ 硬编码颜色值（`Color(0xFF...)` 或 `const Color(...)`)
- ❌ 装饰性渐变、紫色、辉光效果
- ❌ 每个视图使用超过一个强调色
- ❌ `letterSpacing` 修改、全大写视觉风格
- ❌ `shadow-xl` / `shadow-2xl`

### 组件禁止项（详见 `rules/composition.md`）
- ❌ 使用任何 Material 组件（`PopupMenuButton`、`DropdownButton`、`Card`、`Switch`、`TextField`、`IconButton` 等）
- ❌ 用 `Container + BoxDecoration` 模拟已有 shadcn_ui 组件的效果
- ❌ 条件渲染（`if (_hovered)`）导致 widget tree 结构变化——用 `AnimatedOpacity` 代替

### 动画禁止项
- ❌ 全量动画
- ❌ `AnimatedContainer` 的退化回退
- ❌ 悬浮卡片上浮效果（`hover:-translateY`）
- ❌ `willChange: true` 硬编码

---

## 参考文档

- 设计系统：`DESIGN_GUIDE.md`
- 设计令牌：`lib/theme/app_tokens.dart`
- 主题配置：`lib/theme/app_theme.dart`
- 动画令牌：`lib/theme/animations.dart`
- 上次同类修复提交：`992fee9`（参考修复模式）
- shadcn_ui 源码：`~/.pub-cache/hosted/pub.dev/shadcn_ui-0.54.0/lib/src/components/`
