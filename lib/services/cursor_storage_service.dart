import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Manages cursor image files under ~/.cursordance/cursors/.
class CursorStorageService {
  CursorStorageService._();

  static final CursorStorageService instance = CursorStorageService._();

  Directory? _cache;

  Future<Directory> _dir() async {
    if (_cache != null) return _cache!;
    final appDir = await getApplicationSupportDirectory();
    final dir = Directory('${appDir.path}/.cursordance/cursors');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    _cache = dir;
    return dir;
  }

  /// Save bytes to a cursor file, returns the relative path.
  Future<String> save(String stateId, String ext, Uint8List bytes) async {
    final dir = await _dir();
    // Remove old files for this stateId
    for (final f in dir.listSync()) {
      final name = f.path.split('/').last;
      if (name.startsWith('$stateId.')) {
        f.deleteSync();
      }
    }
    final fileName = '$stateId.$ext';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return fileName;
  }

  /// Get the full path for a relative image path.
  Future<String> fullPath(String relativePath) async {
    final dir = await _dir();
    return '${dir.path}/$relativePath';
  }

  /// Read bytes for a relative image path.
  Future<Uint8List?> read(String relativePath) async {
    final dir = await _dir();
    final file = File('${dir.path}/$relativePath');
    if (!file.existsSync()) return null;
    return file.readAsBytes();
  }

  /// Delete a cursor file.
  Future<void> delete(String relativePath) async {
    if (relativePath.isEmpty) return;
    final dir = await _dir();
    final file = File('${dir.path}/$relativePath');
    if (file.existsSync()) file.deleteSync();
  }

  /// Delete all cursor files for a stateId.
  Future<void> deleteForState(String stateId) async {
    final dir = await _dir();
    for (final f in dir.listSync()) {
      final name = f.path.split('/').last;
      if (name.startsWith('$stateId.')) {
        f.deleteSync();
      }
    }
  }
}
