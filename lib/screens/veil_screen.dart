import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';

class VeilScreen extends StatelessWidget {
  const VeilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final h = s.health;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(backgroundColor: const Color(0xFF0D1117), title: const Text('Veil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _row('Titan status', h?.status ?? 'offline'),
          _row('Evidence chain', h == null ? '—' : (h.evidenceOk ? 'intact' : 'BROKEN')),
          _row('Buffered RF samples', '${h?.buffered ?? 0}'),
          _row('NWS alerts', '${s.alerts.length}'),
          _row('Federal awards', '${s.awards.length}'),
          _row('ALPR points', '${s.alpr.length}'),
          _row('Live listeners (Titan)', '${h?.listeners ?? 0}'),
          const SizedBox(height: 16),
          const Text(
            'Veil is the pulse board: connectivity, integrity, and desk counts.',
            style: TextStyle(color: Color(0xFF8B949E), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: const TextStyle(color: Color(0xFF8B949E))),
            Text(v, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF00E5FF))),
          ],
        ),
      );
}
