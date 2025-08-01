import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setDefaults(const {'events_data': '[]'});
    await remoteConfig.fetchAndActivate();

    final jsonString = remoteConfig.getString('events_data');
    final decoded = jsonDecode(jsonString) as List;
    final loadedEvents = decoded.map((e) => Event.fromJson(e)).toList();

    setState(() {
      events = loadedEvents;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Event>>{};
    for (final event in events) {
      final dateKey = DateFormat.yMMMd().format(event.startDate);
      grouped.putIfAbsent(dateKey, () => []).add(event);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    ...entry.value
                        .map((event) => EventCard(event: event))
                        .toList(),
                    const SizedBox(height: 12),
                  ],
                );
              }).toList(),
            ),
    );
  }
}

class Event {
  final String title;
  final String image;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String address;

  Event({
    required this.title,
    required this.image,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.address,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    title: json['title'],
    image: json['image'],
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    description: json['description'],
    address: json['address'],
  );
}

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EventDetailPage(event: event)),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  event.image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(DateFormat.MMMMd().format(event.startDate)),
                    Text('Entrance: ${timeFormat.format(event.startDate)}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventDetailPage extends StatelessWidget {
  final Event event;
  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MMMM d, y – h:mm a');

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(event.image, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text(
              'Beginning: ${df.format(event.startDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Ending: ${df.format(event.endDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            MarkdownBody(
              data: event.description.replaceAll(r'\\n', '  \n'),
              onTapLink: (text, href, title) async {
                if (href != null && await canLaunchUrl(Uri.parse(href))) {
                  await launchUrl(
                    Uri.parse(href),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              styleSheet: MarkdownStyleSheet.fromTheme(
                Theme.of(context),
              ).copyWith(p: const TextStyle(fontSize: 15)),
            ),

            const SizedBox(height: 16),
            Text(
              'Address: ${event.address}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
