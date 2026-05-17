import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/demo_event.dart';
import '../provider/auth_provider.dart';
import '../provider/event_provider.dart';
import '../widgets/event_card.dart';
import 'create_event_page.dart';
import 'event_detail_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _normalizeDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFF7D96B);

    final auth = AuthScope.of(context);
    final canCreate = auth.canCreateEvents;
    final events = EventScope.of(context).visibleEvents;

    final selectedDayEvents = _selectedDay == null
        ? <DemoEvent>[]
        : EventScope.of(context).eventsForDate(_selectedDay!);

    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 900;

        return Scaffold(
          backgroundColor: yellow,
          appBar: AppBar(
            title: const Text('Eventos'),
            backgroundColor: Colors.transparent,
          ),
          body: wide
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: _DesktopEventsLayout(
                    canCreate: canCreate,
                    events: events,
                    selectedDay: _selectedDay,
                    selectedDayEvents: selectedDayEvents,
                    focusedDay: _focusedDay,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = _normalizeDate(selectedDay);
                        _focusedDay = focusedDay;
                      });
                    },
                  ),
                )
              : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _MobileEventsLayout(
                        events: events,
                        selectedDay: _selectedDay,
                        selectedDayEvents: selectedDayEvents,
                        focusedDay: _focusedDay,
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = _normalizeDate(selectedDay);
                            _focusedDay = focusedDay;
                          });
                        },
                      ),
                    ),
                    if (canCreate)
                      Positioned(
                        right: 16,
                        bottom: 24,
                        child: SizedBox(
                          width: 68,
                          height: 68,
                          child: FloatingActionButton(
                            backgroundColor: const Color(0xFF0B4DB3),
                            foregroundColor: Colors.white,
                            elevation: 6,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreateEventPage(),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.add,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class _DesktopEventsLayout extends StatelessWidget {
  final bool canCreate;
  final List<DemoEvent> events;
  final DateTime? selectedDay;
  final List<DemoEvent> selectedDayEvents;
  final DateTime focusedDay;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  const _DesktopEventsLayout({
    required this.canCreate,
    required this.events,
    required this.selectedDay,
    required this.selectedDayEvents,
    required this.focusedDay,
    required this.onDaySelected,
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
                flex: 7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _calendarCard(
                        context: context,
                        selectedDay: selectedDay,
                        focusedDay: focusedDay,
                        events: events,
                        onDaySelected: onDaySelected,
                      ),
                      const SizedBox(height: 16),
                      _selectedDayEventsCard(
                        context: context,
                        selectedDay: selectedDay,
                        events: selectedDayEvents,
                        isMobile: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Próximos eventos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                        itemCount: events.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final e = events[index];
                          return SizedBox(
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
  final List<DemoEvent> events;
  final DateTime? selectedDay;
  final List<DemoEvent> selectedDayEvents;
  final DateTime focusedDay;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  const _MobileEventsLayout({
    required this.events,
    required this.selectedDay,
    required this.selectedDayEvents,
    required this.focusedDay,
    required this.onDaySelected,
  });

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
        _calendarCard(
          context: context,
          selectedDay: selectedDay,
          focusedDay: focusedDay,
          events: events,
          onDaySelected: onDaySelected,
        ),
        const SizedBox(height: 16),
        _selectedDayEventsCard(
          context: context,
          selectedDay: selectedDay,
          events: selectedDayEvents,
          isMobile: true,
        ),
        const SizedBox(height: 16),
        const Text(
          'Próximos eventos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        ...events.map(
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

Widget _calendarCard({
  required BuildContext context,
  required DateTime? selectedDay,
  required DateTime focusedDay,
  required List<DemoEvent> events,
  required void Function(DateTime selectedDay, DateTime focusedDay)
      onDaySelected,
}) {
  bool hasEventsForDay(DateTime day) {
    return events.any((e) {
      final dt = e.startDateTime;
      if (dt == null) return false;
      return dt.year == day.year && dt.month == day.month && dt.day == day.day;
    });
  }

  return Card(
    color: const Color(0xFFFFFBF5),
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: TableCalendar<DemoEvent>(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: const Color(0xFF8B0000).withOpacity(0.35),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Color(0xFF0B4DB3),
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Color(0xFF8B0000),
            shape: BoxShape.circle,
          ),
          markersMaxCount: 1,
        ),
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        eventLoader: (day) {
          return events.where((e) {
            final dt = e.startDateTime;
            if (dt == null) return false;
            return dt.year == day.year &&
                dt.month == day.month &&
                dt.day == day.day;
          }).toList();
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final hasEvents = hasEventsForDay(day);
            if (!hasEvents) return null;

            return Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF8B0000).withOpacity(0.35),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text('${day.day}'),
            );
          },
        ),
      ),
    ),
  );
}

Widget _selectedDayEventsCard({
  required BuildContext context,
  required DateTime? selectedDay,
  required List<DemoEvent> events,
  required bool isMobile,
}) {
  final title = selectedDay == null
      ? 'Eventos del día'
      : 'Eventos del ${selectedDay.day.toString().padLeft(2, '0')}/${selectedDay.month.toString().padLeft(2, '0')}/${selectedDay.year}';

  const desktopColumns = 2;
  const desktopCardHeight = 145.0;
  const desktopSpacing = 12.0;
  const maxVisibleItems = 4;

  final visibleItems =
      events.length > maxVisibleItems ? maxVisibleItems : events.length;
  final visibleRows = visibleItems == 0
      ? 0
      : ((visibleItems + desktopColumns - 1) ~/ desktopColumns);

  final desktopGridHeight = visibleRows == 0
      ? 0.0
      : (visibleRows * desktopCardHeight) +
          ((visibleRows - 1) * desktopSpacing);

  return Card(
    color: const Color(0xFFFFFBF5),
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF8B0000),
            ),
          ),
          const SizedBox(height: 12),
          if (events.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No hay eventos para el día seleccionado.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else if (isMobile)
            Column(
              children: events
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        height: 145,
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
                  )
                  .toList(),
            )
          else if (events.length <= 4)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 185,
              ),
              itemBuilder: (context, index) {
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
            )
          else
            SizedBox(
              height: desktopGridHeight,
              child: GridView.builder(
                itemCount: events.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 165,
                ),
                itemBuilder: (context, index) {
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
              ),
            ),
        ],
      ),
    ),
  );
}
