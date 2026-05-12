import 'package:flutter/material.dart';

import '../widgets/settings_card.dart';

class SettingsHelpPage extends StatelessWidget {
  const SettingsHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        title: const Text('Ayuda y soporte'),
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
              title: 'Preguntas frecuentes (FAQ)',
              icon: Icons.help_outline,
              onTap: () => _toast(context, 'FAQ (pendiente)'),
            ),
            SettingsCard(
              title: 'Contactar con soporte',
              icon: Icons.headset_mic,
              onTap: () => _toast(context, 'Soporte (pendiente)'),
            ),
            SettingsCard(
              title: 'Política de privacidad',
              icon: Icons.privacy_tip,
              onTap: () => _toast(context, 'Privacidad (pendiente)'),
            ),
            SettingsCard(
              title: 'Info de la app',
              icon: Icons.info_outline,
              onTap: () => _toast(context, 'Info de la app (pendiente)'),
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
