import 'package:shared_preferences/shared_preferences.dart';

/// Operator-configurable endpoints. Defaults: local Titan + public CIVINT JSON.
class AppSettings {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  static const _kTitan = 'titan_base_url';
  static const _kCivint = 'civint_base_url';

  String titanBase = 'http://127.0.0.1:8000';
  String civintBase =
      'https://raw.githubusercontent.com/POWDER-RANGER/CivilianIntelligence/main/public/civint';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    titanBase = p.getString(_kTitan) ?? titanBase;
    civintBase = p.getString(_kCivint) ?? civintBase;
  }

  Future<void> save({String? titan, String? civint}) async {
    final p = await SharedPreferences.getInstance();
    if (titan != null) {
      titanBase = titan.trim().replaceAll(RegExp(r'/$'), '');
      await p.setString(_kTitan, titanBase);
    }
    if (civint != null) {
      civintBase = civint.trim().replaceAll(RegExp(r'/$'), '');
      await p.setString(_kCivint, civintBase);
    }
  }
}
