import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../utils/event_image.dart';
import '../utils/event_marker_style.dart';
import '../models/demo_event.dart';
import '../provider/event_provider.dart';
import 'event_detail_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const _valenciaCenter = LatLng(39.4699, -0.3763);

  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  final Set<String> _activeCategories = {};

  DemoEvent? selectedEvent;
  String _query = '';
  double _currentZoom = 13.2;
  LatLng _currentCenter = _valenciaCenter;

  List<DemoEvent> _applyCategoryFilter(List<DemoEvent> events) {
    if (_activeCategories.isEmpty) return events;
    return events.where((e) => _activeCategories.contains(e.category)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DemoEvent> _filteredEvents(List<DemoEvent> events) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return [];

    return events.where((e) {
      return e.title.toLowerCase().contains(q) ||
          e.subtitle.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q);
    }).toList();
  }

  void _selectEvent(DemoEvent event) {
    setState(() {
      selectedEvent = event;
    });

    if (event.latitude != null && event.longitude != null) {
      const autoZoom = 15.2;
      final targetZoom = _currentZoom > autoZoom ? _currentZoom : autoZoom;

      _mapController.move(
        LatLng(event.latitude!, event.longitude!),
        targetZoom,
      );
    }
  }

  void _zoomIn() {
    final newZoom = (_currentZoom + 1).clamp(3.0, 19.0);
    _mapController.move(_currentCenter, newZoom);

    setState(() {
      _currentZoom = newZoom;
    });
  }

  void _zoomOut() {
    final newZoom = (_currentZoom - 1).clamp(3.0, 19.0);
    _mapController.move(_currentCenter, newZoom);

    setState(() {
      _currentZoom = newZoom;
    });
  }

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);
    // final isMobile = MediaQuery.of(context).size.width < 900;

    final events = EventScope.of(context).mapEvents();
    final visibleEvents = _applyCategoryFilter(events);
    final filteredEvents = _filteredEvents(visibleEvents);

    final mapCenter = events.isNotEmpty
        ? LatLng(events.first.latitude!, events.first.longitude!)
        : _valenciaCenter;

    final availableCategories = events.map((e) => e.category).toSet().toList()
      ..sort((a, b) {
        if (a == 'Otro' && b != 'Otro') return 1;
        if (a != 'Otro' && b == 'Otro') return -1;
        return a.toLowerCase().compareTo(b.toLowerCase());
      });

    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 900;

        return Scaffold(
          backgroundColor: yellow,
          appBar: AppBar(
            title: const Text('Mapa'),
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(
              wide ? 16 : 0,
              wide ? 16 : 0,
              wide ? 16 : 0,
              wide ? 16 : 0,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: _buildMapCard(
                    center: mapCenter,
                    events: visibleEvents,
                    wide: wide,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      wide ? 12 : 6,
                      wide ? 12 : 6,
                      wide ? 12 : 6,
                      0,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: wide ? 760 : double.infinity,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSearchBar(),
                          if (_query.isNotEmpty) const SizedBox(height: 6),
                          if (_query.isNotEmpty)
                            _buildSearchResults(filteredEvents, wide: wide),
                          const SizedBox(height: 6),
                          _buildCategoryFilters(
                            availableCategories,
                            wide: wide,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (selectedEvent != null)
                  Positioned(
                    left: wide ? 16 : 8,
                    right: wide ? null : 8,
                    bottom: wide ? 16 : 8,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: wide ? 470 : double.infinity,
                      ),
                      child: _buildSelectedEventPanel(context, wide: wide),
                    ),
                  ),
                if (wide)
                  Positioned(
                    right: 16,
                    bottom: 20,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: 'main_map_zoom_in',
                          backgroundColor: const Color(0xFF0B4DB3),
                          foregroundColor: Colors.white,
                          onPressed: _zoomIn,
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(height: 10),
                        FloatingActionButton.small(
                          heroTag: 'main_map_zoom_out',
                          backgroundColor: const Color(0xFF8B0000),
                          foregroundColor: Colors.white,
                          onPressed: _zoomOut,
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapCard({
    required LatLng center,
    required List<DemoEvent> events,
    required bool wide,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      color: const Color(0xFFFFFBF5),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(wide ? 18 : 12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(wide ? 18 : 12),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: wide ? 13.2 : 12.8,
            onTap: (_, __) {
              setState(() {
                selectedEvent = null;
              });
            },
            onPositionChanged: (position, hasGesture) {
              final zoom = position.zoom;
              final center = position.center;

              if (zoom != null) {
                _currentZoom = zoom;
              }

              _currentCenter = center;
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.corfalles.app',
            ),
            MarkerLayer(
              markers: events
                  .map(
                    (e) => Marker(
                      point: LatLng(e.latitude!, e.longitude!),
                      width: 52,
                      height: 52,
                      child: GestureDetector(
                        onTap: () => _selectEvent(e),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedEvent?.id == e.id
                                ? const Color(0xFF0B4DB3)
                                : eventMarkerColor(e.category),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            eventMarkerIcon(e.category),
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(18),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _query = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar eventos...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _query = '';
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
          filled: true,
          fillColor: const Color(0xFFFFFBF5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<DemoEvent> results, {required bool wide}) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(18),
      color: const Color(0xFFFFFBF5),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: wide ? 300 : 240,
        ),
        child: results.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No se encontraron eventos.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: results.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final e = results[index];
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: eventMarkerColor(e.category),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        eventMarkerIcon(e.category),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      e.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text('${e.subtitle} · ${e.dateInfo}'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: eventMarkerColor(e.category),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            eventMarkerIcon(e.category),
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            e.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => _selectEvent(e),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildSelectedEventPanel(BuildContext context, {required bool wide}) {
    final event = selectedEvent!;
    return Material(
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
                width: wide ? 125 : 96,
                height: wide ? 92 : 76,
                child: EventImage(
                  imageUrl: event.imageUrl,
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
                    event.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF8B0000),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.subtitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.dateInfo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B4DB3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventDetailPage(event: event),
                  ),
                );
              },
              child: const Text('Ver'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(
    List<String> categories, {
    required bool wide,
  }) {
    final chips = categories.map((category) {
      final selected = _activeCategories.contains(category);

      return Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: FilterChip(
          selected: selected,
          onSelected: (value) {
            setState(() {
              if (value) {
                _activeCategories.add(category);
              } else {
                _activeCategories.remove(category);
              }

              if (selectedEvent != null &&
                  !_applyCategoryFilter([selectedEvent!])
                      .contains(selectedEvent)) {
                selectedEvent = null;
              }
            });
          },
          avatar: Icon(
            eventMarkerIcon(category),
            size: 18,
            color: selected ? Colors.white : eventMarkerColor(category),
          ),
          label: Text(category),
          selectedColor: eventMarkerColor(category),
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w700,
          ),
          backgroundColor: const Color(0xFFFFFBF5),
          side: BorderSide(
            color: eventMarkerColor(category).withOpacity(0.45),
          ),
        ),
      );
    }).toList();

    return Align(
      alignment: Alignment.centerLeft,
      child: wide
          ? Wrap(
              children: chips,
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: chips),
            ),
    );
  }
}
