import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../providers/config_provider.dart';
import '../providers/overlay_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/workbench_header.dart';
import '../widgets/workbench_sidebar.dart';
import 'workspaces/workbench_workspace.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => ConfigPageState();
}

class ConfigPageState extends State<ConfigPage> {
  bool _isLoaded = false;
  WorkspaceTab _workspaceTab = WorkspaceTab.actions;

  @override
  void initState() {
    super.initState();

    final overlay = context.read<OverlayProvider>();
    overlay.setOverlayStateChangedHandler((enabled) {
      if (!mounted) return;
      context.read<OverlayProvider>().setEnabled(enabled);
      if (enabled) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });

    final themeProvider = context.read<ThemeProvider>();
    themeProvider.loadSavedConfig().then((_) {
      if (!mounted) return;
      setState(() => _isLoaded = true);
      if (themeProvider.isWorkbench && overlay.enabled) {
        overlay.start();
      }
    });
  }

  Future<void> _toggleEnabled() async {
    final overlay = context.read<OverlayProvider>();
    if (overlay.enabled) {
      await overlay.stop();
      overlay.setEnabled(false);
    } else {
      overlay.setEnabled(true);
      await overlay.start();
    }
  }

  Future<AsyncSaveResult> _saveChanges() async {
    final theme = context.read<ThemeProvider>();
    final result = await theme.saveChanges();
    if (!mounted) return result;
    if (result.ok) {
      ShadToaster.of(context).show(
        const ShadToast(title: Text('已保存到配置')),
      );
    } else {
      ShadToaster.of(context).show(
        ShadToast.destructive(
          title: const Text('保存失败'),
          description: Text(result.error ?? '请稍后重试'),
        ),
      );
    }
    return result;
  }

  void _resetCurrentTheme() {
    final theme = context.read<ThemeProvider>();
    theme.resetCurrentTheme();
    ShadToaster.of(context).show(
      const ShadToast(title: Text('已恢复当前主题默认配置')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return Container(
        color: ShadTheme.of(context).colorScheme.background,
        child: const Center(
          child: SizedBox(
            width: 120,
            child: ShadProgress(),
          ),
        ),
      );
    }

    final theme = context.watch<ThemeProvider>();
    final config = context.watch<ConfigProvider>();
    final overlay = context.watch<OverlayProvider>();

    return Column(
      children: [
        WorkbenchHeader(
          overlayEnabled: overlay.enabled,
          unsaved: theme.unsaved,
          isSaving: theme.isSaving,
          workspaceTab: _workspaceTab,
          onWorkspaceTabChanged: (tab) => setState(() => _workspaceTab = tab),
          onToggleOverlay: _toggleEnabled,
          onSave: () => _saveChanges(),
          onReset: _resetCurrentTheme,
        ),
        Expanded(
          child: Row(
            children: [
              WorkbenchSidebar(onSave: _saveChanges),
              Expanded(
                child: WorkbenchWorkspace(
                  config: config,
                  theme: theme,
                  tab: _workspaceTab,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}