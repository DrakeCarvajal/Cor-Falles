import 'package:flutter/material.dart';

import '../models/demo_event.dart';
import '../provider/auth_provider.dart';
import '../widgets/event_card.dart';
import 'create_event_page.dart';
import 'event_detail_page.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

    final auth = AuthScope.of(context);
    final canCreate = auth.canCreateEvents;

    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 900;

        return Scaffold(
          backgroundColor: yellow,
          appBar: AppBar(
            title: const Text('Eventos'),
            backgroundColor: Colors.transparent,
          ),

          // Solo en móvil
          floatingActionButton: !wide && canCreate
              ? FloatingActionButton(
                  backgroundColor: const Color(0xFF0B4DB3),
                  foregroundColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateEventPage(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: wide
                ? _DesktopEventsLayout(
                    canCreate: canCreate,
                  )
                : const _MobileEventsLayout(),
          ),
        );
      },
    );
  }
}

class _DesktopEventsLayout extends StatelessWidget {
  final bool canCreate;

  const _DesktopEventsLayout({
    required this.canCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eventos',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF8B0000),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _calendarPlaceholder(),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Próximos eventos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                        itemCount: demoEvents.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final e = demoEvents[index];
                          return SizedBox(
                            height: 120,
                            child: EventCardMock(
                              title: e.title,
                              subtitle: e.subtitle,
                              imageUrl: e.imageUrl,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EventDetailPage(event: e),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (canCreate) ...[
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              height: 58,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B4DB3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateEventPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 28),
                label: const Text(
                  'Crear evento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MobileEventsLayout extends StatelessWidget {
  const _MobileEventsLayout();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text(
          'Eventos',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Color(0xFF8B0000),
          ),
        ),
        const SizedBox(height: 12),
        _calendarPlaceholder(),
        const SizedBox(height: 16),
        const Text(
          'Próximos eventos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        ...demoEvents.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              height: 180,
              child: EventCardMock(
                title: e.title,
                subtitle: e.subtitle,
                imageUrl: e.imageUrl,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailPage(event: e),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _calendarPlaceholder() {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Container(
      height: 420,
      alignment: Alignment.center,
      child: Text(
        'Calendario (placeholder)\n\nAquí luego puedes integrar TableCalendar',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black.withOpacity(0.7),
          fontSize: 16,
        ),
      ),
    ),
  );
}
