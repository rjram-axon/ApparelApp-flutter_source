import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._internal();

  String? company;
  String? host;
  String? port;

  final _storage = const FlutterSecureStorage(); // For sensitive data
  final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance(); // For general config

  Future<void> setConfig(
      {required String company,
      required String host,
      required String port}) async {
    this.company = company;
    this.host = host;
    this.port = port;

    final prefs = await _prefs;
    List<String> configs = prefs.getStringList('configs') ?? [];

    // Create a new config map and encode it as a JSON string
    Map<String, String> newConfig = {
      'company': company,
      'host': host,
      'port': port,
    };

    // Remove any existing config for the same company
    configs.removeWhere((config) {
      Map<String, String> configMap =
          Map<String, String>.from(jsonDecode(config));
      return configMap['company'] == company;
    });

    // Add the new config to the list and save it
    configs.add(jsonEncode(newConfig));
    await prefs.setStringList('configs', configs);
  }

  Future<List<Map<String, String>>> loadAllConfigs() async {
    final prefs = await _prefs;
    List<String> configs = prefs.getStringList('configs') ?? [];
    return configs.map((config) {
      return Map<String, String>.from(jsonDecode(config));
    }).toList();
  }

  Future<void> loadConfig(String company) async {
    final allConfigs = await loadAllConfigs();
    for (var config in allConfigs) {
      if (config['company'] == company) {
        this.company = config['company'];
        this.host = config['host'];
        this.port = config['port'];
        break;
      }
    }
  }

  Future<void> saveCredentials(String username, String password) async {
    await _storage.write(key: 'username', value: username);
    await _storage.write(key: 'password', value: password);
  }

  Future<Map<String, String?>> loadCredentials() async {
    final username = await _storage.read(key: 'username');
    final password = await _storage.read(key: 'password');
    return {
      'username': username,
      'password': password,
    };
  }

  Future<void> clearConfigs() async {
    final prefs = await _prefs;
    await prefs.remove('configs');
  }
}
