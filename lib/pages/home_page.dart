import 'package:flutter/material.dart';
import '../models/demo_event.dart';
import '../widgets/search_bar.dart';
import '../widgets/hero_banner.dart';
import '../widgets/event_card.dart';
import 'event_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

    const heroEvent = DemoEvent(
      'Fallas 2026',
      'Eventos oficiales y destacados',
      'Próximamente',
      imageUrl:
          'https://images.unsplash.com/photo-1543799382-9d85b0b8d3a7?auto=format&fit=crop&w=1600&q=80',
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
                      onChanged: (_) {},
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
                      'Cercanos a ti',
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

                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final e = demoEvents[index];
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
                      childCount: demoEvents.length,
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
