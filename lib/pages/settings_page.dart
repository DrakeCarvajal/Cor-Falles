import 'package:flutter/material.dart';

import '../widgets/primary_button.dart';
import '../widgets/settings_card.dart';
import 'settings_account_page.dart';
import 'settings_notifications_page.dart';
import 'settings_web_access_page.dart';
import 'settings_help_page.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsPage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (_, c) {
            final cols = c.maxWidth >= 900 ? 2 : 1;
            return Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: cols,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: cols == 2 ? 2.2 : 2.6,
                    children: [
                      SettingsCard(
                        title: 'Cuenta y perfil',
                        icon: Icons.person,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsAccountPage()),
                        ),
                      ),
                      SettingsCard(
                        title: 'Notificaciones',
                        icon: Icons.notifications,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingsNotificationsPage()),
                        ),
                      ),
                      SettingsCard(
                        title: 'Accesos a la web',
                        icon: Icons.web,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsWebAccessPage()),
                        ),
                      ),
                      SettingsCard(
                        title: 'Ayuda y soporte',
                        icon: Icons.support_agent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsHelpPage()),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: 'Cerrar sesión',
                  color: const Color(0xFF8B0000),
                  onTap: () {
                    onLogout();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sesión cerrada.')),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
