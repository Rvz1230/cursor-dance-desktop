import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Handles reading/writing config JSON to disk.
/// Separates file I/O from state management for testability.
class PersistenceRepository {
  Future<String> get _configPath async {
    final dir = await getApplicationSupportDirectory();
    return '${dir.path}/config.json';
  }

  Future<void> save(Map<String, dynamic> data) async {
    final path = await _configPath;
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(data),
    );
  }

  Future<Map<String, dynamic>?> load() async {
    final path = await _configPath;
    final file = File(path);
    if (!await file.exists()) return null;

    final text = await file.readAsString();
    return jsonDecode(text) as Map<String, dynamic>;
  }
}
