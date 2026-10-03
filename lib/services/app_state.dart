import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'civint_api.dart';
import 'titan_api.dart';

class AppState extends ChangeNotifier {
  AppState({TitanApi? titan, CivintApi? civint})
      : titan = titan ?? TitanApi(),
        civint = civint ?? CivintApi();

  final TitanApi titan;
  final CivintApi civint;

  TitanHealth? health;
  List<RfSample> samples = [];
  List<Map<String, dynamic>> evidence = [];
  List<CivintAlert> alerts = [];
  List<CivintAward> awards = [];
  List<AlprPoint> alpr = [];
  List<Map<String, dynamic>> liveLog = [];
  String? error;
  bool loading = false;
  bool liveConnected = false;

  Future<void> bootstrap() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await Future.wait([refreshTitan(), refreshCivint()]);
      connectLive();
    } catch (e) {
      error = '$e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshTitan() async {
    try {
      health = await titan.health();
      samples = await titan.recent(n: 50);
      evidence = await titan.evidenceTail(n: 15);
      error = null;
    } catch (e) {
      health = null;
      error = 'Titan unreachable: $e';
    }
    notifyListeners();
  }

  Future<void> refreshCivint() async {
    try {
      alerts = await civint.alerts();
      awards = await civint.awards();
      alpr = await civint.alpr();
    } catch (_) {}
    notifyListeners();
  }

  void connectLive() {
    titan.disconnectLive();
    titan.connectLive();
    liveConnected = true;
    titan.liveEvents.listen((ev) {
      liveLog.insert(0, ev);
      if (liveLog.length > 80) liveLog = liveLog.sublist(0, 80);
      if (ev['type'] == 'telemetry') {
        final s = ev['sample'];
        if (s is Map<String, dynamic>) {
          samples.insert(0, RfSample.fromJson(s));
          if (samples.length > 80) samples = samples.sublist(0, 80);
        }
      }
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> emitDemo() async {
    await titan.emitDemo(count: 4);
    await refreshTitan();
  }

  Future<Map<String, dynamic>> verify() => titan.verifyEvidence();

  @override
  void dispose() {
    titan.dispose();
    civint.dispose();
    super.dispose();
  }
}
