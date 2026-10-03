import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'civint_api.dart';
import 'titan_api.dart';

class AppState extends ChangeNotifier {
  AppState({TitanApi? titan, CivintApi? civint})
      : titan = titan ?? TitanApi(),
        civint = civint ?? CivintApi() {
    _connSub = this.titan.connectionState.listen((up) {
      liveConnected = up;
      notifyListeners();
    });
    _liveSub = this.titan.liveEvents.listen(_onLiveEvent);
  }

  final TitanApi titan;
  final CivintApi civint;
  StreamSubscription? _connSub;
  StreamSubscription? _liveSub;

  TitanHealth? health;
  List<RfSample> samples = [];
  List<Map<String, dynamic>> evidence = [];
  List<CivintAlert> alerts = [];
  List<CivintAward> awards = [];
  List<AlprPoint> alpr = [];
  List<Map<String, dynamic>> liveLog = [];
  String? error;
  String? civintError;
  bool loading = false;
  bool liveConnected = false;

  void _onLiveEvent(Map<String, dynamic> ev) {
    liveLog.insert(0, ev);
    if (liveLog.length > 40) liveLog = liveLog.sublist(0, 40);
    if (ev['type'] == 'telemetry') {
      final s = ev['sample'];
      if (s is Map<String, dynamic>) {
        samples.insert(0, RfSample.fromJson(s));
        if (samples.length > 80) samples = samples.sublist(0, 80);
      }
    }
    notifyListeners();
  }

  Future<void> bootstrap() async {
    loading = true;
    error = null;
    civintError = null;
    notifyListeners();
    try {
      await Future.wait([refreshTitan(), refreshCivint()]);
      titan.connectLive();
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
      civintError = null;
    } catch (e) {
      civintError = 'CIVINT feeds: $e';
    }
    notifyListeners();
  }

  Future<void> emitDemo() async {
    await titan.emitDemo(count: 4);
    await refreshTitan();
  }

  Future<Map<String, dynamic>> verify() => titan.verifyEvidence();

  @override
  void dispose() {
    _connSub?.cancel();
    _liveSub?.cancel();
    titan.dispose();
    civint.dispose();
    super.dispose();
  }
}
