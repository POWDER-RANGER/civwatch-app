import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = context.watch<AppState>().alerts;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(backgroundColor: const Color(0xFF0D1117), title: const Text('NWS Alerts')),
      body: alerts.isEmpty
          ? const Center(child: Text('No alerts loaded', style: TextStyle(color: Color(0xFF8B949E))))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: alerts.length,
              separatorBuilder: (_, __) => const Divider(color: Color(0xFF30363D)),
              itemBuilder: (_, i) {
                final a = alerts[i];
                return ListTile(
                  title: Text(a.event, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${a.severity} · ${a.area}\n${a.headline}',
                      style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12)),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}
