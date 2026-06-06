import 'package:flutter/material.dart';

import '../../state/workbench_state.dart';
import '../../widgets/action_tabs.dart';
import '../../widgets/config_panel.dart';
import '../../widgets/preview_panel.dart';

class WorkbenchWorkspace extends StatelessWidget {
  final WorkbenchState state;

  const WorkbenchWorkspace({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Config panel (left)
        Expanded(
          flex: 45,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActionTabs(
                  selectedActionId: state.selectedActionId,
                  onActionChanged: (id) => state.setActionId(id),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: ConfigPanel(
                      actionId: state.selectedActionId,
                      config: state.currentActionConfig,
                      conflicts: state.currentConflicts,
                      onUpdateConfig: state.updateActionConfig,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Preview panel (right)
        Expanded(
          flex: 55,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: PreviewPanel(
              actionId: state.selectedActionId,
              config: state.currentActionConfig,
            ),
          ),
        ),
      ],
    );
  }
}
