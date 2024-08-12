// app_config.dart
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._internal();

  String? host;
  String? port;

  // Optional: You can initialize them with default values
  void setConfig({required String host, required String port}) {
    this.host = host;
    this.port = port;
  }
}
