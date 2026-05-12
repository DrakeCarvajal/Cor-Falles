import 'package:flutter/material.dart';

import '../models/demo_event.dart';
import '../widgets/event_card.dart';

class EventDetailPage extends StatelessWidget {
  final DemoEvent event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

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
            final wide = c.maxWidth >= 900;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Card(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: c.maxHeight,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            event.subtitle,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(event.dateInfo),
                          const SizedBox(height: 16),
                          const Text(
                            'Descripción (placeholder)\n\nAquí irá el texto del evento, horario, ubicación, etc.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (wide) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const Text('También podría interesarte',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView(
                            children: demoEvents
                                .where((x) => x.title != event.title)
                                .map((e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: EventCardMock(
                                        title: e.title,
                                        subtitle: e.subtitle,
                                        imageUrl: e.imageUrl,
                                        height:
                                            120, // ✅ para que se vean en la lista derecha
                                        onTap: () => Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  EventDetailPage(event: e)),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
