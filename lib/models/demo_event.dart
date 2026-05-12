class DemoEvent {
  final String title;
  final String subtitle;
  final String dateInfo;
  final String imageUrl;

  const DemoEvent(
    this.title,
    this.subtitle,
    this.dateInfo, {
    required this.imageUrl,
  });
}

const demoEvents = <DemoEvent>[
  DemoEvent('Mascletà', 'Plaza del Ayuntamiento', 'Hoy 14:00',
      imageUrl:
          'https://images.unsplash.com/photo-1519750783826-e2420f4d687f?auto=format&fit=crop&w=1400&q=80'),
  DemoEvent('Discomóvil', 'Calle Jerusalén', 'Mañana 23:30',
      imageUrl:
          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?auto=format&fit=crop&w=1400&q=80'),
  DemoEvent('Ninots', 'Exposición', 'Fin de semana',
      imageUrl:
          'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?auto=format&fit=crop&w=1400&q=80'),
  DemoEvent('Vendimia', 'Evento cultural', 'Próximamente',
      imageUrl:
          'https://images.unsplash.com/photo-1444723121867-7a241cacace9?auto=format&fit=crop&w=1400&q=80'),
  DemoEvent('Pasacalle', 'Centro histórico', 'Sábado 18:00',
      imageUrl:
          'https://images.unsplash.com/photo-1504805572947-34fad45aed93?auto=format&fit=crop&w=1400&q=80'),
  DemoEvent('Castillo', 'Jardín del Turia', 'Domingo 00:00',
      imageUrl:
          'https://images.unsplash.com/photo-1520975958225-3f61d2f24006?auto=format&fit=crop&w=1400&q=80'),
  DemoEvent('Ofrenda', 'Plaza de la Virgen', 'Lunes 17:00',
      imageUrl:
          'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?auto=format&fit=crop&w=1400&q=80'),
  DemoEvent('Concierto', 'Ciudad de las Artes', 'Viernes 21:00',
      imageUrl:
          'https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=1400&q=80'),
  DemoEvent('Mercado', 'Ruzafa', 'Todo el día',
      imageUrl:
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=1400&q=80'),
  DemoEvent('Taller', 'Casal fallero', 'Miércoles 19:00',
      imageUrl:
          'https://images.unsplash.com/photo-1529333166437-7750a6dd5a70?auto=format&fit=crop&w=1400&q=80'),
];
