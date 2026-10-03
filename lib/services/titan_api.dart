import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../core/settings.dart';
import '../models/models.dart';

class TitanApi {
  TitanApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  WebSocketChannel? _ws;
  final _liveController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get liveEvents => _liveController.stream;

  Uri _u(String path) => Uri.parse('${AppSettings.instance.titanBase}$path');

  Future<TitanHealth> health() async {
    final r = await _client.get(_u('/api/health')).timeout(const Duration(seconds: 8));
    if (r.statusCode != 200) throw Exception('health ${r.statusCode}');
    return TitanHealth.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }

  Future<List<RfSample>> recent({int n = 40, String? domain}) async {
    final q = {'n': '$n'};
    if (domain != null) q['domain'] = domain;
    final r = await _client.get(_u('/api/telemetry/recent').replace(queryParameters: q));
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    final list = (body['samples'] as List?) ?? [];
    return list.map((e) => RfSample.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> emitDemo({int count = 4}) async {
    final r = await _client
        .post(_u('/api/telemetry/demo').replace(queryParameters: {'count': '$count'}));
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> verifyEvidence() async {
    final r = await _client.get(_u('/api/evidence/verify'));
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> evidenceTail({int n = 12}) async {
    final r = await _client.get(_u('/api/evidence/tail').replace(queryParameters: {'n': '$n'}));
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    return ((body['records'] as List?) ?? []).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> sensors() async {
    final r = await _client.get(_u('/api/sensors'));
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    return ((body['sensors'] as List?) ?? []).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> discoverAdb() async {
    final r = await _client.post(_u('/api/sensors/discover'));
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  void connectLive() {
    disconnectLive();
    final base = AppSettings.instance.titanBase;
    final ws = base.startsWith('https')
        ? base.replaceFirst('https', 'wss')
        : base.replaceFirst('http', 'ws');
    _ws = WebSocketChannel.connect(Uri.parse('$ws/ws/live'));
    _ws!.stream.listen(
      (msg) {
        try {
          _liveController.add(jsonDecode('$msg') as Map<String, dynamic>);
        } catch (_) {}
      },
      onError: (_) {},
      onDone: () {},
      cancelOnError: false,
    );
  }

  void disconnectLive() {
    _ws?.sink.close();
    _ws = null;
  }

  void dispose() {
    disconnectLive();
    _liveController.close();
    _client.close();
  }
}
