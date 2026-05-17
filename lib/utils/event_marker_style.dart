import 'package:flutter/material.dart';

IconData eventMarkerIcon(String category) {
  switch (category.toLowerCase()) {
    case 'mascletà':
      return Icons.local_fire_department;
    case 'discomóvil':
      return Icons.music_note;
    case 'ofrenda':
      return Icons.local_florist;
    case 'castillo':
      return Icons.celebration;
    case 'pasacalle':
      return Icons.directions_walk;
    case 'exposición':
      return Icons.palette;
    case 'verbena':
      return Icons.nightlife;
    default:
      return Icons.location_on;
  }
}

Color eventMarkerColor(String category) {
  switch (category.toLowerCase()) {
    case 'mascletà':
      return const Color(0xFFB22222);
    case 'discomóvil':
      return const Color(0xFF7B1FA2);
    case 'ofrenda':
      return const Color(0xFFAD1457);
    case 'castillo':
      return const Color(0xFFFF8F00);
    case 'pasacalle':
      return const Color(0xFF00897B);
    case 'exposición':
      return const Color(0xFF5D4037);
    case 'verbena':
      return const Color(0xFF3949AB);
    default:
      return const Color(0xFF8B0000);
  }
}
