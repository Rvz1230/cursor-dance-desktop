import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../state/workbench_state.dart';
import '../theme/app_tokens.dart';

/// Modal dialog for creating or importing themes.
///
/// Extracted from workbench_sidebar.dart for maintainability.
class ThemeComposerModal extends StatefulWidget {
  final WorkbenchState state;
  final void Function(String message) onShowToast;
  final void Function(String message) onError;

  const ThemeComposerModal({
    super.key,
    required this.state,
    required this.onShowToast,
    required this.onError,
  });

  @override
  State<ThemeComposerModal> createState() => _ThemeComposerModalState();
}

class _ThemeComposerModalState extends State<ThemeComposerModal> {
  int _tabIndex = 0;
  final _createNameController = TextEditingController();
  final _importController = TextEditingController();
  String _createBaseThemeId = '';
  String _createError = '';
  String _importError = '';
  String _importSuccess = '';

  @override
  void initState() {
    super.initState();
    _createBaseThemeId = widget.state.selectedThemeId;
  }

  @override
  void dispose() {
    _createNameController.dispose();
    _importController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;

    return Dialog(
      child: Container(
        width: 420,
        constraints: const BoxConstraints(maxHeight: 520),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(RadiusTokens.xl2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: cs.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '主题管理',
                          style: TextStyle(
                            fontSize: FontSizes.h3,
                            fontWeight: FontWeight.w600,
                            color: cs.foreground,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '新建一个可编辑主题，或导入现有 JSON 主题包。',
                          style: TextStyle(
                            fontSize: FontSizes.small,
                            color: cs.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(LucideIcons.x, size: IconSizes.md),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: '关闭',
                  ),
                ],
              ),
            ),
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: 12),
              child: Row(
                children: [
                  _buildTab(cs, '新建主题', 0),
                  const SizedBox(width: Spacing.xs),
                  _buildTab(cs, '导入 JSON', 1),
                ],
              ),
            ),
            // Content
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, Spacing.lg),
                child: SingleChildScrollView(
                  child: _tabIndex == 0 ? _buildCreateTab(cs) : _buildImportTab(cs),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(ShadColorScheme cs, String label, int index) {
    final active = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(RadiusTokens.md),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: FontSizes.small,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            color: active ? cs.primaryForeground : cs.mutedForeground,
          ),
        ),
      ),
    );
  }

  // ── Create Tab ──

  Widget _buildCreateTab(ShadColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(cs: cs, text: '主题名称'),
        const SizedBox(height: Spacing.xs),
        ShadInput(
          controller: _createNameController,
          placeholder: const Text('例如：极光幻彩'),
          autofocus: true,
        ),
        const SizedBox(height: Spacing.lg),
        _FieldLabel(cs: cs, text: '起始模板'),
        const SizedBox(height: Spacing.xs),
        _buildBaseThemeSelector(cs),
        const SizedBox(height: Spacing.lg),
        if (_createError.isNotEmpty) ...[
          _buildErrorBox(cs, _createError),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
                decoration: BoxDecoration(
                  color: cs.custom['warning']?.withValues(alpha: 0.08) ?? cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(RadiusTokens.sm),
                ),
                child: Text(
                  '新主题会先进入工作台，保存后写入配置文件',
                  style: TextStyle(fontSize: FontSizes.caption, color: cs.custom['warning'] ?? cs.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ShadButton(
              onPressed: _handleCreate,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.plus, size: IconSizes.md),
                  const SizedBox(width: Spacing.xs),
                  const Text('创建主题'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBaseThemeSelector(ShadColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.muted,
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        border: Border.all(color: cs.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _createBaseThemeId,
          isExpanded: true,
          style: TextStyle(fontSize: FontSizes.small, color: cs.foreground),
          items: [
            const DropdownMenuItem(
              value: 'blank',
              child: Text('空白主题'),
            ),
            ...widget.state.themeLibrary.map((t) => DropdownMenuItem(
              value: t.id,
              child: Text(t.name),
            )),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _createBaseThemeId = v);
          },
        ),
      ),
    );
  }

  void _handleCreate() {
    final name = _createNameController.text.trim();
    if (name.isEmpty) {
      setState(() => _createError = '请输入主题名称');
      return;
    }
    setState(() => _createError = '');
    widget.state.createTheme(
      name,
      basedOnThemeId: _createBaseThemeId == 'blank' ? null : _createBaseThemeId,
    );
    widget.onShowToast('已创建主题「$name」');
    if (mounted) Navigator.of(context).pop();
  }

  // ── Import Tab ──

  Widget _buildImportTab(ShadColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Spacing.lg),
          decoration: BoxDecoration(
            color: cs.muted,
            borderRadius: BorderRadius.circular(RadiusTokens.xl2),
            border: Border.all(color: cs.border, width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(RadiusTokens.xl),
                ),
                child: Icon(
                  LucideIcons.fileJson,
                  size: IconSizes.lg,
                  color: cs.mutedForeground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '粘贴 JSON 主题包',
                style: TextStyle(fontSize: FontSizes.base, fontWeight: FontWeight.w600, color: cs.foreground),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                '支持直接导入单个主题对象，也支持带 themePack / theme 包裹的 JSON。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: FontSizes.small, color: cs.mutedForeground),
              ),
              const SizedBox(height: Spacing.lg),
              ShadInput(
                controller: _importController,
                maxLines: 4,
                placeholder: const Text('在此粘贴 JSON 内容...'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ShadButton(
                      onPressed: _handleImport,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.upload, size: IconSizes.md),
                          const SizedBox(width: Spacing.xs),
                          const Text('导入'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: ShadButton(
                      onPressed: _handlePasteFromClipboard,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.clipboardPaste, size: IconSizes.md),
                          const SizedBox(width: Spacing.xs),
                          const Text('从剪贴板粘贴'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_importSuccess.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildSuccessBox(cs, _importSuccess),
        ],
        if (_importError.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildErrorBox(cs, _importError),
        ],
      ],
    );
  }

  void _handleImport() {
    final text = _importController.text.trim();
    if (text.isEmpty) {
      setState(() => _importError = '请输入或粘贴 JSON 内容');
      return;
    }
    try {
      widget.state.importThemeFromText(text, '导入主题');
      setState(() {
        _importError = '';
        _importSuccess = '已导入主题';
      });
      widget.onShowToast('已导入主题');
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _importError = '导入失败：$e');
    }
  }

  void _handlePasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      _importController.text = data.text!;
    }
  }

  Widget _buildErrorBox(ShadColorScheme cs, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.destructive.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: cs.destructive.withValues(alpha: 0.15)),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: FontSizes.caption, color: cs.destructive),
      ),
    );
  }

  Widget _buildSuccessBox(ShadColorScheme cs, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.custom['success']?.withValues(alpha: 0.06) ?? const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(
          color: cs.custom['success']?.withValues(alpha: 0.2) ?? const Color(0xFF6EE7B7).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.checkCircle2, size: IconSizes.sm, color: cs.custom['success'] ?? const Color(0xFF065F46)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: FontSizes.caption, color: cs.custom['success'] ?? const Color(0xFF065F46)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final ShadColorScheme cs;
  final String text;
  const _FieldLabel({required this.cs, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: FontSizes.small,
        fontWeight: FontWeight.w500,
        color: cs.mutedForeground,
      ),
    );
  }
}
