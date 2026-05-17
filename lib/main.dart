import 'package:flutter/material.dart';

import 'pages/app_entry.dart';
import 'provider/auth_provider.dart';
import 'provider/event_provider.dart';

void main() {
  runApp(const CorFallesApp());
}

class CorFallesApp extends StatefulWidget {
  const CorFallesApp({super.key});

  @override
  State<CorFallesApp> createState() => _CorFallesAppState();
}

class _CorFallesAppState extends State<CorFallesApp> {
  late final AuthController auth = AuthController();
  late final EventController events = EventController();

  // @override
  // void initState() {
  //   super.initState();

  //   Future.microtask(() async {
  //     await events.resetToSeedEvents();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return EventScope(
      notifier: events,
      child: AuthScope(
        notifier: auth,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cor Falles',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF8B0000),
            ),
          ),
          home: const AppEntry(),
        ),
      ),
    );
  }
}
