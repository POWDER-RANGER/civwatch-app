import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/settings.dart';
import '../services/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _titan;
  late final TextEditingController _civint;
  late final TextEditingController _watchtower;
  late final TextEditingController _token;

  @override
  void initState() {
    super.initState();
    _titan = TextEditingController(text: AppSettings.instance.titanBase);
    _civint = TextEditingController(text: AppSettings.instance.civintBase);
    _watchtower = TextEditingController(text: AppSettings.instance.watchtowerBase);
    _token = TextEditingController(text: AppSettings.instance.apiToken);
  }

  @override
  void dispose() {
    _titan.dispose();
    _civint.dispose();
    _watchtower.dispose();
    _token.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(backgroundColor: const Color(0xFF0D1117), title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Supported without TLS: localhost and emulator only. '
            'Do not bind Titan to LAN for a physical phone.',
            style: TextStyle(fontSize: 12, color: Color(0xFFD29922)),
          ),
          const SizedBox(height: 16),
          const Text('Cell Titan base URL', style: TextStyle(fontSize: 12, color: Color(0xFF8B949E))),
          TextField(
            controller: _titan,
            decoration: const InputDecoration(hintText: 'http://127.0.0.1:8000'),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Text('Titan API token (secure storage)', style: TextStyle(fontSize: 12, color: Color(0xFF8B949E))),
          TextField(
            controller: _token,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Bearer token from TITAN_API_TOKEN'),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Text('CIVINT JSON base URL', style: TextStyle(fontSize: 12, color: Color(0xFF8B949E))),
          TextField(
            controller: _civint,
            decoration: const InputDecoration(hintText: 'https://.../public/civint'),
            style: const TextStyle(fontSize: 14),
          ),

          const Text('Watchtower base URL', style: TextStyle(fontSize: 12, color: Color(0xFF8B949E))),
          TextField(
            controller: _watchtower,
            decoration: const InputDecoration(hintText: 'http://127.0.0.1:3000'),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () async {
              await AppSettings.instance.save(
                titan: _titan.text,
                civint: _civint.text,
                watchtower: _watchtower.text,
                token: _token.text,
              );
              if (context.mounted) {
                await context.read<AppState>().bootstrap();
                Navigator.pop(context);
              }
            },
            child: const Text('Save & reconnect'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Desktop → http://127.0.0.1:8000\n'
            'Android emulator → http://10.0.2.2:8000\n'
            'iOS simulator → http://127.0.0.1:8000\n'
            'Physical phone → use Tailscale/HTTPS only, never open LAN HTTP',
            style: TextStyle(fontSize: 12, color: Color(0xFF8B949E)),
          ),
        ],
      ),
    );
  }
}
