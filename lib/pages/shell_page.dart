import 'package:flutter/material.dart';

import '../provider/auth_provider.dart';
import '../widgets/left_menu.dart';
import '../routes/app_tab.dart';
import 'home_page.dart';
import 'events_page.dart';
import 'map_page.dart';
import 'settings_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  AppTab tab = AppTab.inicio;

  static const Color _yellow = Color(0xFFF7D96B);
  static const Color _red = Color(0xFF8B0000);
  static const Color _blue = Color(0xFF0B4DB3);
  static const Color _softCard = Color(0xFFFFFBF5);

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

        final content = switch (tab) {
          AppTab.inicio => const HomePage(),
          AppTab.eventos => const EventsPage(),
          AppTab.mapa => const MapPage(),
          AppTab.ajustes => SettingsPage(onLogout: auth.logout),
        };

        if (wide) {
          return Scaffold(
            body: Row(
              children: [
                LeftMenu(
                  selected: tab,
                  onSelect: (t) => setState(() => tab = t),
                ),
                Expanded(child: content),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: _yellow,
          body: content,
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              height: 82,
              backgroundColor: _softCard,
              indicatorColor: _blue.withOpacity(0.14),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 12.5,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? _blue : _red.withOpacity(0.72),
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return IconThemeData(
                  size: 24,
                  color: selected ? _blue : _red.withOpacity(0.72),
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: tab.index,
              onDestinationSelected: (i) =>
                  setState(() => tab = AppTab.values[i]),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.event),
                  label: 'Eventos',
                ),
                NavigationDestination(
                  icon: Icon(Icons.map),
                  label: 'Mapa',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: 'Ajustes',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
