import 'package:flutter/material.dart';
import 'package:e_laundry/core/config/app_config.dart';
import 'package:e_laundry/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await AppConfig.load('configs/production/app_configs.json');
  await setupApp(config);
}
