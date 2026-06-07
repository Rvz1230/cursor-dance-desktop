import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../bridge/overlay_bridge.dart';
import '../state/workbench_state.dart';
import '../widgets/workbench_header.dart';
import '../widgets/workbench_sidebar.dart';
import 'workspaces/diagnostics_workspace.dart';
import 'workspaces/states_workspace.dart';
import 'workspaces/workbench_workspace.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => ConfigPageState();
}

class ConfigPageState extends State<ConfigPage> {
  final WorkbenchState _state = WorkbenchState();
  final OverlayBridge _bridge = OverlayBridge();
  String _lastConfigJson = '';

  @override
  void initState() {
    super.initState();
    _bridge.onOverlayStateChanged = (enabled) {
      _state.setEnabled(enabled);
    };
    _state.addListener(_onStateChanged);
    _state.loadSavedConfig().then((_) {
      if (_state.enabled) {
        _bridge.start(_buildConfigPayload());
      }
    });
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    _state.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    // Auto-update overlay when config changes and overlay is enabled
    if (_state.enabled) {
      final newJson = jsonEncode(_state.currentActionConfig.toJson());
      if (newJson != _lastConfigJson) {
        _lastConfigJson = newJson;
        _bridge.updateConfig(_buildConfigPayload());
      }
    }
    setState(() {});
  }

  Map<String, dynamic> _buildConfigPayload() {
    return {
      'actionId': _state.selectedActionId,
      'config': _state.currentActionConfig.toJson(),
    };
  }

  Future<void> _toggleEnabled() async {
    if (_state.enabled) {
      await _bridge.stop();
      _state.setEnabled(false);
    } else {
      _state.setEnabled(true);
      final payload = _buildConfigPayload();
      _lastConfigJson = jsonEncode(_state.currentActionConfig.toJson());
      await _bridge.start(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      children: [
        WorkbenchHeader(state: _state),
        Expanded(
          child: Row(
            children: [
              WorkbenchSidebar(state: _state),
              Expanded(
                child: _buildWorkspaceContent(),
              ),
            ],
          ),
        ),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            border: Border(
              top: BorderSide(color: theme.colorScheme.border),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _state.enabled ? LucideIcons.circle : LucideIcons.radio,
                size: 10,
                color: _state.enabled
                    ? const Color(0xFF22C55E)
                    : theme.colorScheme.mutedForeground,
              ),
              const SizedBox(width: 8),
              Text(
                _state.enabled ? '动效已启用' : '动效已停止',
                style: theme.textTheme.p.copyWith(
                  color: _state.enabled
                      ? const Color(0xFF22C55E)
                      : theme.colorScheme.mutedForeground,
                ),
              ),
              const Spacer(),
              ShadButton(
                onPressed: _toggleEnabled,
                backgroundColor: _state.enabled
                    ? theme.colorScheme.destructive
                    : theme.colorScheme.primary,
                child: Text(_state.enabled ? '停止' : '启用'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkspaceContent() {
    switch (_state.workspaceId) {
      case 'states':
        return StatesWorkspace(state: _state);
      case 'diagnostics':
        return DiagnosticsWorkspace(state: _state);
      default:
        return WorkbenchWorkspace(state: _state);
    }
  }
}
