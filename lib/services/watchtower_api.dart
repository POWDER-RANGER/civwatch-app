import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/settings.dart';
import '../models/models.dart';

/// Client for the Watchtower civic-oversight service.
class WatchtowerApi {
  WatchtowerApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _u(String path) => Uri.parse('${AppSettings.instance.watchtowerBase}$path');

  Future<WatchtowerHealth> health() async {
    final r = await _client
        .get(_u('/api/health'), headers: AppSettings.instance.authHeaders())
        .timeout(const Duration(seconds: 5));
    if (r.statusCode != 200) throw Exception('health ${r.statusCode}');
    return WatchtowerHealth.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }

  Future<int> featureCount() async {
    final r = await _client
        .get(_u('/api/features'), headers: AppSettings.instance.authHeaders())
        .timeout(const Duration(seconds: 8));
    if (r.statusCode != 200) throw Exception('features ${r.statusCode}');
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    return (body['count'] as num?)?.toInt() ??
        ((body['features'] as List?)?.length ?? 0);
  }

  void dispose() => _client.close();
}
