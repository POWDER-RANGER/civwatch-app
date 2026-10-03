import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';

class AlprScreen extends StatelessWidget {
  const AlprScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pts = context.watch<AppState>().alpr;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(backgroundColor: const Color(0xFF0D1117), title: const Text('ALPR / Surveillance')),
      body: pts.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No ALPR points loaded.\nRun CIVINT OSM ingest and publish alpr_overpass.json, or set CIVINT base URL in Settings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF8B949E)),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: pts.length,
              itemBuilder: (_, i) {
                final p = pts[i];
                return ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFFA371F7)),
                  title: Text(p.operator ?? 'ALPR node'),
                  subtitle: Text(
                    '${p.lat.toStringAsFixed(5)}, ${p.lon.toStringAsFixed(5)}'
                    '${p.direction != null ? " · dir ${p.direction}" : ""}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF8B949E)),
                  ),
                );
              },
            ),
    );
  }
}
