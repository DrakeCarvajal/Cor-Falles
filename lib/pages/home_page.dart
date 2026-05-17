import 'package:flutter/material.dart';
import '../models/demo_event.dart';
import '../widgets/search_bar.dart';
import '../widgets/hero_banner.dart';
import '../widgets/event_card.dart';
import '../provider/event_provider.dart';
import 'event_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _query = '';

  List<DemoEvent> _applySearch(List<DemoEvent> events) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return events;

    return events.where((e) {
      return e.title.toLowerCase().contains(q) ||
          e.subtitle.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);
    final allEvents = EventScope.of(context).publishedEvents;
    final events = _applySearch(allEvents);

    const heroEvent = DemoEvent(
      'Fallas 2026',
      'Eventos oficiales y destacados',
      'Próximamente',
      id: 'hero_fallas_2026',
      imageUrl: 'assets/events_images/fallas.jpg',
      description: 'Evento destacado principal de Cor Falles.',
      category: 'Otro',
      status: 'publicado',
    );

    return Scaffold(
      backgroundColor: yellow,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    SearchBarField(
                      hint: 'Buscar eventos...',
                      onChanged: (value) {
                        setState(() {
                          _query = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    HeroBanner(
                      height: 350, // más pequeño
                      title: 'FALLAS\n2026',
                      buttonText: 'Más detalles...',
                      imageUrl: heroEvent.imageUrl,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailPage(event: heroEvent),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Próximos eventos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0033A0),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.crossAxisExtent;
                  final cols = w >= 900 ? 2 : 1;

                  if (events.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Center(
                          child: Text(
                            _query.trim().isEmpty
                                ? 'No hay eventos publicados todavía.'
                                : 'No hay resultados para la búsqueda.',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final e = events[index];
                        return EventCardMock(
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
                        );
                      },
                      childCount: events.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: cols == 2 ? 1.9 : 2.2,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
