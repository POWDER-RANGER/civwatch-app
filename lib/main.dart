import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/settings.dart';
import 'screens/home_screen.dart';
import 'services/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.instance.load();
  runApp(const CivwatchApp());
}

class CivwatchApp extends StatelessWidget {
  const CivwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'CIVWATCH',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00E5FF),
            surface: Color(0xFF0D1117),
          ),
          scaffoldBackgroundColor: const Color(0xFF0D1117),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
