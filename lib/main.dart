import 'package:flutter/material.dart';

import 'services/preset_loader.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PresetRepository.instance.load();
  runApp(const CursorDanceApp());
}
