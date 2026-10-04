import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Operator-configurable service endpoints + Titan bearer token.
///
/// Service URLs live in SharedPreferences. The API token uses
/// FlutterSecureStorage (Keychain / Keystore / libsecret).
class AppSettings {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  static const _kTitan = 'titan_base_url';
  static const _kCivint = 'civint_base_url';
  static const _kWatchtower = 'watchtower_base_url';
  static const _kToken = 'titan_api_token';

  final _secure = const FlutterSecureStorage();

  /// Prefer loopback. Physical-phone LAN HTTP is unsupported.
  String titanBase = 'http://127.0.0.1:8000';
  String civintBase =
      'https://raw.githubusercontent.com/POWDER-RANGER/CivilianIntelligence/main/public/civint';
  String watchtowerBase = 'http://127.0.0.1:3000';
  String apiToken = '';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    titanBase = p.getString(_kTitan) ?? titanBase;
    civintBase = p.getString(_kCivint) ?? civintBase;
    watchtowerBase = p.getString(_kWatchtower) ?? watchtowerBase;
    apiToken = await _secure.read(key: _kToken) ?? '';
  }

  Future<void> save({
    String? titan,
    String? civint,
    String? watchtower,
    String? token,
  }) async {
    final p = await SharedPreferences.getInstance();

    if (titan != null) {
      final value = titan.trim().replaceAll(RegExp(r'/$'), '');
      _validateServiceUrl(value, label: 'Titan');
      titanBase = value;
      await p.setString(_kTitan, titanBase);
    }

    if (civint != null) {
      final value = civint.trim().replaceAll(RegExp(r'/$'), '');
      _validateServiceUrl(value, label: 'CIVINT');
      civintBase = value;
      await p.setString(_kCivint, civintBase);
    }

    if (watchtower != null) {
      final value = watchtower.trim().replaceAll(RegExp(r'/$'), '');
      _validateServiceUrl(value, label: 'Watchtower');
      watchtowerBase = value;
      await p.setString(_kWatchtower, watchtowerBase);
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

  static void _validateServiceUrl(String value, {required String label}) {
    final uri = Uri.tryParse(value);
    final host = uri?.host.toLowerCase();
    final loopback = host == 'localhost' ||
        host == '127.0.0.1' ||
        host == '::1' ||
        host == '10.0.2.2';
    final https = uri?.scheme == 'https';
    final httpLocal = uri?.scheme == 'http' && loopback;

    if (uri == null || host == null || (!https && !httpLocal)) {
      throw ArgumentError(
        '$label endpoint must use HTTPS, or HTTP on localhost/emulator only',
      );
    }
  }

  Map<String, String> authHeaders() {
    if (apiToken.isEmpty) return {};
    return {'Authorization': 'Bearer $apiToken'};
  }
}
