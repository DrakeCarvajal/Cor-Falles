import 'package:flutter/material.dart';

import '../widgets/settings_card.dart';

class SettingsAccountPage extends StatelessWidget {
  const SettingsAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        title: const Text('Cuenta y perfil'),
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
              title: 'Editar perfil',
              icon: Icons.edit,
              onTap: () => _toast(context, 'Editar perfil (pendiente)'),
            ),
            SettingsCard(
              title: 'Verificación ID',
              icon: Icons.badge,
              onTap: () => _toast(context, 'Verificación ID (pendiente)'),
            ),
            SettingsCard(
              title: 'Cambiar idioma',
              icon: Icons.translate,
              onTap: () => _toast(context, 'Cambiar idioma (pendiente)'),
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
