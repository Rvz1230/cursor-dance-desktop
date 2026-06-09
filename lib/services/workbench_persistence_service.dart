import 'dart:convert';
import 'dart:io';

class WorkbenchPersistenceService {
  String get configPath {
    final home = Platform.environment['HOME'] ?? '.';
    return '$home/.cursordance/config.json';
  }

  Future<void> save(Map<String, dynamic> data) async {
    final file = File(configPath);
    await file.parent.create(recursive: true);
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(data),
    );
  }

  Future<Map<String, dynamic>?> load() async {
    final file = File(configPath);
    if (!await file.exists()) return null;

    final text = await file.readAsString();
    return jsonDecode(text) as Map<String, dynamic>;
  }
}
