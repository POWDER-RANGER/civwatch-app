import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';

class TitanScreen extends StatelessWidget {
  const TitanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final h = state.health;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        title: const Text('Cell Titan'),
        actions: [
          TextButton(
            onPressed: () async {
              await state.emitDemo();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Demo samples sealed into evidence chain')),
                );
              }
            },
            child: const Text('Demo'),
          ),
          TextButton(
            onPressed: () async {
              final v = await state.verify();
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Evidence verify'),
                    content: Text('$v'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                    ],
                  ),
                );
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            h == null
                ? 'Titan offline — start local server or set URL in Settings'
                : 'v${h.version} · ${h.sensorId} · evidence ${h.evidenceOk ? "intact" : "BROKEN"} (${h.evidenceLength})',
            style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text('observations: ${state.titanObservationState}')),
              Chip(label: Text('scope: ${state.titanOwnerScope}')),
            ],
          ),
          if (state.titanLimitations.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                state.titanLimitations.first,
                style: const TextStyle(color: Color(0xFF8B949E), fontSize: 11),
              ),
            ),
          const SizedBox(height: 12),
          const Text('Live stream', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Container(
            height: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF30363D)),
            ),
            child: ListView(
              children: state.liveLog
                  .take(20)
                  .map((e) => Text(
                        '${e['type'] ?? 'evt'} ${e['evidence_seq'] ?? ''} ${e['sample']?['domain'] ?? ''}',
                        style: const TextStyle(
                            fontFamily: 'monospace', fontSize: 11, color: Color(0xFF8B949E)),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Recent RF samples', style: TextStyle(fontWeight: FontWeight.w600)),
          ...state.samples.take(30).map((s) {
            final demo = s.isDemo ? ' · demo' : '';
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text('${s.domain}$demo', style: const TextStyle(fontSize: 14)),
              subtitle: Text('${s.ts} · ${s.metrics}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF8B949E))),
            );
          }),
          const SizedBox(height: 12),
          const Text('Evidence tail', style: TextStyle(fontWeight: FontWeight.w600)),
          ...state.evidence.map((r) {
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text('#${r['seq']} ${r['kind']}', style: const TextStyle(fontSize: 13)),
              subtitle: Text('${r['hash']}', style: const TextStyle(fontSize: 10, color: Color(0xFF8B949E))),
            );
          }),
        ],
      ),
    );
  }
}
