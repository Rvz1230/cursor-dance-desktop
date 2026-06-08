import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../bridge/overlay_bridge.dart';
import '../state/workbench_state.dart';
import '../theme/app_tokens.dart';
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
  final OverlayBridge _bridge = OverlayBridge();
  String _lastConfigJson = '';
  String _lastKeyConfigJson = '';

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
        _sendKeyFeedbackConfig();
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
    if (_state.enabled) {
      final newJson = jsonEncode(_state.currentActionConfig.toJson());
      if (newJson != _lastConfigJson) {
        _lastConfigJson = newJson;
        _bridge.updateConfig(_buildConfigPayload());
      }
      _sendKeyFeedbackConfig();
    }
    setState(() {});
  }

  Map<String, dynamic> _buildConfigPayload() {
    return {
      'actionId': _state.selectedActionId,
      'config': _state.currentActionConfig.toJson(),
    };
  }

  void _sendKeyFeedbackConfig() {
    final newKeyJson = jsonEncode(_state.keyFeedbackConfig.toJson());
    if (newKeyJson != _lastKeyConfigJson) {
      _lastKeyConfigJson = newKeyJson;
      _bridge.updateKeyFeedbackConfig(_state.keyFeedbackConfig.toJson());
    }
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
        _buildStatusBar(),
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
