import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/demo_event.dart';
import '../provider/auth_provider.dart';
import '../provider/event_provider.dart';
import '../utils/event_image.dart';
import '../utils/event_marker_style.dart';
import '../widgets/event_card.dart';
import 'create_event_page.dart';

class EventDetailPage extends StatelessWidget {
  final DemoEvent event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

    final auth = AuthScope.of(context);
    final canManageEvents = auth.canCreateEvents;
    final eventController = EventScope.of(context);
    final currentEvent = eventController.getById(event.id) ?? event;

    final relatedEvents = eventController.publishedEvents
        .where((x) => x.id != currentEvent.id)
        .toList();

    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        title: const Text('Detalle de evento'),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (_, c) {
            final screenWidth = MediaQuery.of(context).size.width;
            final wide = screenWidth >= 900;
            // final wide = c.maxWidth >= 900;

            final titleSize = wide ? 30.0 : 24.0;
            final infoSize = wide ? 18.0 : 16.0;
            final sectionSize = wide ? 22.0 : 18.0;
            final bodySize = wide ? 17.0 : 15.0;

            if (!wide) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainDetailCard(
                      context,
                      c,
                      wide,
                      canManageEvents,
                      currentEvent,
                      titleSize,
                      infoSize,
                      sectionSize,
                      bodySize,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'También podría interesarte',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...relatedEvents.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          height: 140,
                          child: EventCardMock(
                            title: e.title,
                            subtitle: e.subtitle,
                            imageUrl: e.imageUrl,
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailPage(event: e),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 7,
                  child: _buildMainDetailCard(
                    context,
                    c,
                    wide,
                    canManageEvents,
                    currentEvent,
                    titleSize,
                    infoSize,
                    sectionSize,
                    bodySize,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      const Text(
                        'También podría interesarte',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView(
                          children: relatedEvents
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: SizedBox(
                                    height: 180,
                                    child: EventCardMock(
                                      title: e.title,
                                      subtitle: e.subtitle,
                                      imageUrl: e.imageUrl,
                                      onTap: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EventDetailPage(event: e),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainDetailCard(
    BuildContext context,
    BoxConstraints c,
    bool wide,
    bool canManageEvents,
    DemoEvent currentEvent,
    double titleSize,
    double infoSize,
    double sectionSize,
    double bodySize,
  ) {
    return Card(
      color: const Color(0xFFFFFBF5),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: LayoutBuilder(
        builder: (context, cardConstraints) {
          final content = Container(
            constraints: BoxConstraints(
              minHeight: wide ? cardConstraints.maxHeight : 0,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: wide ? 320 : 220,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        EventImage(
                          imageUrl: currentEvent.imageUrl,
                          fit: BoxFit.cover,
                          errorFallback: Container(
                            color: Colors.black12,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 60,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                        Container(color: Colors.black.withOpacity(0.20)),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            color: const Color(0xFF0B4DB3),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              currentEvent.title,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: wide ? 24 : 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _detailChip(
                      icon: Icons.category,
                      label: currentEvent.category,
                      color: const Color(0xFF0B4DB3),
                    ),
                    if (currentEvent.status == 'borrador')
                      _detailChip(
                        icon: Icons.save,
                        label: 'Borrador',
                        color: const Color(0xFF8B0000),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3ECE3),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.08),
                    ),
                  ),
                  child: Column(
                    children: [
                      _detailInfoRow(
                        icon: Icons.place,
                        text: currentEvent.subtitle,
                        fontSize: infoSize,
                      ),
                      const SizedBox(height: 12),
                      _detailInfoRow(
                        icon: Icons.calendar_today,
                        text: currentEvent.dateInfo,
                        fontSize: infoSize,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3ECE3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: sectionSize,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF8B0000),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0E8DE),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ),
                  child: Text(
                    currentEvent.description.trim().isEmpty
                        ? 'Este evento todavía no tiene una descripción detallada.'
                        : currentEvent.description,
                    style: TextStyle(
                      fontSize: bodySize,
                      height: 1.5,
                      color: const Color(0xFF3A2B2B),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3ECE3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Ubicación',
                    style: TextStyle(
                      fontSize: sectionSize,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF8B0000),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildLocationSection(
                  context,
                  currentEvent,
                  wide,
                  bodySize,
                ),
                if (canManageEvents) ...[
                  const SizedBox(height: 22),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0B4DB3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CreateEventPage(initialEvent: currentEvent),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, size: 24),
                          label: const Text(
                            'Editar',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B0000),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Eliminar evento'),
                                content: const Text(
                                  '¿Seguro que quieres eliminar este evento? Dejará de mostrarse en la app.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed != true) return;

                            await EventScope.of(context)
                                .softDeleteEvent(currentEvent.id);

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Evento eliminado correctamente.'),
                              ),
                            );

                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.delete, size: 24),
                          label: const Text(
                            'Eliminar',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );

          if (!wide) return content;

          return SingleChildScrollView(
            child: content,
          );
        },
      ),
    );
  }

  Widget _buildLocationSection(
    BuildContext context,
    DemoEvent currentEvent,
    bool wide,
    double bodySize,
  ) {
    final hasCoords =
        currentEvent.latitude != null && currentEvent.longitude != null;

    if (!hasCoords) {
      return Container(
        width: double.infinity,
        height: wide ? 220 : 180,
        decoration: BoxDecoration(
          color: const Color(0xFFF3ECE3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.black.withOpacity(0.08),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.map,
                    size: 52,
                    color: Color(0xFF8B0000),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(
                    Icons.place,
                    color: Color(0xFF8B0000),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      currentEvent.subtitle,
                      style: TextStyle(
                        fontSize: bodySize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final point = LatLng(currentEvent.latitude!, currentEvent.longitude!);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: double.infinity,
        height: wide ? 220 : 180,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: point,
                initialZoom: 15.5,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.drag |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom |
                      InteractiveFlag.scrollWheelZoom,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.corfalles.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: point,
                      width: 48,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          color: eventMarkerColor(currentEvent.category),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          eventMarkerIcon(currentEvent.category),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B4DB3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _EventLocationMapPage(
                        currentEvent: currentEvent,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_full, size: 18),
                label: const Text(
                  'Abrir mapa',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailInfoRow({
    required IconData icon,
    required String text,
    required double fontSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF8B0000)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _EventLocationMapPage extends StatefulWidget {
  final DemoEvent currentEvent;

  const _EventLocationMapPage({
    required this.currentEvent,
  });

  @override
  State<_EventLocationMapPage> createState() => _EventLocationMapPageState();
}

class _EventLocationMapPageState extends State<_EventLocationMapPage> {
  final MapController _mapController = MapController();

  late final LatLng _point;
  late LatLng _currentCenter;
  double _currentZoom = 15.5;

  @override
  void initState() {
    super.initState();
    _point = LatLng(
      widget.currentEvent.latitude!,
      widget.currentEvent.longitude!,
    );
    _currentCenter = _point;
  }

  void _zoomIn() {
    final newZoom = (_currentZoom + 1).clamp(3.0, 19.0);
    _mapController.move(_currentCenter, newZoom);
  }

  void _zoomOut() {
    final newZoom = (_currentZoom - 1).clamp(3.0, 19.0);
    _mapController.move(_currentCenter, newZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación del evento'),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _point,
                initialZoom: _currentZoom,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.drag |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom |
                      InteractiveFlag.scrollWheelZoom,
                ),
                onPositionChanged: (position, hasGesture) {
                  _currentCenter = position.center;
                  _currentZoom = position.zoom;
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.corfalles.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _point,
                      width: 54,
                      height: 54,
                      child: Container(
                        decoration: BoxDecoration(
                          color: eventMarkerColor(widget.currentEvent.category),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          eventMarkerIcon(widget.currentEvent.category),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoom_in_detail_map',
                  backgroundColor: const Color(0xFF0B4DB3),
                  foregroundColor: Colors.white,
                  onPressed: _zoomIn,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.small(
                  heroTag: 'zoom_out_detail_map',
                  backgroundColor: const Color(0xFF8B0000),
                  foregroundColor: Colors.white,
                  onPressed: _zoomOut,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: 16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xFFFFFBF5),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 96,
                              height: 96,
                              child: EventImage(
                                imageUrl: widget.currentEvent.imageUrl,
                                fit: BoxFit.cover,
                                errorFallback: Container(
                                  color: Colors.black12,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.currentEvent.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF8B0000),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.currentEvent.subtitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(widget.currentEvent.dateInfo),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreviewImage(DemoEvent event) {
    final image = event.imageUrl;

    if (image == null || image.isEmpty) {
      return Container(
        color: const Color(0xFFE6DED7),
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_outlined,
          size: 34,
          color: Color(0xFF8B0000),
        ),
      );
    }

    if (image.startsWith('assets/')) {
      return Image.asset(
        image,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      image,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          color: const Color(0xFFE6DED7),
          alignment: Alignment.center,
          child: const Icon(
            Icons.broken_image_outlined,
            size: 34,
            color: Color(0xFF8B0000),
          ),
        );
      },
    );
  }
}
