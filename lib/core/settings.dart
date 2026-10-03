import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Operator-configurable endpoints + Titan bearer token.
///
/// URLs live in SharedPreferences. The API token uses
/// [FlutterSecureStorage] (Keychain / Keystore / libsecret).
class AppSettings {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  static const _kTitan = 'titan_base_url';
  static const _kCivint = 'civint_base_url';
  static const _kToken = 'titan_api_token';

  final _secure = const FlutterSecureStorage();

  /// Prefer loopback. Physical-phone LAN is unsupported without TLS + token.
  String titanBase = 'http://127.0.0.1:8000';
  String civintBase =
      'https://raw.githubusercontent.com/POWDER-RANGER/CivilianIntelligence/main/public/civint';
  String apiToken = '';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    titanBase = p.getString(_kTitan) ?? titanBase;
    civintBase = p.getString(_kCivint) ?? civintBase;
    apiToken = await _secure.read(key: _kToken) ?? '';
  }

  Future<void> save({String? titan, String? civint, String? token}) async {
    final p = await SharedPreferences.getInstance();
    if (titan != null) {
      titanBase = titan.trim().replaceAll(RegExp(r'/$'), '');
      await p.setString(_kTitan, titanBase);
    }
    if (civint != null) {
      civintBase = civint.trim().replaceAll(RegExp(r'/$'), '');
      await p.setString(_kCivint, civintBase);
    }
    if (token != null) {
      apiToken = token.trim();
      if (apiToken.isEmpty) {
        await _secure.delete(key: _kToken);
      } else {
        await _secure.write(key: _kToken, value: apiToken);
      }
    }
  }

  Map<String, String> authHeaders() {
    if (apiToken.isEmpty) return {};
    return {'Authorization': 'Bearer $apiToken'};
  }
}
