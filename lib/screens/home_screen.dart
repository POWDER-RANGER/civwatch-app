import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../widgets/desk_card.dart';
import 'alerts_screen.dart';
import 'alpr_screen.dart';
import 'awards_screen.dart';
import 'settings_screen.dart';
import 'titan_screen.dart';
import 'veil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final h = state.health;
    final w = state.watchtowerHealth;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        title: const Text('CIVWATCH', style: TextStyle(color: Color(0xFF00E5FF), letterSpacing: 2)),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => state.bootstrap(),
            icon: const Icon(Icons.refresh, color: Color(0xFF8B949E)),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF8B949E)),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => state.bootstrap(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Civilian intelligence · defensive only',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 13),
            ),
            const SizedBox(height: 12),
            if (state.error != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D1F00),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFD29922)),
                ),
                child: Text(state.error!, style: const TextStyle(color: Color(0xFFFFDFA0), fontSize: 12)),
              ),
            Row(
              children: [
                MetricTile(label: 'Titan', value: h?.status ?? '—', ok: h?.status == 'ok'),
                const SizedBox(width: 8),
                MetricTile(
                    label: 'Evidence', value: h == null ? '—' : '${h.evidenceLength}', ok: h?.evidenceOk),
                const SizedBox(width: 8),
                MetricTile(label: 'Watchtower', value: w?.status ?? '—', ok: w?.status == 'ok'),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MetricTile(label: 'Alerts', value: '${state.alerts.length}'),
                MetricTile(label: 'Awards', value: '${state.awards.length}'),
                MetricTile(label: 'ALPR pts', value: '${state.alpr.length}'),
                MetricTile(label: 'Surv. assets', value: '${state.surveillance.length}'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Desks', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 8),
            DeskCard(
              title: 'Veil',
              subtitle: 'Live briefing · system pulse',
              icon: Icons.visibility_outlined,
              color: const Color(0xFF00E5FF),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VeilScreen())),
            ),
            DeskCard(
              title: 'Watchtower',
              subtitle: 'Map oversight · ' + state.watchtowerFeatures.toString() + ' features',
              icon: Icons.map_outlined,
              color: const Color(0xFF58A6FF),
              onTap: () => _openWatchtower(context, state),
            ),
            DeskCard(
              title: 'Cell Titan',
              subtitle: 'RF observability · evidence chain',
              icon: Icons.cell_tower,
              color: const Color(0xFF58A6FF),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TitanScreen())),
            ),
            DeskCard(
              title: 'Privacy',
              subtitle: 'ALPR / cameras / sensors · OSM + CIVINT',
              icon: Icons.privacy_tip_outlined,
              color: const Color(0xFFA371F7),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlprScreen())),
            ),
            DeskCard(
              title: 'Finance',
              subtitle: 'Federal awards · USAspending',
              icon: Icons.account_balance_outlined,
              color: const Color(0xFF3FB950),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AwardsScreen())),
            ),
            DeskCard(
              title: 'Alerts',
              subtitle: 'NWS active weather / hazard alerts',
              icon: Icons.warning_amber_outlined,
              color: const Color(0xFFD29922),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlertsScreen())),
            ),
            const SizedBox(height: 24),
            Text(
              'Public-interest · evidence-based · never targeting individuals',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
  void _openWatchtower(BuildContext context, AppState state) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Watchtower'),
        content: Text(
          state.watchtowerHealth == null
              ? (state.watchtowerError ?? 'Watchtower is not configured.')
              : 'Status: ' + state.watchtowerHealth!.status + '\n'
                'Database: ' + state.watchtowerHealth!.db + '\n'
                'Version: ' + state.watchtowerHealth!.version + '\n'
                'Map features: ' + state.watchtowerFeatures.toString(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

}
