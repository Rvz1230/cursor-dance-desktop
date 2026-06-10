# Composition Rules — shadcn_ui Flutter

## 组件选择原则

1. **写任何 UI 之前，先查本文档的「组件决策表」和 shadcn_ui 是否有对应组件。**
   - 组件列表：`/Users/rvz/.pub-cache/hosted/pub.dev/shadcn_ui-0.54.0/lib/src/components/`
   - 内容包括：`accordion, alert, avatar, badge, breadcrumb, button, calendar, card, checkbox, context_menu, date_picker, dialog, form, icon_button, input, input_otp, menubar, popover, progress, radio, resizable, select, separator, sheet, slider, sonner, switch, table, tabs, textarea, time_picker, toast, tooltip`

2. **如果 shadcn_ui 有对应组件，必须用它。没有例外。**
   - 弹出菜单 → `ShadContextMenuRegion(tapEnabled: true)`（不是 PopupMenuButton）
   - 右键菜单 → `ShadContextMenuRegion`（不是手写 Overlay）
   - 下拉选择 → `ShadSelect<T>`（不是 DropdownButton）

3. **如果 shadcn_ui 没有现成组件，优先用底层的 `ShadPopover` + `ShadDecorator` 组合封装，不要用 Material widget。**

## 现有项目封装（优先使用）

| 封装组件 | 路径 | 用途 |
|---------|------|------|
| `PanelCard` | `widgets/base/panel_card.dart` | 效果卡片（collapsible header + body） |
| `FieldRow` | `widgets/controls/field_row.dart` | 标签(104px) + 控件双列布局 |
| `ControlSlider` | `widgets/controls/control_slider.dart` | 滑条 + 后缀值显示 |
| `ColorOptions` | `widgets/controls/color_options.dart` | 预设色块行 |
| `SmallSelect` | `widgets/controls/small_select.dart` | 小号下拉（基于 ShadSelect） |
| `AppIconButton` | `widgets/controls/app_icon_button.dart` | 统一图标按钮 |
| `SectionTitle` | `widgets/base/section_title.dart` | Section 标题 |
| `PanelDivider` | `widgets/base/panel_utils.dart` | 卡片内 1px 分割线 |
| `StatusIndicator` | `widgets/base/status_indicator.dart` | 状态指示器 |
| `InfoBanner` | `widgets/base/info_banner.dart` | 信息横幅（error/warning/success） |
| `ScaleTap` | `widgets/controls/scale_tap.dart` | 缩放点击反馈 |
| `PanelMeta` | `widgets/base/panel_meta.dart` | 效果卡片 icon + 色调元数据 |

## 弹出层/下拉框规则

1. **所有弹出层（popover、select dropdown、context menu）样式由 `ShadThemeData` 子主题统一控制，禁止在单个 Widget 中覆盖样式。**
   需要配置的子主题：
   - `popoverTheme` — 控制 `ShadPopover`、`ShadSelect` 弹出、`ShadContextMenu` 弹出
   - `selectTheme` — 控制 `ShadSelect` 输入框
   - `optionTheme` — 控制 `ShadOption` 菜单项
   - `contextMenuTheme` — 控制 `ShadContextMenu` 弹出

2. **【关键】在可滚动容器内使用 `ShadSelect` 或 `ShadPopover` 时，必须监听滚动事件并关闭弹出层。**
   `SmallSelect` 已经内置了此逻辑（`didChangeDependencies` 中监听 `Scrollable.position`）。其他直接使用 `ShadSelect`/`ShadPopover` 的地方，需要同样的处理。

3. **弹出菜单的每个菜单项使用 `ShadContextMenuItem`，不要手写 `Container + GestureDetector`。**

## Overlay 位置规则

1. **`ShadSelect` 的弹出层通过 `ShadPortal` + `LayerLink` 定位到触发器。滚动时 overlay 位置不会自动更新。**
   修复方式：在 `didChangeDependencies` 中获取 `Scrollable.maybeOf(context)?.position` 并添加 `removeListener`，滚动时调用 `popoverController.hide()`。

## PanelCard 规则

按照 `DESIGN_GUIDE.md` 中的组件规范：

```
┌─ rounded-xl border shadow-sm ─────────────────┐
│ [icon 36px] Title           [action] [chevron] │
│  tone circle  subtitle                          │
│─────────────────────────────────────────────── │
│ 内容区 (px-4 py-3)                             │
└────────────────────────────────────────────────┘
```

- Header 点击可折叠
- Body 区域只在展开态渲染（非 `Opacity` 隐藏）
- 禁用态 body 使用 `Opacity(0.5)`

## FieldRow 规则

- 标签区宽度固定 104px
- hint 为可选项
- 标签 `fontSize: FontSizes.base, fontWeight: FontWeight.w500`
- hint `fontSize: FontSizes.small, color: cs.mutedForeground`
