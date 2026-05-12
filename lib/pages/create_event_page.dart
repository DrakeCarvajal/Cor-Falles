import 'package:flutter/material.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

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

  String selectedCategory = 'Mascletà';
  bool publishNow = false;

  final List<String> categories = [
    'Mascletà',
    'Ofrenda',
    'Castillo',
    'Verbena',
    'Discomóvil',
    'Exposición',
    'Pasacalle',
    'Otro',
  ];

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

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

    return Scaffold(
      backgroundColor: yellow,
      appBar: AppBar(
        title: const Text('Crear evento'),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
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
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    controller: dateC,
                    label: 'Fecha',
                    hint: 'dd/mm/aaaa',
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildField(
                    controller: startTimeC,
                    label: 'Hora inicio',
                    hint: '18:00',
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildField(
                    controller: endTimeC,
                    label: 'Hora fin',
                    hint: '20:00',
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Subida de imagen pendiente de implementar'),
                        ),
                      );
                    },
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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4EEE7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Publicar directamente',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Color(0xFF281C22),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Si no, se guardará como borrador',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: publishNow,
                    activeColor: Colors.white,
                    activeTrackColor: Color(0xFF00B050),
                    inactiveThumbColor: Color(0xFF8B6F6F),
                    inactiveTrackColor: Color(0xFFD8C8C8),
                    onChanged: (value) {
                      setState(() => publishNow = value);
                    },
                  ),
                ],
              ),
            ),
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Evento guardado como borrador')),
                      );
                    },
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Evento publicado (demo)')),
                      );
                    },
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
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade200,
                      Colors.red.shade300,
                      Colors.deepOrange.shade400,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: Colors.black.withOpacity(0.18)),
                    const Center(
                      child: Icon(
                        Icons.image,
                        size: 70,
                        color: Colors.white70,
                      ),
                    ),
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
                _previewBadge(
                  icon: publishNow ? Icons.public : Icons.save,
                  label: publishNow ? 'Publicado' : 'Borrador',
                  color: publishNow
                      ? const Color(0xFF00B050)
                      : const Color(0xFF8B0000),
                ),
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
                    text: '$previewDate · $previewStartTime',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
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
