import 'dart:convert';

class DemoEvent {
  final String id;
  final String title;
  final String subtitle;
  final String dateInfo;
  final String imageUrl;
  final String description;
  final String category;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final double? latitude;
  final double? longitude;

  /// publicado | borrador | eliminado
  final String status;
  final DateTime? createdAt;

  const DemoEvent(
    this.title,
    this.subtitle,
    this.dateInfo, {
    required this.imageUrl,
    required this.id,
    this.description = '',
    this.category = 'Otro',
    this.startDateTime,
    this.endDateTime,
    this.latitude,
    this.longitude,
    this.status = 'publicado',
    this.createdAt,
  });

  DemoEvent copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? dateInfo,
    String? imageUrl,
    String? description,
    String? category,
    DateTime? startDateTime,
    DateTime? endDateTime,
    double? latitude,
    double? longitude,
    String? status,
    DateTime? createdAt,
  }) {
    return DemoEvent(
      title ?? this.title,
      subtitle ?? this.subtitle,
      dateInfo ?? this.dateInfo,
      imageUrl: imageUrl ?? this.imageUrl,
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'dateInfo': dateInfo,
      'imageUrl': imageUrl,
      'description': description,
      'category': category,
      'startDateTime': startDateTime?.toIso8601String(),
      'endDateTime': endDateTime?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory DemoEvent.fromJson(Map<String, dynamic> json) {
    return DemoEvent(
      json['title'] ?? '',
      json['subtitle'] ?? '',
      json['dateInfo'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Otro',
      startDateTime: json['startDateTime'] != null
          ? DateTime.tryParse(json['startDateTime'])
          : null,
      endDateTime: json['endDateTime'] != null
          ? DateTime.tryParse(json['endDateTime'])
          : null,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] ?? 'publicado',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  static List<DemoEvent> listFromJsonString(String source) {
    final decoded = jsonDecode(source) as List<dynamic>;
    return decoded
        .map((item) => DemoEvent.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static String listToJsonString(List<DemoEvent> events) {
    return jsonEncode(events.map((e) => e.toJson()).toList());
  }
}

final seedDemoEvents = <DemoEvent>[
  DemoEvent(
    'Mascletà',
    'Plaza del Ayuntamiento',
    '02/06/2026 14:00 - 14:30',
    id: 'event_1',
    imageUrl: 'assets/events_images/mascleta.jpg',
    description: 'Mascletà principal en la Plaza del Ayuntamiento.',
    category: 'Mascletà',
    startDateTime: DateTime(2026, 6, 2, 14, 0),
    endDateTime: DateTime(2026, 6, 2, 14, 30),
    latitude: 39.4699,
    longitude: -0.3763,
    status: 'publicado',
  ),
  DemoEvent(
    'Discomóvil',
    'Calle Convento de Jerusalén',
    '02/06/2026 23:30 - 02:00',
    id: 'event_2',
    imageUrl: 'assets/events_images/discomovil.jpg',
    description: 'Sesión nocturna con música y ambiente festivo.',
    category: 'Discomóvil',
    startDateTime: DateTime(2026, 6, 02, 23, 30),
    endDateTime: DateTime(2026, 6, 02, 2, 0),
    latitude: 39.465509,
    longitude: -0.379917,
    status: 'publicado',
  ),
  DemoEvent(
    'Exposición del Ninot',
    'Museo de las Ciencias',
    '06/06/2026 10:00 - 20:00',
    id: 'event_3',
    imageUrl: 'assets/events_images/exposicion.jpg',
    description: 'Exposición de ninots seleccionados.',
    category: 'Exposición',
    startDateTime: DateTime(2026, 6, 06, 10, 0),
    endDateTime: DateTime(2026, 6, 06, 20, 0),
    latitude: 39.4549,
    longitude: -0.3539,
    status: 'publicado',
  ),
  DemoEvent(
    'Pasacalle',
    'Centro histórico',
    '07/06/2026 18:00 - 20:00',
    id: 'event_5',
    imageUrl: 'assets/events_images/pasacalles.jpg',
    description: 'Pasacalle por el centro histórico.',
    category: 'Pasacalle',
    startDateTime: DateTime(2026, 6, 07, 18, 0),
    endDateTime: DateTime(2026, 6, 07, 20, 0),
    latitude: 39.4750,
    longitude: -0.3768,
    status: 'publicado',
  ),
  DemoEvent(
    'Castillo',
    'Jardín del Turia',
    '08/06/2026 00:00 - 00:30',
    id: 'event_6',
    imageUrl: 'assets/events_images/castillo.jpg',
    description: 'Espectáculo pirotécnico nocturno.',
    category: 'Castillo',
    startDateTime: DateTime(2026, 6, 08, 0, 0),
    endDateTime: DateTime(2026, 6, 08, 0, 30),
    latitude: 39.4705,
    longitude: -0.3621,
    status: 'publicado',
  ),
  DemoEvent(
    'Ofrenda',
    'Plaza de la Virgen',
    '02/06/2026 17:00 - 20:00',
    id: 'event_7',
    imageUrl: 'assets/events_images/ofrenda.jpg',
    description: 'Ofrenda floral tradicional en honor a la Virgen.',
    category: 'Ofrenda',
    startDateTime: DateTime(2026, 6, 02, 17, 0),
    endDateTime: DateTime(2026, 6, 02, 20, 0),
    latitude: 39.4766,
    longitude: -0.3753,
    status: 'publicado',
  ),
  DemoEvent(
    'Verbena Fallera',
    'Casal fallero de Ruzafa',
    '04/06/2026 22:00 - 02:00',
    id: 'event_8',
    imageUrl: 'assets/events_images/verbena.jpg',
    description: 'Verbena nocturna organizada por la comisión fallera.',
    category: 'Verbena',
    startDateTime: DateTime(2026, 6, 4, 22, 0),
    endDateTime: DateTime(2026, 6, 4, 2, 0),
    latitude: 39.4620,
    longitude: -0.3704,
    status: 'publicado',
  ),
  DemoEvent(
    'Cabalgata del Ninot',
    'Centro de Valencia',
    '05/06/2026 17:30 - 19:30',
    id: 'event_9',
    imageUrl: 'assets/events_images/default_event.jpg',
    description: 'Cabalgata festiva con comparsas y ambiente fallero.',
    category: 'Otro',
    startDateTime: DateTime(2026, 6, 5, 17, 30),
    endDateTime: DateTime(2026, 6, 5, 19, 30),
    latitude: 39.4740,
    longitude: -0.3760,
    status: 'publicado',
  ),
];
