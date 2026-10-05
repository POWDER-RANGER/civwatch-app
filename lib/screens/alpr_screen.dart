import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';

class AlprScreen extends StatelessWidget {
  const AlprScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final pts = state.surveillance;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(backgroundColor: const Color(0xFF0D1117), title: const Text('ALPR / Surveillance')),
      body: pts.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No mapped surveillance observations loaded.\\nRun CIVINT OSM ingest and publish surveillance.json, or set the CIVINT base URL in Settings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF8B949E)),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (state.atlasSurveillance.isNotEmpty)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: Text('${state.atlasSurveillance.length} public surveillance records'),
                      subtitle: const Text('Atlas of Surveillance · jurisdiction/evidence layer'),
                    ),
                  ),
                ...pts.map((p) => ListTile(
                  leading: Icon(
                    p.category == 'gunshot_detector' ? Icons.graphic_eq : Icons.camera_alt_outlined,
                    color: const Color(0xFFA371F7),
                  ),
                  title: Text(p.label),
                  subtitle: Text(
                    '${p.category.replaceAll('_', ' ')} · ${p.lat.toStringAsFixed(5)}, ${p.lon.toStringAsFixed(5)}'
                    '${p.operator != null ? " · ${p.operator}" : ""}'
                    '${p.manufacturer != null ? " · ${p.manufacturer}" : ""}'
                    '${p.direction != null ? " · dir ${p.direction}" : ""}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF8B949E)),
                  ),
                )),
              ],

    );
  }
}
