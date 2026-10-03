import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';

class AwardsScreen extends StatelessWidget {
  const AwardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final awards = context.watch<AppState>().awards;
    final fmt = NumberFormat.compactCurrency(symbol: '\$');
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(backgroundColor: const Color(0xFF0D1117), title: const Text('Federal Awards')),
      body: awards.isEmpty
          ? const Center(child: Text('No awards loaded', style: TextStyle(color: Color(0xFF8B949E))))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: awards.length,
              separatorBuilder: (_, __) => const Divider(color: Color(0xFF30363D)),
              itemBuilder: (_, i) {
                final a = awards[i];
                return ListTile(
                  title: Text(a.recipient, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${a.agency}\n${a.description}',
                      style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12)),
                  trailing: Text(fmt.format(a.amount), style: const TextStyle(color: Color(0xFF3FB950))),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}
