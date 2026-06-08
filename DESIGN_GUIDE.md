# CursorDance Desktop Design Guide

Soft-Minimal Linear — 灵感来自 Linear, Radix UI, Apple HIG。

## 核心精神

- **克制**：UI 不应喧宾夺主，用户关注的是特效本身
- **柔软**：大圆角、1px 边框、浅阴影、克制的反馈
- **线性**：单色 slate 体系，功能色仅用于语义，不用于装饰

---

## 色彩

### 主色板：Slate

| Token | Value | 用途 |
|---|---|---|
| `background` | `#F8F8FA` | 页面底色 |
| `foreground` | `#0F172A` | 标题/正文 |
| `card` | `#FFFFFF` | 卡片/面板 |
| `muted` | `#F1F5F9` | 次要背景、禁用态 |
| `mutedForeground` | `#64748B` | 辅助文字、占位符 |
| `border` | `#E2E8F0` | 容器边框 |
| `input` | `#E2E8F0` | 表单控件边框 |

### 语义功能色

| Tone | 用途 |
|---|---|
| `emerald-500` | 成功、启用指示器 |
| `rose-600` | 删除、错误、危险操作 |
| `sky-500` | 信息提示、AI 功能 |
| `amber-500` | 警告、未保存指示器、自定义主题 |
| `teal-500` | 内置主题指示器 |

### 效果卡片色调

每张效果卡片有一个独立的 tone 色，用于 icon circle、选中态、徽标：

| 效果 | BG | FG |
|---|---|---|
| 触发行为 | `#D1FAE5` emerald-100 | `#047857` emerald-700 |
| 飘字 | `#FEF3C7` amber-100 | `#B45309` amber-700 |
| 粒子 | `#E0F2FE` sky-100 | `#0369A1` sky-700 |
| 波纹 | `#CCFBF1` teal-100 | `#0D9488` teal-700 |
| 音效 | `#FFE4E6` rose-100 | `#BE123C` rose-700 |
| 动画 | `#CFFAFE` cyan-100 | `#0E7490` cyan-700 |
| 贴图 | `#FAE8FF` fuchsia-100 | `#A21CAF` fuchsia-700 |
| 光标 | `#F1F5F9` slate-100 | `#334155` slate-700 |

### 禁止清单

- ❌ 装饰性渐变（`linear-gradient` / `radial-gradient`）
- ❌ 紫色、多色渐变、辉光效果
- ❌ 每个视图只允许一个强调色，不允许混用

---

## 圆角

| 层级 | 值 | 用途 |
|---|---|---|
| `none` | 0 | — |
| `sm` | 4px | 极细节 |
| `lg` | 8px | Chip / Badge / 菜单项 |
| `xl` | 12px | 卡片 / 面板 / 按钮 / 输入框 |
| `xl2` | 16px | 弹窗 / Dialog / Popover |

- ❌ 禁止使用任意值 `BorderRadius.circular(...)`，必须引用 `RadiusTokens`

---

## 阴影

| 层级 | 值 | 用途 |
|---|---|---|
| `shadow-sm` | `0 1px 2px rgba(0,0,0,0.03)` | 卡片 / 面板 / 按钮 |
| `shadow-lg` | `0 4px 12px rgba(0,0,0,0.08)` | 浮层 / Popover / Dialog |

- ❌ 禁止 `shadow-xl` 和 `shadow-2xl`

---

## 排版

### 字号层级

| Token | Size | Weight | 用途 |
|---|---|---|---|
| `h2` | 18px | 700 | 页面标题 |
| `h3` | 16px | 600 | Section 标题 |
| `h4` / `base` | 14px | 600 / 400 | 卡片标题 / 正文 |
| `body` | 13px | 400 | 正文（macOS 标准） |
| `small` | 12px | 400 | 次要文字 |
| `caption` | 11px | 400 | 辅助注解 |

### 规则

- 标题用 `fontWeight: 600`（semibold），不用 700
- 颜色层级：标题 `foreground` / 正文 `foreground` / 辅助 `mutedForeground`
- ❌ 禁止修改 `letterSpacing`
- ❌ 禁止全大写作为视觉风格
- 数字使用 `FontFeature.tabularFigures()` 保持宽度一致

---

## 过渡与动画

- 默认时长：`150ms`（`easeOut`）
- 允许动画的属性：`color`, `backgroundColor`, `borderColor`, `opacity`, `transform`
- ❌ 禁止全量动画（`AnimatedContainer` 的 `duration` 之外的退化回退）
- 点击反馈：所有交互元素使用缩放 `0.97`（按下）/ `1.0`（抬起），时长 `100ms`
- ❌ 禁止悬浮卡片上浮效果（`hover:-translateY`）
- ❌ 禁止 `willChange: true` 硬编码在样式中（仅动态注入）

---

## 布局

- 4px 基线网格：所有间距/尺寸必须是 4 的倍数
- 使用 `Spacing` tokens，禁止硬编码间距值
- 全高容器使用 `double.infinity` + `Expanded`，非 `h-screen` 等效
- z-index 使用固定层级（浮层 `z-50`，覆盖层 `z-40`），禁止任意值

---

## 组件规范

### PanelCard

```
┌─ rounded-xl border shadow-sm ─────────────────┐
│ [icon 36px] Title           [action] [chevron] │
│  tone circle  subtitle                          │
│─────────────────────────────────────────────── │
│ 内容区 (px-4 py-3)                             │
└────────────────────────────────────────────────┘
```

- Header 点击可折叠（collapsible）
- Body 区域只在展开态渲染（非 `Opacity` 隐藏）
- 禁用态 body 使用 `Opacity(0.5)`

### FieldRow

```
标签 (104px)          控件
text-sm font-medium   (expanded)
hint text-xs muted
```

- 标签区宽度固定 104px
- hint 为可选项

### ControlSlider

```
┌─ rounded-xl border bg-muted ─────┐
│ [━━━━━━━━●━━━━━━━]      42px     │
│  ShadSlider             tabular  │
└──────────────────────────────────┘
```

- 背景容器：`muted` / `border`
- 数值使用 `tabularFigures` 字体特性
- 拖拽时显示浮动 tooltip

### ColorOptions

- 预设色块圆点行（28px 圆形，8px 间距）
- 选中项 2.5px `foreground` 边框
- 未选中项 1px `border` 边框
- 可扩展为弹出式选择器（预设 + 拾色器 + hex 输入）

---

## Accessibility

- 所有图标按钮必须有 `semanticLabel`
- 不支持 `prefers-reduced-motion`（桌面特效工具，动画是核心功能）
- 键盘导航：Tab 键在各面板间移动
- 焦点指示器使用 `ShadButton` 默认的 `focusNode` 样式

---

## 引用

本指南与插件版 [DESIGN.md](../cursor-dance/DESIGN.md) 保持一致。
设计 Token 实现见 `lib/theme/app_tokens.dart`。
