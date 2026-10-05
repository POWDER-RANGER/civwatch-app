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
  StreamSubscription? _wsSub;
  Timer? _reconnectTimer;
  int _backoffSec = 1;
  bool _wantLive = false;

  final _liveController = StreamController<Map<String, dynamic>>.broadcast();
  final _connController = StreamController<bool>.broadcast();

  Stream<Map<String, dynamic>> get liveEvents => _liveController.stream;
  Stream<bool> get connectionState => _connController.stream;

  Uri _u(String path) => Uri.parse('${AppSettings.instance.titanBase}$path');

  Future<http.Response> _get(String path) =>
      _client.get(_u(path), headers: AppSettings.instance.authHeaders()).timeout(const Duration(seconds: 10));

  Future<http.Response> _post(String path, {Map<String, String>? query}) {
    final uri = _u(path).replace(queryParameters: query);
    return _client
        .post(uri, headers: AppSettings.instance.authHeaders())
        .timeout(const Duration(seconds: 12));
  }

  Future<TitanHealth> health() async {
    final r = await _get('/api/health');
    if (r.statusCode != 200) throw Exception('health ${r.statusCode}');
    return TitanHealth.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }

  Future<List<RfSample>> recent({int n = 40, String? domain}) async {
    final q = {'n': '$n'};
    if (domain != null) q['domain'] = domain;
    final r = await _client
        .get(_u('/api/telemetry/recent').replace(queryParameters: q), headers: AppSettings.instance.authHeaders())
        .timeout(const Duration(seconds: 10));
    if (r.statusCode != 200) throw Exception('recent ${r.statusCode}');
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    final list = (body['samples'] as List?) ?? [];
    return list.map((e) => RfSample.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<TitanObservations> observations({int n = 100, String? domain}) async {
    final q = <String, String>{'n': '$n'};
    if (domain != null) q['domain'] = domain;
    final r = await _get('/api/observations?' + Uri(queryParameters: q).query);
    if (r.statusCode != 200) throw Exception('observations ${r.statusCode}');
    return TitanObservations.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> verifyEvidence() async {
    final r = await _get('/api/evidence/verify');
    if (r.statusCode != 200) throw Exception('verify ${r.statusCode}');
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> evidenceTail({int n = 12}) async {
    final r = await _client
        .get(_u('/api/evidence/tail').replace(queryParameters: {'n': '$n'}),
            headers: AppSettings.instance.authHeaders())
        .timeout(const Duration(seconds: 10));
    if (r.statusCode != 200) throw Exception('tail ${r.statusCode}');
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    return ((body['records'] as List?) ?? []).cast<Map<String, dynamic>>();
  }

  void connectLive() {
    _wantLive = true;
    _openWs();
  }

  void _openWs() {
    _reconnectTimer?.cancel();
    _wsSub?.cancel();
    _wsSub = null;
    try {
      _ws?.sink.close();
    } catch (_) {}
    _ws = null;

    final base = AppSettings.instance.titanBase;
    final wsScheme = base.startsWith('https')
        ? base.replaceFirst('https', 'wss')
        : base.replaceFirst('http', 'ws');
    final uri = Uri.parse('$wsScheme/ws/live');
    try {
      _ws = WebSocketChannel.connect(uri);
      final token = AppSettings.instance.apiToken;
      if (token.isNotEmpty) {
        _ws!.sink.add(jsonEncode({'type': 'auth', 'token': token}));
      }
      _wsSub = _ws!.stream.listen(
        (msg) {
          _backoffSec = 1;
          try {
            final data = jsonDecode('$msg') as Map<String, dynamic>;
            if (data['type'] == 'hello') {
              _connController.add(true);
            }
            _liveController.add(data);
          } catch (_) {}
        },
        onError: (_) => _scheduleReconnect(),
        onDone: () => _scheduleReconnect(),
        cancelOnError: false,
      );
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _connController.add(false);
    if (!_wantLive) return;
    _reconnectTimer?.cancel();
    final wait = _backoffSec;
    _backoffSec = (_backoffSec * 2).clamp(1, 30);
    _reconnectTimer = Timer(Duration(seconds: wait), () {
      if (_wantLive) _openWs();
    });
  }

  void disconnectLive({bool reconnect = false}) {
    if (!reconnect) {
      _wantLive = false;
    }
    _reconnectTimer?.cancel();
    _wsSub?.cancel();
    _wsSub = null;
    try {
      _ws?.sink.close();
    } catch (_) {}
    _ws = null;
    _connController.add(false);
  }

  void dispose() {
    disconnectLive(reconnect: false);
    _liveController.close();
    _connController.close();
    _client.close();
  }
}
