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

  @override
  void initState() {
    super.initState();
    _titan = TextEditingController(text: AppSettings.instance.titanBase);
    _civint = TextEditingController(text: AppSettings.instance.civintBase);
  }

  @override
  void dispose() {
    _titan.dispose();
    _civint.dispose();
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
          const Text('Cell Titan base URL', style: TextStyle(fontSize: 12, color: Color(0xFF8B949E))),
          TextField(
            controller: _titan,
            decoration: const InputDecoration(hintText: 'http://127.0.0.1:8000'),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Text('CIVINT JSON base URL', style: TextStyle(fontSize: 12, color: Color(0xFF8B949E))),
          TextField(
            controller: _civint,
            decoration: const InputDecoration(hintText: 'https://.../public/civint'),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () async {
              await AppSettings.instance.save(titan: _titan.text, civint: _civint.text);
              if (context.mounted) {
                await context.read<AppState>().bootstrap();
                Navigator.pop(context);
              }
            },
            child: const Text('Save & reconnect'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Android emulator → Titan on host: http://10.0.2.2:8000\n'
            'iOS simulator → http://127.0.0.1:8000\n'
            'Physical device → use your LAN IP.\n'
            'Windows / Linux desktop → http://127.0.0.1:8000',
            style: TextStyle(fontSize: 12, color: Color(0xFF8B949E)),
          ),
        ],
      ),
    );
  }
}
