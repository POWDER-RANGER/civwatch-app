/// Shared domain models for CIVWATCH client.

class TitanHealth {
  TitanHealth({
    required this.status,
    required this.version,
    required this.sensorId,
    required this.evidenceOk,
    required this.evidenceLength,
    required this.buffered,
    required this.listeners,
  });

  final String status;
  final String version;
  final String sensorId;
  final bool evidenceOk;
  final int evidenceLength;
  final int buffered;
  final int listeners;

  factory TitanHealth.fromJson(Map<String, dynamic> j) {
    final ev = (j['evidence'] as Map?) ?? {};
    final buf = (j['buffer'] as Map?) ?? {};
    return TitanHealth(
      status: '${j['status'] ?? 'unknown'}',
      version: '${j['version'] ?? ''}',
      sensorId: '${j['sensor_id'] ?? ''}',
      evidenceOk: ev['ok'] == true,
      evidenceLength: (ev['length'] as num?)?.toInt() ?? 0,
      buffered: (buf['buffered'] as num?)?.toInt() ?? 0,
      listeners: (j['listeners'] as num?)?.toInt() ?? 0,
    );
  }
}

class RfSample {
  RfSample({
    required this.domain,
    required this.sensorId,
    required this.ts,
    required this.metrics,
  });

  final String domain;
  final String sensorId;
  final String ts;
  final Map<String, dynamic> metrics;

  factory RfSample.fromJson(Map<String, dynamic> j) => RfSample(
        domain: '${j['domain'] ?? ''}',
        sensorId: '${j['sensor_id'] ?? ''}',
        ts: '${j['ts'] ?? ''}',
        metrics: Map<String, dynamic>.from(j['metrics'] as Map? ?? {}),
      );

  bool get isDemo => metrics['demo'] == true;
}

class CivintAlert {
  CivintAlert({
    required this.id,
    required this.event,
    required this.severity,
    required this.area,
    required this.headline,
  });

  final String id;
  final String event;
  final String severity;
  final String area;
  final String headline;

  factory CivintAlert.fromJson(Map<String, dynamic> j) => CivintAlert(
        id: '${j['id'] ?? j['alert_id'] ?? ''}',
        event: '${j['event'] ?? j['event_type'] ?? 'Alert'}',
        severity: '${j['severity'] ?? 'Unknown'}',
        area: '${j['area'] ?? j['areaDesc'] ?? ''}',
        headline: '${j['headline'] ?? j['description'] ?? ''}',
      );
}

class CivintAward {
  CivintAward({
    required this.id,
    required this.recipient,
    required this.amount,
    required this.agency,
    required this.description,
    this.terms = const [],
  });

  final String id;
  final String recipient;
  final double amount;
  final String agency;
  final String description;
  final List<String> terms;

  factory CivintAward.fromJson(Map<String, dynamic> j) => CivintAward(
        id: '${j['internal_id'] ?? j['Award ID'] ?? j['id'] ?? ''}',
        recipient: '${j['Recipient Name'] ?? j['recipient'] ?? 'Unknown'}',
        amount: _num(j['Award Amount'] ?? j['amount']),
        agency: '${j['Awarding Agency'] ?? j['agency'] ?? ''}',
        description: '${j['Description'] ?? j['description'] ?? ''}',
        terms: (j['terms'] as List?)?.map((e) => '$e').toList() ?? const [],
      );

  static double _num(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }
}

class AlprPoint {
  AlprPoint({required this.lat, required this.lon, this.operator, this.direction});

  final double lat;
  final double lon;
  final String? operator;
  final String? direction;

  factory AlprPoint.fromJson(Map<String, dynamic> j) {
    final tags = (j['tags'] as Map?) ?? j;
    return AlprPoint(
      lat: (j['lat'] as num?)?.toDouble() ?? 0,
      lon: (j['lon'] as num?)?.toDouble() ?? 0,
      operator: tags['operator']?.toString() ?? tags['name']?.toString(),
      direction: tags['camera:direction']?.toString(),
    );
  }
}

class SurveillanceAsset {
  SurveillanceAsset({
    required this.id,
    required this.category,
    required this.lat,
    required this.lon,
    this.name,
    this.operator,
    this.manufacturer,
    this.direction,
    this.zone,
    this.confidence,
    this.observedAt,
    this.sourceUrl,
  });

  final int id;
  final String category;
  final double lat;
  final double lon;
  final String? name;
  final String? operator;
  final String? manufacturer;
  final String? direction;
  final String? zone;
  final double? confidence;
  final String? observedAt;
  final String? sourceUrl;

  factory SurveillanceAsset.fromJson(Map<String, dynamic> j) {
    final p = (j['provenance'] as Map?) ?? {};
    return SurveillanceAsset(
      id: (j['id'] as num?)?.toInt() ?? 0,
      category: '${j['category'] ?? j['surveillance_type'] ?? 'other'}',
      lat: (j['lat'] as num?)?.toDouble() ?? 0,
      lon: (j['lon'] as num?)?.toDouble() ?? 0,
      name: j['name']?.toString(),
      operator: j['operator']?.toString(),
      manufacturer: j['manufacturer']?.toString(),
      direction: j['direction']?.toString(),
      zone: j['zone']?.toString(),
      confidence: (j['confidence'] as num?)?.toDouble(),
      observedAt: p['observed_at']?.toString(),
      sourceUrl: p['source_url']?.toString(),
    );
  }

  String get label => name ?? operator ?? category.replaceAll('_', ' ');
}

class WatchtowerHealth {
  WatchtowerHealth({
    required this.status,
    required this.db,
    required this.version,
  });

  final String status;
  final String db;
  final String version;

  factory WatchtowerHealth.fromJson(Map<String, dynamic> j) => WatchtowerHealth(
        status: '${j['status'] ?? 'unknown'}',
        db: '${j['db'] ?? 'unknown'}',
        version: '${j['version'] ?? ''}',
      );
}
