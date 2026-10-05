import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/settings.dart';
import '../models/models.dart';

/// Loads dashboard-ready JSON published by the CIVINT ingest pipeline.
class CivintApi {
  CivintApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _u(String file) => Uri.parse('${AppSettings.instance.civintBase}/$file');

  Future<List<CivintAlert>> alerts() async {
    final r = await _client.get(_u('alerts.json')).timeout(const Duration(seconds: 12));
    if (r.statusCode != 200) return [];
    final data = jsonDecode(r.body);
    final list = data is List ? data : (data is Map ? (data['alerts'] as List? ?? []) : []);
    return list.map((e) => CivintAlert.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<CivintAward>> awards() async {
    final r = await _client.get(_u('awards.json')).timeout(const Duration(seconds: 12));
    if (r.statusCode != 200) return [];
    final data = jsonDecode(r.body);
    final list = data is List ? data : (data is Map ? (data['awards'] as List? ?? []) : []);
    return list.map((e) => CivintAward.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<AlprPoint>> alpr() async {
    final r = await _client.get(_u('alpr_overpass.json')).timeout(const Duration(seconds: 15));
    if (r.statusCode != 200) return [];
    final data = jsonDecode(r.body);
    List raw = [];
    if (data is Map && data['elements'] is List) {
      raw = data['elements'] as List;
    } else if (data is List) {
      raw = data;
    }
    return raw
        .whereType<Map>()
        .map((e) => AlprPoint.fromJson(Map<String, dynamic>.from(e)))
        .where((p) => p.lat != 0 || p.lon != 0)
        .toList();
  }

  Future<List<SurveillanceAsset>> surveillance() async {
    final r = await _client.get(_u('surveillance.json')).timeout(const Duration(seconds: 15));
    if (r.statusCode != 200) return [];
    final data = jsonDecode(r.body);
    final raw = data is Map && data['elements'] is List ? data['elements'] as List : const [];
    return raw
        .whereType<Map>()
        .map((e) => SurveillanceAsset.fromJson(Map<String, dynamic>.from(e)))
        .where((p) => p.lat != 0 || p.lon != 0)
        .toList();
  }

  void dispose() => _client.close();
}
