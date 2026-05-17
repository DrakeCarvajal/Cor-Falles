import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/demo_event.dart';

class EventController extends ChangeNotifier {
  static const _storageKey = 'cor_falles_events';

  List<DemoEvent> _events = [];
  bool _loaded = false;

  List<DemoEvent> get allEvents => List.unmodifiable(_events);

  List<DemoEvent> get visibleEvents {
    final now = DateTime.now();

    final list = _events.where((e) {
      if (e.status == 'eliminado') return false;

      final referenceDate = e.endDateTime ?? e.startDateTime;

      if (referenceDate == null)
        return true; // si no tiene fecha, se sigue mostrando

      return referenceDate.isAfter(now);
    }).toList();

    list.sort((a, b) {
      final aDate = a.startDateTime ?? DateTime(2100);
      final bDate = b.startDateTime ?? DateTime(2100);
      return aDate.compareTo(bDate);
    });

    return list;
  }

  List<DemoEvent> get publishedEvents {
    final now = DateTime.now();

    final list = _events.where((e) {
      if (e.status != 'publicado') return false;

      final referenceDate = e.endDateTime ?? e.startDateTime;

      if (referenceDate == null)
        return true; // si no tiene fecha, se sigue mostrando

      return referenceDate.isAfter(now);
    }).toList();

    list.sort((a, b) {
      final aDate = a.startDateTime ?? DateTime(2100);
      final bDate = b.startDateTime ?? DateTime(2100);
      return aDate.compareTo(bDate);
    });

    return list;
  }

  EventController() {
    loadEvents();
  }

  Future<void> loadEvents() async {
    if (_loaded) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw == null || raw.trim().isEmpty) {
      _events = List.from(seedDemoEvents);
      await _saveEvents();
    } else {
      _events = DemoEvent.listFromJsonString(raw);
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, DemoEvent.listToJsonString(_events));
  }

  Future<void> createEvent(DemoEvent event) async {
    _events.add(event);
    await _saveEvents();
    notifyListeners();
  }

  Future<void> updateEvent(DemoEvent updatedEvent) async {
    final index = _events.indexWhere((e) => e.id == updatedEvent.id);
    if (index == -1) return;

    _events[index] = updatedEvent;
    await _saveEvents();
    notifyListeners();
  }

  Future<void> softDeleteEvent(String eventId) async {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index == -1) return;

    _events[index] = _events[index].copyWith(status: 'eliminado');
    await _saveEvents();
    notifyListeners();
  }

  DemoEvent? getById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<DemoEvent> eventsForDate(DateTime day) {
    return visibleEvents.where((event) {
      final dt = event.startDateTime;
      if (dt == null) return false;
      return dt.year == day.year && dt.month == day.month && dt.day == day.day;
    }).toList();
  }

  List<DemoEvent> mapEvents() {
    return visibleEvents
        .where((e) => e.latitude != null && e.longitude != null)
        .toList();
  }

  Future<void> resetToSeedEvents() async {
    _events = List.from(seedDemoEvents);
    await _saveEvents();
    notifyListeners();
  }
}

class EventScope extends InheritedNotifier<EventController> {
  const EventScope({
    super.key,
    required EventController notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static EventController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<EventScope>();
    assert(scope != null, 'No se encontró EventScope en el árbol de widgets.');
    return scope!.notifier!;
  }
}
