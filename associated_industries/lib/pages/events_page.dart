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

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<EventItem>> _events = {};

  bool _loading = true;
  String? _error;

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Garantir que o RC está pronto e puxar valores mais recentes
      await _remoteConfig.fetchAndActivate();
      await _loadEventsFromRemoteConfig();
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar eventos: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadEventsFromRemoteConfig() async {
    final rawJson = _remoteConfig.getString('calendar_events');

    if (rawJson.isEmpty) {
      // Opcional: defina um default em código ou no console do RC
      setState(() {
        _events = {};
      });
      return;
    }

    final decoded = jsonDecode(rawJson);
    final eventsList = (decoded['events'] as List?) ?? [];

    final parsedEvents = <DateTime, List<EventItem>>{};

    for (final item in eventsList) {
      // Aceita "YYYY-MM-DD" (local) — evita parse como UTC com “Z”
      final dateStr = (item['date'] ?? '').toString();
      if (dateStr.isEmpty) continue;

      final parts = dateStr
          .split('-')
          .map((e) => int.tryParse(e) ?? 1)
          .toList();
      if (parts.length < 3) continue;
      final date = DateTime(parts[0], parts[1], parts[2]);

      final itemsRaw = (item['items'] as List?) ?? [];
      final items = itemsRaw.map((e) => EventItem.fromMap(e)).toList();

      parsedEvents[_normalizeDate(date)] = items;
    }

    setState(() => _events = parsedEvents);
  }

  List<EventItem> _getEventsForDay(DateTime day) {
    return _events[_normalizeDate(day)] ?? [];
  }

  int _getEventCountForDay(DateTime day) {
    return _getEventsForDay(day).length;
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _selectedDay != null
        ? _getEventsForDay(_selectedDay!)
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        actions: [
          IconButton(
            tooltip: 'Hoje',
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = _normalizeDate(DateTime.now());
              });
            },
          ),
          IconButton(
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
            onPressed: _initAndLoad,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _initAndLoad,
        child: _loading
            ? const _Loading()
            : _error != null
            ? _ErrorState(message: _error!, onRetry: _initAndLoad)
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TableCalendar<EventItem>(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2035, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      eventLoader: _getEventsForDay,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      calendarStyle: const CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Mostra “badge” com contagem de eventos no dia
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          final count = _getEventCountForDay(day);
                          if (count == 0) return const SizedBox.shrink();
                          return Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: 4,
                                bottom: 4,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade600,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _DayHeader(day: _selectedDay, total: selectedEvents.length),
                    const SizedBox(height: 8),
                    Expanded(
                      child: selectedEvents.isEmpty
                          ? const _EmptyState()
                          : ListView.separated(
                              itemCount: selectedEvents.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final event = selectedEvents[index];
                                return Card(
                                  elevation: 1.5,
                                  clipBehavior: Clip.antiAlias,
                                  child: ListTile(
                                    leading: const Icon(Icons.event_note),
                                    title: Text(
                                      event.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${event.time} • ${event.location}',
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(),
      ),
    );
    // (Se quiser shimmer depois, é aqui que troca)
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 32),
        child: Text(
          'Nenhum evento para este dia.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  final DateTime? day;
  final int total;

  const _DayHeader({required this.day, required this.total});

  @override
  Widget build(BuildContext context) {
    final text = day == null
        ? 'Selecione um dia'
        : 'Eventos de ${_fmt(day!)} ($total)';
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  String _fmt(DateTime d) {
    // Simples e sem dependência extra: dd/MM/yyyy
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year;
    return '$dd/$mm/$yyyy';
  }
}
