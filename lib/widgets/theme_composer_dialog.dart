import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../providers/theme_provider.dart';
import '../theme/tokens.dart';
import 'sidebar_toast.dart';

// ═══════════════════════════════════════════════════════════
// ThemeComposerDialog — 新建 + 导入
// ═══════════════════════════════════════════════════════════

class ThemeComposerDialog extends StatefulWidget {
  final String mode; // 'create' | 'import'
  final VoidCallback onClose;

  const ThemeComposerDialog({
    super.key,
    required this.mode,
    required this.onClose,
  });

  @override
  State<ThemeComposerDialog> createState() => _ThemeComposerDialogState();
}

class _ThemeComposerDialogState extends State<ThemeComposerDialog> {
  String _mode = 'create';

  final _nameController = TextEditingController();
  String? _baseThemeId;
  String? _createError;

  final _importController = TextEditingController();
  String? _importError;

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
    final theme = context.read<ThemeProvider>();
    _baseThemeId = theme.selectedThemeId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _importController.dispose();
    super.dispose();
  }

  List<_TemplateOption> _templateOptions(BuildContext context) {
    final theme = context.read<ThemeProvider>();
    return [
      const _TemplateOption(id: 'blank', label: '空白主题'),
      ...theme.themeLibrary.map(
        (t) => _TemplateOption(id: t.id, label: t.name),
      ),
    ];
  }

  void _handleCreate() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final theme = context.read<ThemeProvider>();
    try {
      theme.createTheme(name, basedOnThemeId: _baseThemeId);
      setState(() => _createError = null);
      widget.onClose();
      showSidebarToast(context, title: '已创建主题', description: name);
    } catch (e) {
      setState(() => _createError = e.toString());
    }
  }

  void _handleImport() {
    final text = _importController.text.trim();
    if (text.isEmpty) return;
    final theme = context.read<ThemeProvider>();
    try {
      final error = theme.importThemeFromText(text, 'imported');
      if (error != null) {
        setState(() => _importError = error);
      } else {
        widget.onClose();
        showSidebarToast(context, title: '已导入主题');
      }
    } catch (e) {
      setState(() => _importError = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final options = _templateOptions(context);

    return ShadDialog(
      title: Text(_mode == 'create' ? '新建主题' : '导入主题'),
      description: Text(
        _mode == 'create' ? '新建一个可编辑主题' : '粘贴主题 JSON 配置',
      ),
      actions: [
        ShadButton.ghost(
          onPressed: widget.onClose,
          child: const Text('取消'),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: cs.muted,
              borderRadius: BorderRadius.circular(RadiusTokens.lg),
            ),
            child: Row(
              children: [
                _TabButton(
                  label: '新建主题',
                  selected: _mode == 'create',
                  onTap: () => setState(() => _mode = 'create'),
                ),
                _TabButton(
                  label: '导入 JSON',
                  selected: _mode == 'import',
                  onTap: () => setState(() => _mode = 'import'),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),
          if (_mode == 'create') ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('主题名称',
                    style: TextStyle(fontSize: FontSizes.micro, fontWeight: FontWeight.w500, color: cs.mutedForeground)),
                const SizedBox(height: 4),
                ShadInput(
                  controller: _nameController,
                  placeholder: const Text('例如：Warm Click Studio'),
                  autofocus: true,
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('起始模板',
                    style: TextStyle(fontSize: FontSizes.micro, fontWeight: FontWeight.w500, color: cs.mutedForeground)),
                const SizedBox(height: 4),
                DropdownButton<String>(
                  value: _baseThemeId,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  items: options.map((opt) {
                    return DropdownMenuItem(
                      value: opt.id,
                      child: Text(opt.label, style: const TextStyle(fontSize: FontSizes.small)),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _baseThemeId = v);
                  },
                ),
              ],
            ),
            if (_createError != null) ...[
              const SizedBox(height: Spacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: cs.destructive.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(RadiusTokens.lg),
                ),
                child: Text(_createError!, style: TextStyle(fontSize: FontSizes.micro, color: cs.destructive)),
              ),
            ],
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(Spacing.sm),
                    decoration: BoxDecoration(
                      color: cs.muted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(RadiusTokens.lg),
                    ),
                    child: Text(
                      '新主题会先进入工作台，保存后写入配置。',
                      style: TextStyle(fontSize: FontSizes.micro, color: cs.mutedForeground),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                ShadButton(
                  onPressed: _handleCreate,
                  leading: const Icon(LucideIcons.plus, size: IconSizes.md),
                  child: const Text('创建主题'),
                ),
              ],
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                border: Border.all(color: cs.border, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(RadiusTokens.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Spacing.sm),
                        decoration: BoxDecoration(
                          color: cs.muted,
                          borderRadius: BorderRadius.circular(RadiusTokens.lg),
                        ),
                        child: Icon(LucideIcons.fileJson, size: IconSizes.md, color: cs.foreground),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('粘贴本地 JSON 主题配置',
                                style: TextStyle(fontSize: FontSizes.small, fontWeight: FontWeight.w500, color: cs.foreground)),
                            const SizedBox(height: 2),
                            Text('支持单个主题对象或带 themePack 包裹的 JSON。',
                                style: TextStyle(fontSize: FontSizes.micro, color: cs.mutedForeground)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  ShadInput(
                    controller: _importController,
                    placeholder: const Text('粘贴 JSON...'),
                    maxLines: 4,
                    minLines: 2,
                  ),
                  if (_importError != null) ...[
                    const SizedBox(height: Spacing.sm),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Spacing.sm),
                      decoration: BoxDecoration(
                        color: cs.destructive.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(RadiusTokens.lg),
                      ),
                      child: Text(_importError!, style: TextStyle(fontSize: FontSizes.micro, color: cs.destructive)),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: ShadButton(
                onPressed: _handleImport,
                leading: const Icon(LucideIcons.upload, size: IconSizes.md),
                child: const Text('导入'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TemplateOption {
  final String id;
  final String label;
  const _TemplateOption({required this.id, required this.label});
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: selected ? cs.card : Colors.transparent,
            borderRadius: BorderRadius.circular(RadiusTokens.lg),
            border: selected ? Border.all(color: cs.border) : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FontSizes.small,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
              color: selected ? cs.foreground : cs.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}
