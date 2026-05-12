import 'package:flutter/material.dart';

import '../widgets/settings_card.dart';

class SettingsWebAccessPage extends StatelessWidget {
  const SettingsWebAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        title: const Text('Accesos a la web'),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width >= 900 ? 2 : 1,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 2.6,
          children: [
            SettingsCard(
              title: 'Vincular con Google Calendar',
              icon: Icons.calendar_month,
              onTap: () => _toast(context, 'Google Calendar (pendiente)'),
            ),
            SettingsCard(
              title: 'Gestionar permisos',
              icon: Icons.verified_user,
              onTap: () => _toast(context, 'Permisos (pendiente)'),
            ),
          ],
        ),
      ),
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
