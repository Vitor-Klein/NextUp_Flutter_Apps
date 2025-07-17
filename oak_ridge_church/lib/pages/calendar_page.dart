import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class EventItem {
  final String title;
  final String time;
  final String location;

  EventItem({required this.title, required this.time, required this.location});

  factory EventItem.fromMap(Map<String, dynamic> map) {
    return EventItem(
      title: map['title'] ?? '',
      time: map['time'] ?? '',
      location: map['location'] ?? '',
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<EventItem>> _events = {};

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  void initState() {
    super.initState();
    _loadEventsFromRemoteConfig();
  }

  Future<void> _loadEventsFromRemoteConfig() async {
    try {
      final rawJson = _remoteConfig.getString('calendar_events');
      final decoded = jsonDecode(rawJson);
      final eventsList = decoded['events'] as List;

      final parsedEvents = <DateTime, List<EventItem>>{};

      for (final item in eventsList) {
        final date = DateTime.parse(item['date']);
        final items = (item['items'] as List)
            .map((e) => EventItem.fromMap(e))
            .toList();

        parsedEvents[_normalizeDate(date)] = items;
      }

      setState(() => _events = parsedEvents);
    } catch (e) {
      debugPrint('Erro ao carregar eventos: $e');
    }
  }

  List<EventItem> _getEventsForDay(DateTime day) {
    return _events[_normalizeDate(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _selectedDay != null
        ? _getEventsForDay(_selectedDay!)
        : [];

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TableCalendar<EventItem>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: _getEventsForDay,
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedDay != null && selectedEvents.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: selectedEvents.length,
                  itemBuilder: (context, index) {
                    final event = selectedEvents[index];
                    return ListTile(
                      leading: const Icon(Icons.event_note),
                      title: Text(event.title),
                      subtitle: Text('${event.time} - ${event.location}'),
                    );
                  },
                ),
              ),
            if (_selectedDay != null && selectedEvents.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: Text(
                  'Nenhum evento para este dia.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
