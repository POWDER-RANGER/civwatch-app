import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'civint_api.dart';
import 'titan_api.dart';
import 'watchtower_api.dart';

class AppState extends ChangeNotifier {
  AppState({TitanApi? titan, CivintApi? civint, WatchtowerApi? watchtower})
      : titan = titan ?? TitanApi(),
        civint = civint ?? CivintApi(),
        watchtower = watchtower ?? WatchtowerApi() {
    _connSub = this.titan.connectionState.listen((up) {
      liveConnected = up;
      notifyListeners();
    });
    _liveSub = this.titan.liveEvents.listen(_onLiveEvent);
  }

  final TitanApi titan;
  final CivintApi civint;
  final WatchtowerApi watchtower;
  StreamSubscription? _connSub;
  StreamSubscription? _liveSub;

  TitanHealth? health;
  List<RfSample> samples = [];
  List<Map<String, dynamic>> evidence = [];
  List<CivintAlert> alerts = [];
  List<CivintAward> awards = [];
  List<AlprPoint> alpr = [];
  List<SurveillanceAsset> surveillance = [];
  List<AtlasSurveillanceRecord> atlasSurveillance = [];
  List<Map<String, dynamic>> liveLog = [];
  String titanObservationState = 'unavailable';
  String titanOwnerScope = 'user_device';
  List<String> titanLimitations = [];
  String? error;
  String? civintError;
  bool loading = false;
  bool liveConnected = false;
  WatchtowerHealth? watchtowerHealth;
  int watchtowerFeatures = 0;
  String? watchtowerError;

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
      await Future.wait([refreshTitan(), refreshCivint(), refreshWatchtower()]);
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
      final observations = await titan.observations(n: 50);
      samples = observations.samples;
      titanObservationState = observations.state;
      titanOwnerScope = observations.ownerScope;
      titanLimitations = observations.limitations;
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
      surveillance = await civint.surveillance();
      atlasSurveillance = await civint.atlasSurveillance();
      civintError = null;
    } catch (e) {
      civintError = 'CIVINT feeds: $e';
    }
    notifyListeners();
  }

  Future<void> refreshWatchtower() async {
    try {
      watchtowerHealth = await watchtower.health();
      watchtowerFeatures = await watchtower.featureCount();
      watchtowerError = null;
    } catch (e) {
      watchtowerHealth = null;
      watchtowerFeatures = 0;
      watchtowerError = 'Watchtower unreachable: $e';
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
    watchtower.dispose();
    super.dispose();
  }
}
