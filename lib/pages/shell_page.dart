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
          body: content,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tab.index,
            onTap: (i) => setState(() => tab = AppTab.values[i]),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.event), label: 'Eventos'),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Ajustes'),
            ],
          ),
        );
      },
    );
  }
}
