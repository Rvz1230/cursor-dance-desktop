import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../providers/config_provider.dart';
import '../providers/overlay_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/workbench_header.dart';
import '../widgets/workbench_sidebar.dart';
import 'workspaces/keyboard_workspace.dart';
import 'workspaces/states_workspace.dart';
import 'workspaces/workbench_workspace.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => ConfigPageState();
}

class ConfigPageState extends State<ConfigPage> {
  bool _isLoaded = false;

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
          onGlobalToggle: (_) => _toggleEnabled(),
        ),
        Expanded(
          child: Row(
            children: [
              const WorkbenchSidebar(),
              Expanded(
                child: _buildWorkspaceContent(theme, config, overlay),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkspaceContent(
      ThemeProvider theme, ConfigProvider config, OverlayProvider overlay) {
    switch (theme.workspaceId) {
      case 'states':
        return const StatesWorkspace();
      case 'keyboard':
        return const KeyboardWorkspace();
      default:
        return WorkbenchWorkspace(
          config: config,
          theme: theme,
        );
    }
  }
}
