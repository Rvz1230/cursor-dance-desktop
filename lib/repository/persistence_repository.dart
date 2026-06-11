import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Atomic-write persistence with schemaVersion, backup, and migration.
///
/// Write flow: temp file → rename (atomic) → sync backup.
/// Read flow: parse → on failure try backup → on failure return null.
class PersistenceRepository {
  static const _schemaVersion = 1;

  Future<String> get _configDir async {
    final dir = await getApplicationSupportDirectory();
    return '${dir.path}/.cursordance';
  }

  Future<String> get _configPath async =>
      '${await _configDir}/config.json';

  Future<String> get _backupPath async =>
      '${await _configDir}/config.backup.json';

  Future<String> get _tempPath async =>
      '${await _configDir}/config.tmp.json';

  Future<void> save(Map<String, dynamic> data) async {
    final dir = await _configDir;
    final dirFile = Directory(dir);
    if (!await dirFile.exists()) {
      await dirFile.create(recursive: true);
    }

    final payload = {
      'schemaVersion': _schemaVersion,
      ...data,
    };

    final json = const JsonEncoder.withIndent('  ').convert(payload);

    // Atomic write: temp → rename
    final tempPath = await _tempPath;
    final tempFile = File(tempPath);
    await tempFile.writeAsString(json);

    final configPath = await _configPath;
    await tempFile.rename(configPath);

    // Sync backup
    final backupPath = await _backupPath;
    await File(configPath).copy(backupPath);
  }

  Future<Map<String, dynamic>?> load() async {
    final configPath = await _configPath;
    final configFile = File(configPath);

    if (!await configFile.exists()) {
      return await _loadBackup();
    }

    try {
      final text = await configFile.readAsString();
      final data = jsonDecode(text) as Map<String, dynamic>;
      return _migrate(data);
    } catch (_) {
      return await _loadBackup();
    }
  }

  Future<Map<String, dynamic>?> _loadBackup() async {
    final backupPath = await _backupPath;
    final backupFile = File(backupPath);

    if (!await backupFile.exists()) return null;

    try {
      final text = await backupFile.readAsString();
      final data = jsonDecode(text) as Map<String, dynamic>;
      return _migrate(data);
    } catch (_) {
      return null;
    }
  }

  /// V0 (no schemaVersion) → V1 migration.
  /// Old configs without schemaVersion are treated as V0.
  Map<String, dynamic> _migrate(Map<String, dynamic> data) {
    final version = data['schemaVersion'] as int? ?? 0;

    if (version < 1) {
      // V0 → V1: add schemaVersion, no structural changes needed.
      // ActionConfig.fromJson already handles missing fields with defaults.
    }

    return data;
  }
}
