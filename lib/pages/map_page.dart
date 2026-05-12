import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        title: const Text('Mapa'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Center(
            child: Text(
              'Mapa (placeholder)\n\nLuego puedes integrar Google Maps / OpenStreetMap.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black.withOpacity(0.75)),
            ),
          ),
        ),
      ),
    );
  }
}
