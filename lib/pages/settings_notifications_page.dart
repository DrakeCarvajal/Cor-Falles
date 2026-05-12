import 'package:flutter/material.dart';

class SettingsNotificationsPage extends StatefulWidget {
  const SettingsNotificationsPage({super.key});

  @override
  State<SettingsNotificationsPage> createState() => _SettingsNotificationsPageState();
}

class _SettingsNotificationsPageState extends State<SettingsNotificationsPage> {
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: const Color(0xFF8B0000),
              child: ListTile(
                leading: const Icon(Icons.power_settings_new, color: Colors.white),
                title: const Text('Activar/Desactivar',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                trailing: Switch(
                  value: enabled,
                  onChanged: (v) => setState(() => enabled = v),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Card(
              color: Color(0xFF8B0000),
              child: ListTile(
                leading: Icon(Icons.volume_off, color: Colors.white),
                title: Text('Horas de silencio',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                subtitle:
                    Text('Placeholder: configurar horario', style: TextStyle(color: Colors.white70)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
