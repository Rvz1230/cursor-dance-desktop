import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../state/workbench_state.dart';
import '../theme/app_tokens.dart';
import '../services/overlay_sync_service.dart';
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
  final WorkbenchState _state = WorkbenchState();
  final OverlaySyncService _overlaySync = OverlaySyncService();

  @override
  void initState() {
    super.initState();
    _overlaySync.setOverlayStateChangedHandler((enabled) {
      _state.setEnabled(enabled);
      if (enabled) {
        // 失焦任何文本字段，防止中文 IME 候选框弹出在覆盖层上
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
    _state.addListener(_onStateChanged);
    _state.loadSavedConfig().then((_) {
      if (_state.enabled) {
        _overlaySync.start(_state);
      }
    });
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    _state.dispose();
    _overlaySync.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    _overlaySync.syncIfNeeded(_state);
  }

  Future<void> _toggleEnabled() async {
    if (_state.enabled) {
      await _overlaySync.stop();
      _state.setEnabled(false);
    } else {
      _state.setEnabled(true);
      await _overlaySync.start(_state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListenableBuilder(
          listenable: _state,
          builder: (context, _) => WorkbenchHeader(
            state: _state,
            onGlobalToggle: (_) => _toggleEnabled(),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              ListenableBuilder(
                listenable: _state,
                builder: (context, _) => WorkbenchSidebar(state: _state),
              ),
              Expanded(
                child: ListenableBuilder(
                  listenable: _state,
                  builder: (context, _) => _buildWorkspaceContent(),
                ),
              ),
            ],
          ),
        ),
        ListenableBuilder(
          listenable: _state,
          builder: (context, _) => _buildStatusBar(),
        ),
      ],
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _state.enabled ? LucideIcons.circle : LucideIcons.radio,
            size: 10,
            color: _state.enabled
                ? AppColors.success
                : AppColors.mutedForeground,
          ),
          const SizedBox(width: 8),
          Text(
            _state.enabled ? '动效已启用' : '动效已停止',
            style: TextStyle(
              fontSize: FontSizes.base,
              color: _state.enabled
                  ? AppColors.success
                  : AppColors.mutedForeground,
            ),
          ),
          const Spacer(),
          ShadButton(
            onPressed: _toggleEnabled,
            backgroundColor: _state.enabled
                ? AppColors.destructive
                : AppColors.primary,
            child: Text(_state.enabled ? '停止' : '启用'),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceContent() {
    switch (_state.workspaceId) {
      case 'states':
        return const StatesWorkspace();
      case 'keyboard':
        return KeyboardWorkspace(state: _state);
      default:
        return WorkbenchWorkspace(state: _state);
    }
  }
}
