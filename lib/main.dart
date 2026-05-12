import 'package:flutter/material.dart';

import 'provider/auth_provider.dart';
import 'pages/app_entry.dart';

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

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      notifier: auth,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cor Falles',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B0000)),
        ),
        home: const AppEntry(),
      ),
    );
  }
}
