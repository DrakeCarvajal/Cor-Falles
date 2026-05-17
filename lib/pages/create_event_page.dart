import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/demo_event.dart';
import '../provider/event_provider.dart';
import '../utils/event_categories.dart';
import '../utils/event_image.dart';
import '../utils/event_marker_style.dart';

class CreateEventPage extends StatefulWidget {
  final DemoEvent? initialEvent;

  const CreateEventPage({
    super.key,
    this.initialEvent,
  });

  bool get isEditing => initialEvent != null;

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final titleC = TextEditingController();
  final descriptionC = TextEditingController();
  final dateC = TextEditingController();
  final startTimeC = TextEditingController();
  final endTimeC = TextEditingController();
  final locationC = TextEditingController();

  double? selectedLatitude;
  double? selectedLongitude;
  String? selectedImageData;
  String selectedCategory = 'Mascletà';
  // bool publishNow = false;

  String _initialTitle = '';
  String _initialDescription = '';
  String _initialDate = '';
  String _initialStartTime = '';
  String _initialEndTime = '';
  String _initialLocation = '';
  String _initialCategory = '';
  double? _initialLatitude;
  double? _initialLongitude;
  String? _initialImageData;

  static const LatLng _defaultMapCenter = LatLng(39.4699, -0.3763);
  final List<String> categories = List<String>.from(appEventCategories);

  @override
  void initState() {
    super.initState();

    final event = widget.initialEvent;

    if (event != null) {
      titleC.text = event.title;
      descriptionC.text = event.description;
      locationC.text = event.subtitle;
      selectedCategory = event.category;
      selectedLatitude = event.latitude;
      selectedLongitude = event.longitude;

      if (event.imageUrl.startsWith('data:image')) {
        selectedImageData = event.imageUrl;
      }

      if (event.startDateTime != null) {
        final dt = event.startDateTime!;
        dateC.text =
            '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
        startTimeC.text =
            '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }

      if (event.endDateTime != null) {
        final dt = event.endDateTime!;
        endTimeC.text =
            '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
    }

    _initialTitle = titleC.text;
    _initialDescription = descriptionC.text;
    _initialDate = dateC.text;
    _initialStartTime = startTimeC.text;
    _initialEndTime = endTimeC.text;
    _initialLocation = locationC.text;
    _initialCategory = selectedCategory;
    _initialLatitude = selectedLatitude;
    _initialLongitude = selectedLongitude;
    _initialImageData = selectedImageData;
  }

  @override
  void dispose() {
    titleC.dispose();
    descriptionC.dispose();
    dateC.dispose();
    startTimeC.dispose();
    endTimeC.dispose();
    locationC.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate:
          _parseDateTime(dateC.text.trim(), startTimeC.text.trim()) ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (picked == null) return;

    dateC.text =
        '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    setState(() {});
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    startTimeC.text =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    setState(() {});
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    endTimeC.text =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    setState(() {});
  }

  String _generateEventId() {
    return 'event_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _buildDateInfo() {
    final date = dateC.text.trim();
    final start = startTimeC.text.trim();
    final end = endTimeC.text.trim();

    if (date.isEmpty && start.isEmpty && end.isEmpty) return 'Próximamente';

    if (date.isNotEmpty && start.isNotEmpty && end.isNotEmpty) {
      return '$date · $start - $end';
    }

    if (date.isNotEmpty && start.isNotEmpty) {
      return '$date · $start';
    }

    if (date.isNotEmpty) return date;
    if (start.isNotEmpty && end.isNotEmpty) return '$start - $end';
    return start;
  }

  DateTime? _parseDateTime(String date, String time) {
    if (date.trim().isEmpty) return null;

    try {
      final dateParts = date.split('/');
      if (dateParts.length != 3) return null;

      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);

      int hour = 0;
      int minute = 0;

      if (time.trim().isNotEmpty) {
        final timeParts = time.split(':');
        if (timeParts.length == 2) {
          hour = int.parse(timeParts[0]);
          minute = int.parse(timeParts[1]);
        }
      }

      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  String _defaultImageForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'mascletà':
        return 'assets/events_images/mascleta.jpg';
      case 'discomóvil':
        return 'assets/events_images/discomovil.jpg';
      case 'exposición':
        return 'assets/events_images/exposicion.jpg';
      case 'pasacalle':
        return 'assets/events_images/pasacalles.jpg';
      case 'castillo':
        return 'assets/events_images/castillo.jpg';
      case 'ofrenda':
        return 'assets/events_images/ofrenda.jpg';
      case 'verbena':
        return 'assets/events_images/verbena.jpg';
      default:
        return 'assets/events_images/default_event.jpg';
    }
  }

  String _currentEventImage() {
    return selectedImageData ?? _defaultImageForCategory(selectedCategory);
  }

  String _previewImageUrl() {
    return _currentEventImage();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;

    final extension = (file.extension ?? 'png').toLowerCase();
    final mime = switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/png',
    };

    final base64Data = base64Encode(bytes);

    setState(() {
      selectedImageData = 'data:$mime;base64,$base64Data';
    });
  }

  void _clearPickedImage() {
    setState(() {
      selectedImageData = null;
    });
  }

  LatLng get _currentMapPoint {
    if (selectedLatitude != null && selectedLongitude != null) {
      return LatLng(selectedLatitude!, selectedLongitude!);
    }
    return _defaultMapCenter;
  }

  String _selectedCoordsText() {
    if (selectedLatitude == null || selectedLongitude == null) {
      return 'Aún no has seleccionado un punto exacto en el mapa.';
    }

    return 'Lat: ${selectedLatitude!.toStringAsFixed(6)} · Lng: ${selectedLongitude!.toStringAsFixed(6)}';
  }

  Future<void> _pickLocationOnMap() async {
    final picked = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => _MapLocationPickerPage(
          initialPoint: _currentMapPoint,
          category: selectedCategory,
        ),
      ),
    );

    if (picked == null) return;

    setState(() {
      selectedLatitude = picked.latitude;
      selectedLongitude = picked.longitude;

      if (locationC.text.trim().isEmpty) {
        locationC.text = 'Ubicación seleccionada en mapa';
      }
    });
  }

  void _clearPickedLocation() {
    setState(() {
      selectedLatitude = null;
      selectedLongitude = null;
    });
  }

  bool _hasUnsavedChanges() {
    return titleC.text != _initialTitle ||
        descriptionC.text != _initialDescription ||
        dateC.text != _initialDate ||
        startTimeC.text != _initialStartTime ||
        endTimeC.text != _initialEndTime ||
        locationC.text != _initialLocation ||
        selectedCategory != _initialCategory ||
        selectedLatitude != _initialLatitude ||
        selectedLongitude != _initialLongitude ||
        selectedImageData != _initialImageData;
  }

  Future<bool> _confirmDiscardChanges() async {
    if (!_hasUnsavedChanges()) return true;

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salir sin guardar'),
        content: const Text(
          'Tienes cambios sin guardar. ¿Seguro que quieres salir?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    return shouldLeave ?? false;
  }

  Future<void> _handleBackPressed() async {
    final shouldLeave = await _confirmDiscardChanges();
    if (!mounted) return;

    if (shouldLeave) {
      Navigator.pop(context);
    }
  }

  Future<bool> _confirmSave(bool publish) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            publish
                ? (widget.isEditing ? 'Publicar cambios' : 'Publicar evento')
                : (widget.isEditing
                    ? 'Guardar cambios como borrador'
                    : 'Guardar borrador'),
          ),
          content: Text(
            publish
                ? (widget.isEditing
                    ? '¿Seguro que quieres publicar los cambios de este evento?'
                    : '¿Seguro que quieres publicar este evento?')
                : (widget.isEditing
                    ? '¿Seguro que quieres guardar los cambios como borrador?'
                    : '¿Seguro que quieres guardar este evento como borrador?'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(publish ? 'Publicar' : 'Guardar'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _handleSave(bool publish) async {
    final title = titleC.text.trim();
    final description = descriptionC.text.trim();
    final location = locationC.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes introducir al menos el título del evento.'),
        ),
      );
      return;
    }

    final confirmed = await _confirmSave(publish);
    if (!confirmed) return;

    final existing = widget.initialEvent;

    final event = DemoEvent(
      title,
      location.isEmpty
          ? ((selectedLatitude != null && selectedLongitude != null)
              ? 'Punto seleccionado en mapa'
              : 'Ubicación pendiente')
          : location,
      _buildDateInfo(),
      id: existing?.id ?? _generateEventId(),
      imageUrl: _currentEventImage(),
      description: description,
      category: selectedCategory,
      startDateTime: _parseDateTime(
        dateC.text.trim(),
        startTimeC.text.trim(),
      ),
      endDateTime: _parseDateTime(
        dateC.text.trim(),
        endTimeC.text.trim(),
      ),
      status: publish ? 'publicado' : 'borrador',
      createdAt: existing?.createdAt ?? DateTime.now(),
      latitude: selectedLatitude ?? existing?.latitude,
      longitude: selectedLongitude ?? existing?.longitude,
    );

    final eventController = EventScope.of(context);

    if (widget.isEditing) {
      await eventController.updateEvent(event);
    } else {
      await eventController.createEvent(event);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEditing
              ? (publish
                  ? 'Evento actualizado y publicado.'
                  : 'Evento actualizado como borrador.')
              : (publish
                  ? 'Evento publicado correctamente.'
                  : 'Evento guardado como borrador.'),
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBackPressed();
      },
      child: Scaffold(
        backgroundColor: yellow,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackPressed,
          ),
          backgroundColor: const Color(0xFF8B0000),
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(widget.isEditing ? 'Editar evento' : 'Crear evento'),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 950;

              if (wide) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _formCard(context),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: _previewCard(),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _formCard(context),
                    const SizedBox(height: 16),
                    _previewCard(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _formCard(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFBF5),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos del evento',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF8B0000),
              ),
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: titleC,
              label: 'Título del evento',
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: descriptionC,
              label: 'Descripción',
              maxLines: 5,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 520;

                if (isNarrow) {
                  return Column(
                    children: [
                      _buildPickerField(
                        controller: dateC,
                        label: 'Fecha',
                        hint: 'dd/mm/aaaa',
                        icon: Icons.calendar_today,
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPickerField(
                              controller: startTimeC,
                              label: 'Hora inicio',
                              hint: '18:00',
                              icon: Icons.access_time,
                              onTap: _pickStartTime,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPickerField(
                              controller: endTimeC,
                              label: 'Hora fin',
                              hint: '20:00',
                              icon: Icons.access_time_filled,
                              onTap: _pickEndTime,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: _buildPickerField(
                        controller: dateC,
                        label: 'Fecha',
                        hint: 'dd/mm/aaaa',
                        icon: Icons.calendar_today,
                        onTap: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPickerField(
                        controller: startTimeC,
                        label: 'Hora inicio',
                        hint: '18:00',
                        icon: Icons.access_time,
                        onTap: _pickStartTime,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPickerField(
                        controller: endTimeC,
                        label: 'Hora fin',
                        hint: '20:00',
                        icon: Icons.access_time_filled,
                        onTap: _pickEndTime,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'Categoría',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: _inputDecoration(),
              items: categories
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => selectedCategory = value);
              },
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: locationC,
              label: 'Ubicación',
              hint: 'Ej. Plaza del Ayuntamiento',
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFEFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF6ED6E7),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.map_outlined),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Ubicación exacta en mapa',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (selectedLatitude != null && selectedLongitude != null)
                        TextButton.icon(
                          onPressed: _clearPickedLocation,
                          icon: const Icon(Icons.clear),
                          label: const Text('Quitar'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: _currentMapPoint,
                          initialZoom: (selectedLatitude != null &&
                                  selectedLongitude != null)
                              ? 15
                              : 13,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.drag |
                                InteractiveFlag.pinchZoom |
                                InteractiveFlag.doubleTapZoom,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.corfalles.app',
                          ),
                          if (selectedLatitude != null &&
                              selectedLongitude != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(
                                      selectedLatitude!, selectedLongitude!),
                                  width: 44,
                                  height: 44,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: eventMarkerColor(selectedCategory),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                    child: Icon(
                                      eventMarkerIcon(selectedCategory),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _selectedCoordsText(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3A2B2B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B4DB3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _pickLocationOnMap,
                      icon: const Icon(Icons.place),
                      label: const Text(
                        'Seleccionar en mapa',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFEFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF6ED6E7),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.image_outlined),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Imagen o banner del evento'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B4DB3),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload_file, size: 20),
                    label: const Text(
                      'Subir',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (selectedImageData != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF00B050)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Imagen personalizada seleccionada',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _clearPickedImage,
                    icon: const Icon(Icons.clear),
                    label: const Text('Quitar'),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFFF4EEE7),
            //     borderRadius: BorderRadius.circular(14),
            //     border: Border.all(
            //       color: Colors.black.withOpacity(0.08),
            //     ),
            //   ),
            //   child: const Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               'Publicar directamente',
            //               style: TextStyle(
            //                 fontWeight: FontWeight.w800,
            //                 fontSize: 16,
            //                 color: Color(0xFF281C22),
            //               ),
            //             ),
            //             SizedBox(height: 4),
            //             Text(
            //               'Si no, se guardará como borrador',
            //               style: TextStyle(
            //                 fontSize: 13,
            //                 color: Colors.black54,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       // Switch(
            //       //   value: publishNow,
            //       //   activeColor: Colors.white,
            //       //   activeTrackColor: Color(0xFF00B050),
            //       //   inactiveThumbColor: Color(0xFF8B6F6F),
            //       //   inactiveTrackColor: Color(0xFFD8C8C8),
            //       //   onChanged: (value) {
            //       //     setState(() => publishNow = value);
            //       //   },
            //       // ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 700;

                final draftButton = SizedBox(
                  width: isMobile ? double.infinity : 240,
                  height: 58,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B4DB3),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => _handleSave(false),
                    icon: const Icon(Icons.save_outlined, size: 24),
                    label: const Text(
                      'Guardar borrador',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );

                final publishButton = SizedBox(
                  width: isMobile ? double.infinity : 220,
                  height: 58,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B050),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => _handleSave(true),
                    icon: const Icon(Icons.publish, size: 24),
                    label: const Text(
                      'Publicar',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );

                if (isMobile) {
                  return Column(
                    children: [
                      draftButton,
                      const SizedBox(height: 12),
                      publishButton,
                    ],
                  );
                }

                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    draftButton,
                    publishButton,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _previewCard() {
    final previewTitle =
        titleC.text.trim().isEmpty ? 'Título del evento' : titleC.text.trim();

    final previewLocation = locationC.text.trim().isEmpty
        ? 'Ubicación del evento'
        : locationC.text.trim();

    final previewDate =
        dateC.text.trim().isEmpty ? 'Fecha pendiente' : dateC.text.trim();

    final previewStartTime = startTimeC.text.trim().isEmpty
        ? 'Hora pendiente'
        : startTimeC.text.trim();

    final previewDescription = descriptionC.text.trim().isEmpty
        ? 'Aquí se mostrará una vista previa de la descripción del evento.'
        : descriptionC.text.trim();

    return Card(
      color: const Color(0xFFFFFBF5),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3ECE3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Vista previa',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF8B0000),
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    EventImage(
                      imageUrl: _previewImageUrl(),
                      fit: BoxFit.cover,
                      errorFallback: Container(
                        color: Colors.black12,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    Container(color: Colors.black.withOpacity(0.18)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        color: const Color(0xFF0B4DB3),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          previewTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
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
                _previewBadge(
                  icon: Icons.category,
                  label: selectedCategory,
                  color: const Color(0xFF0B4DB3),
                ),
                // _previewBadge(
                //   icon: publishNow ? Icons.public : Icons.save,
                //   label: publishNow ? 'Publicado' : 'Borrador',
                //   color: publishNow
                //       ? const Color(0xFF00B050)
                //       : const Color(0xFF8B0000),
                // ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF3ECE3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.black.withOpacity(0.10),
                ),
              ),
              child: Column(
                children: [
                  _previewInfoRow(
                    icon: Icons.place,
                    text: previewLocation,
                  ),
                  const SizedBox(height: 12),
                  _previewInfoRow(
                    icon: Icons.calendar_today,
                    text: endTimeC.text.trim().isNotEmpty
                        ? '$previewDate · $previewStartTime - ${endTimeC.text.trim()}'
                        : '$previewDate · $previewStartTime',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (selectedLatitude != null && selectedLongitude != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3ECE3),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.10),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.my_location,
                      color: Color(0xFF8B0000),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Ubicación exacta seleccionada en mapa',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0E8DE),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.black.withOpacity(0.10),
                ),
              ),
              child: Text(
                previewDescription,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  height: 1.5,
                  color: Color(0xFF3A2B2B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _previewBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
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
          Icon(icon, size: 17, color: Colors.white),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewInfoRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF8B0000)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: _inputDecoration(
        label: label,
        hint: hint,
      ),
    );
  }

  Widget _buildPickerField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: _inputDecoration(
        label: label,
        hint: hint,
      ).copyWith(
        suffixIcon: Icon(icon),
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? label,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFFFFEFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF6ED6E7),
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF2AB6D2),
          width: 2,
        ),
      ),
    );
  }
}

class _MapLocationPickerPage extends StatefulWidget {
  final LatLng initialPoint;
  final String category;

  const _MapLocationPickerPage({
    required this.initialPoint,
    required this.category,
  });

  @override
  State<_MapLocationPickerPage> createState() => _MapLocationPickerPageState();
}

class _MapLocationPickerPageState extends State<_MapLocationPickerPage> {
  late LatLng pickedPoint;

  @override
  void initState() {
    super.initState();
    pickedPoint = widget.initialPoint;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar ubicación'),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: widget.initialPoint,
                initialZoom: 15,
                onTap: (_, point) {
                  setState(() {
                    pickedPoint = point;
                  });
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
                      point: pickedPoint,
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: eventMarkerColor(widget.category),
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
                          eventMarkerIcon(widget.category),
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFFFFBF5),
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: 6),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Lat: ${pickedPoint.latitude.toStringAsFixed(6)}\nLng: ${pickedPoint.longitude.toStringAsFixed(6)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B4DB3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, pickedPoint),
                      child: const Text(
                        'Usar ubicación',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
