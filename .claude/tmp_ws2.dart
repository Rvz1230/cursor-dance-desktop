
// ═══════════════════════════════════════════════════════════
// Export dialog (standalone)
// ═══════════════════════════════════════════════════════════

void _showExportDialog(BuildContext context, String jsonText) {
  showShadDialog(
    context: context,
    builder: (ctx) => ShadDialog(
      title: const Text('导出主题'),
      description: const Text('复制以下 JSON 保存主题配置'),
      actions: [
        ShadButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: jsonText));
            Navigator.of(ctx).pop();
          },
          leading: const Icon(LucideIcons.copy, size: IconSizes.md),
          child: const Text('复制'),
        ),
      ],
      child: Container(
        constraints: const BoxConstraints(maxHeight: 200),
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: ShadTheme.of(ctx).colorScheme.muted,
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
        ),
        child: SingleChildScrollView(
          child: SelectableText(
            jsonText,
            style: TextStyle(
              fontSize: FontSizes.micro,
              fontFamily: 'monospace',
              color: ShadTheme.of(ctx).colorScheme.foreground,
            ),
          ),
        ),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════
// SwitchConfirmDialog — built inline via builder
// ═══════════════════════════════════════════════════════════

// The switch confirm dialog is shown from the sidebar state directly.
// We export a builder function for use in ConfigPage.

void showSwitchConfirmDialog({
  required BuildContext context,
  required String currentThemeName,
  required bool isSaving,
  required VoidCallback onSaveAndSwitch,
  required VoidCallback onDiscardAndSwitch,
  required VoidCallback onCancel,
}) {
  showShadDialog(
    context: context,
    builder: (ctx) => ShadDialog(
      title: Text('「$currentThemeName」有未保存的更改'),
      description: const Text(
        '切换主题前要保存这些更改吗？不保存的更改不会丢失，但关闭页面后会消失。',
      ),
      actions: [
        ShadButton.ghost(
          onPressed: () {
            onCancel();
            Navigator.of(ctx).pop();
          },
          child: const Text('取消'),
        ),
        ShadButton.ghost(
          onPressed: () {
            onDiscardAndSwitch();
            Navigator.of(ctx).pop();
          },
          child: const Text('不保存直接切换'),
        ),
        ShadButton(
          onPressed: isSaving
              ? null
              : () {
                  onSaveAndSwitch();
                  Navigator.of(ctx).pop();
                },
          child: Text(isSaving ? '保存中...' : '保存并切换'),
        ),
      ],
    ),
  );
}