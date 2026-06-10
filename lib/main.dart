import 'package:flutter/material.dart';

import 'app/app.dart';
import 'services/preset_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PresetRepository.instance.load();
  runApp(const CursorDanceApp());
}
