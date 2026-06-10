# Styling Rules — shadcn_ui Flutter

## 颜色规则

1. **所有颜色从 `ShadTheme.of(context).colorScheme` 取，禁止硬编码。**
   ```dart
   // ✅ 正确
   final cs = ShadTheme.of(context).colorScheme;
   color: cs.foreground

   // ❌ 错误
   color: Color(0xFF0F172A)
   ```

2. **功能色使用语义 token，不直接写色值：**
   - 成功 → `cs.custom['success']`
   - 警告 → `cs.custom['warning']`
   - 危险 → `cs.destructive`
   - 主色 → `cs.primary`

3. **Slate 色板是唯一的基础色系。禁止引入其他色系（blue、indigo、purple 等）作为装饰。**

4. **辅助文字统一用 `cs.mutedForeground`，不要自定义灰色。**

5. **每个视图只允许一个强调色。例如：一个卡片内不能同时用 success 绿色 + warning 琥珀色做装饰。**

## 排版规则

1. **所有 `fontSize` 必须引用 `FontSizes.*`。**
   ```
   micro(9) → 极小（badge 小字）
   caption(11) → 辅助注解
   small(12) → 次要文字、菜单项、sidebar 摘要
   body(13) → 正文（macOS 标准）
   base(14) / h4(14) → 卡片标题 / 正文标题
   h3(16) → Section 标题
   h2(18) → 页面标题
   ```

2. **标题 `fontWeight` 必须用 600（semibold），不用 700。**
   特例：`fontWeight: 700` 仅在 `ShadThemeData.textTheme.h2` 中合法（DESIGN_GUIDE.md 指定 h2 为 700）。

3. **颜色层级规则：**
   - 标题 → `cs.foreground`
   - 正文 → `cs.foreground`
   - 辅助文字/占位符 → `cs.mutedForeground`
   - 禁用态 → `cs.mutedForeground.withValues(alpha: 0.5)`

4. **禁止修改 `letterSpacing`。**
5. **禁止全大写作为视觉风格。**
6. **数字使用 `FontFeature.tabularFigures()` 保持宽度一致。**

## 间距规则

1. **4px 基线网格：所有间距必须是 4 的倍数。**
2. **所有间距必须引用 `Spacing.*`：**
   ```
   xs(4) → 极小间距（图标与文字间距、同组元素间距）
   sm(8) → 小间距（卡片内 padding、列表项间距）
   md(12) → 中等间距（Section 间、控件间距）
   lg(16) → 大间距（面板 padding、区块间距）
   xl(24) → 超大间距
   xxl(32) → 页面级间距
   xxxl(48) → 顶级容器间距
   ```

## 圆角规则

1. **所有 `BorderRadius.circular()` 必须引用 `RadiusTokens.*`：**
   ```
   sm(4) → 极细节
   md(6) → Chip / Badge 近似
   lg(8) → Chip / Badge / 菜单项
   xl(12) → 卡片 / 面板 / 按钮 / 输入框
   xl2(16) → 弹窗 / Dialog / Popover
   ```

## 阴影规则

1. **禁止 `shadow-xl` 和 `shadow-2xl`。**
2. **使用 `shadow-sm`（卡片）和 `shadow-lg`（浮层）。**

## 图标规则

1. **所有图标尺寸引用 `IconSizes.*`：**
   ```
   xs(10) → badge 内图标
   sm(12) → 行内图标
   md(14) → 按钮内图标
   lg(18) → 卡片 header 图标
   xl(24) → 空状态图标
   xxl(32) → Hero 图标
   xxxl(48) → 占位/设置页图标
   ```
2. **图标颜色从 `cs.mutedForeground` 取，不要硬编码灰色。**

## 条件渲染规则

1. **禁止使用 `if (condition)` 在 widget tree 中插入/移除元素。**
   这会触发布局重排和二次 hover 事件。
   
   ```dart
   // ✅ 正确：始终渲染，仅改变透明度
   AnimatedOpacity(
     duration: AppAnimations.fastish,
     opacity: _hovered ? 1.0 : 0.0,
     child: Icon(...),
   )

   // ❌ 错误：条件插入导致布局变化
   if (_hovered) Icon(...)
   ```

2. **所有交互元素使用 `ScaleTap` 包装（按下 `0.97` / 抬起 `1.0`，时长 `100ms`）。**
