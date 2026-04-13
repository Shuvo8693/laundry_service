import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class AppConfig {
  final String baseUrl;
  final String env;
  final bool isLoggerEnabled;
  final ConnectivityResult connectivityResult;

  AppConfig({
    required this.baseUrl,
    required this.env,
    this.isLoggerEnabled = true,
    this.connectivityResult = ConnectivityResult.wifi,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      baseUrl: json['baseUrl'] as String,
      env: json['env'] as String,
      isLoggerEnabled: json['isLoggerEnabled'] ?? true,
    );
  }

  static Future<AppConfig> load(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final jsonMap = json.decode(jsonString);
    return AppConfig.fromJson(jsonMap);
  }
}
