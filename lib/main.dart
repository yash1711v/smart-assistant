import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartassistant/app.dart';
import 'package:smartassistant/core/constants/app_constants.dart';
import 'package:smartassistant/core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(AppConstants.hiveThemeBox);
  await Hive.openBox(AppConstants.hiveChatBox);

  await initDependencies();

  runApp(const SmartAssistantApp());
}
