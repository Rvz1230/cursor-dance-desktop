import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/theme_draft.dart';
import '../../providers/theme_provider.dart';
import '../../services/cursor_storage_service.dart';
import '../../theme/tokens.dart';
import '../base/panel_card.dart';
import '../base/panel_meta.dart';
import '../controls/wip_badge.dart';

class CursorAppearanceCard extends StatelessWidget {
  const CursorAppearanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final draft = theme.currentDraft;
    final customizedCount = kCursorStates.keys
        .where((id) => draft.cursorStates.containsKey(id))
        .length;

    return PanelCard(
      id: 'cursor-appearance',
      title: '光标外观',
      meta: PanelMetaRegistry.cursor,
      summary: customizedCount == 0
          ? '系统默认'
          : '$customizedCount/${kCursorStates.length} 已自定义',
      badge: const WipBadge(),
      defaultOpen: true,
      child: Opacity(
        opacity: 0.5,
        child: _CursorGrid(
          cursorStates: draft.cursorStates,
          onUpload: null,
          onRemove: null,
        ),
      ),
    );
  }
}

class _CursorGrid extends StatelessWidget {
  final Map<String, CursorStateEntry> cursorStates;
  final void Function(String stateId, CursorStateEntry entry)? onUpload;
  final void Function(String stateId)? onRemove;

  const _CursorGrid({
    required this.cursorStates,
    required this.onUpload,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final brightness = ShadTheme.of(context).brightness;

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Spacing.sm,
      crossAxisSpacing: Spacing.sm,
      childAspectRatio: 1.0,
      children: kCursorStates.entries.map((e) {
        final entry = cursorStates[e.key];
        return _CursorCell(
          stateId: e.key,
          label: e.value,
          cursorEntry: entry,
          brightness: brightness,
          colorScheme: cs,
          onTap: onUpload != null ? () => _showDetailSheet(context, e.key, e.value, entry) : null,
          onRemove: (entry != null && onRemove != null) ? () => onRemove!(e.key) : null,
        );
      }).toList(),
    );
  }

  void _showDetailSheet(
    BuildContext context,
    String stateId,
    String label,
    CursorStateEntry? existing,
  ) {
    showShadSheet(
      context: context,
      side: ShadSheetSide.right,
      builder: (sheetContext) => _CursorDetailSheet(
        stateId: stateId,
        label: label,
        entry: existing,
        onUpload: (entry) {
          onUpload?.call(stateId, entry);
          Navigator.of(sheetContext).pop();
        },
        onRemove: () {
          onRemove?.call(stateId);
          Navigator.of(sheetContext).pop();
        },
      ),
    );
  }
}

class _CursorCell extends StatelessWidget {
  final String stateId;
  final String label;
  final CursorStateEntry? cursorEntry;
  final Brightness brightness;
  final ShadColorScheme colorScheme;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const _CursorCell({
    required this.stateId,
    required this.label,
    this.cursorEntry,
    required this.brightness,
    required this.colorScheme,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isCustom = cursorEntry != null;
    final bgColor = brightness == Brightness.dark
        ? const Color(0xFF1A2332)
        : const Color(0xFFF0F4FF);

    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(RadiusTokens.lg),
                border: Border.all(
                  color: isCustom
                      ? colorScheme.primary.withValues(alpha: 0.4)
                      : colorScheme.border,
                  width: 1,
                  style: isCustom ? BorderStyle.solid : BorderStyle.none,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: isCustom
                          ? _FileImage(path: cursorEntry!.imagePath)
                          : _SystemCursorIcon(stateId: stateId, brightness: brightness),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.xs),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: FontSizes.micro,
                        color: colorScheme.mutedForeground,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (isCustom && onRemove != null)
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colorScheme.destructive.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.x,
                      size: 10,
                      color: colorScheme.destructiveForeground,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SystemCursorIcon extends StatelessWidget {
  final String stateId;
  final Brightness brightness;

  const _SystemCursorIcon({required this.stateId, required this.brightness});

  @override
  Widget build(BuildContext context) {
    final color = brightness == Brightness.dark
        ? const Color(0xFF64748B)
        : const Color(0xFF94A3B8);
    return Icon(_systemCursorIcon(stateId), size: 24, color: color);
  }
}

/// Loads cursor image from file storage by relative path.
class _FileImage extends StatefulWidget {
  final String path;

  const _FileImage({required this.path});

  @override
  State<_FileImage> createState() => _FileImageState();
}

class _FileImageState extends State<_FileImage> {
  Uint8List? _bytes;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _FileImage old) {
    super.didUpdateWidget(old);
    if (widget.path != old.path) _load();
  }

  Future<void> _load() async {
    if (widget.path.isEmpty) {
      if (mounted) setState(() { _bytes = null; _loaded = true; });
      return;
    }
    final bytes = await CursorStorageService.instance.read(widget.path);
    if (mounted) setState(() { _bytes = bytes; _loaded = true; });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2));
    if (_bytes == null) return Icon(LucideIcons.imageOff, size: 20, color: ShadTheme.of(context).colorScheme.mutedForeground);
    return Padding(
      padding: const EdgeInsets.all(Spacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
        child: Image.memory(_bytes!, fit: BoxFit.contain),
      ),
    );
  }
}

class _CursorDetailSheet extends StatefulWidget {
  final String stateId;
  final String label;
  final CursorStateEntry? entry;
  final void Function(CursorStateEntry entry) onUpload;
  final VoidCallback onRemove;

  const _CursorDetailSheet({
    required this.stateId,
    required this.label,
    this.entry,
    required this.onUpload,
    required this.onRemove,
  });

  @override
  State<_CursorDetailSheet> createState() => _CursorDetailSheetState();
}

class _CursorDetailSheetState extends State<_CursorDetailSheet> {
  int _hotspotX = 0;
  int _hotspotY = 0;
  int _size = 48;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _hotspotX = widget.entry?.hotspotX ?? 0;
    _hotspotY = widget.entry?.hotspotY ?? 0;
    _size = widget.entry?.size ?? 48;
  }

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    final hasEntry = widget.entry != null;

    return ShadSheet(
      title: Text('光标：${widget.label}'),
      description: const Text('上传自定义光标图片替换系统默认外观'),
      constraints: const BoxConstraints(maxWidth: 340),
      actions: [
        if (hasEntry)
          ShadButton.destructive(
            onPressed: widget.onRemove,
            child: const Text('重置为系统默认'),
          ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: cs.muted,
                borderRadius: BorderRadius.circular(RadiusTokens.xl),
                border: Border.all(color: cs.border, width: 1),
              ),
              child: Center(
                child: hasEntry && widget.entry!.imagePath.isNotEmpty
                    ? Stack(
                        children: [
                          _FileImage(path: widget.entry!.imagePath),
                          // Hotspot marker
                          Positioned(
                            left: _hotspotX.toDouble().clamp(0, 128),
                            top: _hotspotY.toDouble().clamp(0, 128),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: cs.destructive,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Icon(
                        _systemCursorIcon(widget.stateId),
                        size: 48,
                        color: cs.mutedForeground,
                      ),
              ),
            ),
            const SizedBox(height: Spacing.md),

            // Upload
            SizedBox(
              width: double.infinity,
              child: ShadButton.outline(
                onPressed: _uploading ? null : _pickFile,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_uploading)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(LucideIcons.upload, size: IconSizes.md),
                    const SizedBox(width: Spacing.sm),
                    Text(hasEntry ? '替换图片' : '上传图片'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),

            // Info
            if (hasEntry) ...[
              _InfoRow(label: '格式', value: _formatLabel(widget.entry!)),
              const SizedBox(height: Spacing.xs),
              _InfoRow(
                  label: '尺寸', value: '${widget.entry!.size} × ${widget.entry!.size}'),
              if (widget.entry!.isAnimated) ...[
                const SizedBox(height: Spacing.xs),
                _InfoRow(label: '帧数', value: '${widget.entry!.frameCount}'),
                const SizedBox(height: Spacing.xs),
                _InfoRow(label: '帧率', value: '${widget.entry!.fps} fps'),
              ],
              const SizedBox(height: Spacing.md),
            ],

            Text(
              '支持 PNG、SVG、JPG、GIF、MP4',
              style:
                  TextStyle(fontSize: FontSizes.micro, color: cs.mutedForeground),
            ),
            Text(
              '静态 ≤2MB / GIF ≤5MB / MP4 ≤10MB / 最大 128×128px',
              style:
                  TextStyle(fontSize: FontSizes.micro, color: cs.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    setState(() => _uploading = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'svg', 'jpg', 'jpeg', 'gif', 'mp4'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final bytes = file.bytes;
      if (bytes == null) return;

      final ext = file.extension?.toLowerCase() ?? '';
      final isAnimated = ext == 'gif' || ext == 'mp4';

      // Size limit
      final sizeLimit = isAnimated
          ? (ext == 'mp4' ? 10 * 1024 * 1024 : 5 * 1024 * 1024)
          : 2 * 1024 * 1024;
      if (bytes.length > sizeLimit) {
        if (mounted) {
          showShadDialog(
            context: context,
            builder: (ctx) => ShadDialog.alert(
              title: const Text('文件过大'),
              description: Text(
                  '动态光标不超过 ${sizeLimit ~/ 1024 ~/ 1024}MB'),
            ),
          );
        }
        return;
      }

      // Save to file storage
      final relativePath = await CursorStorageService.instance
          .save(widget.stateId, ext, bytes);

      final entry = CursorStateEntry(
        imagePath: relativePath,
        imageFormat: ext,
        hotspotX: _hotspotX,
        hotspotY: _hotspotY,
        size: _size,
        isAnimated: isAnimated,
        frameCount: 0,
        fps: isAnimated ? 30 : 0,
      );

      widget.onUpload(entry);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  String _formatLabel(CursorStateEntry entry) {
    if (entry.imageFormat.isEmpty) return '未知';
    final format = entry.imageFormat.toUpperCase();
    return entry.isAnimated ? '$format (动态)' : format;
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = ShadTheme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: TextStyle(
                fontSize: FontSizes.small, color: cs.mutedForeground),
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: FontSizes.small, color: cs.foreground),
        ),
      ],
    );
  }
}

IconData _systemCursorIcon(String stateId) {
  switch (stateId) {
    case 'arrow': return LucideIcons.mousePointer2;
    case 'pointer': return LucideIcons.hand;
    case 'ibeam': return LucideIcons.textCursor;
    case 'crosshair': return LucideIcons.crosshair;
    case 'openHand': return LucideIcons.hand;
    case 'closedHand': return LucideIcons.gripHorizontal;
    case 'resize': return LucideIcons.move;
    case 'forbidden': return LucideIcons.ban;
    default: return LucideIcons.mousePointer2;
  }
}
