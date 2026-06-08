import 'package:flutter/material.dart';

import '../../theme/app_tokens.dart';

/// 可拖拽列分割条 — 插件版 ColumnResizeHandle
///
/// 拖拽时更新分割比例，支持 hover 高亮和 cursor 变换。
class ColumnResizeHandle extends StatefulWidget {
  final void Function(double delta) onDrag;

  const ColumnResizeHandle({super.key, required this.onDrag});

  @override
  State<ColumnResizeHandle> createState() => _ColumnResizeHandleState();
}

class _ColumnResizeHandleState extends State<ColumnResizeHandle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) => widget.onDrag(details.delta.dx),
        child: Container(
          width: 12,
          color: Colors.transparent,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 3,
              height: _hovered ? 64 : 32,
              decoration: BoxDecoration(
                color: _hovered
                    ? AppColors.border
                    : AppColors.border.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
