import 'package:flutter/material.dart';
import 'schedule_an_appointment_detail_page.dart';

class ScheduleAnAppointmentPage extends StatelessWidget {
  const ScheduleAnAppointmentPage({super.key});
  final Color primaryDark = const Color(0xFF5280d5);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color cardColor = const Color(0xFFd4def7);

  static const List<Map<String, String>> events = [
    {
      'title': 'Fan Meet - São Paulo',
      'date': 'June 15, 2025',
      'location': 'Shopping Eldorado',
      'description': 'Autograph signing and photo session with fans.',
      'startTime': '5:00 PM CST',
    },
    {
      'title': 'Meet & Greet - Rio de Janeiro',
      'date': 'June 22, 2025',
      'location': 'BarraShopping',
      'description': 'Exclusive chat with guests and giveaways!',
      'startTime': '3:30 PM CST',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: const Text('Meet & Greet')),
      body: events.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 64,
                    color: primaryDark.withOpacity(0.6),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum evento disponível no momento.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ScheduleAnAppointmentDetailPage(event: event),
                      ),
                    );
                  },
                  child: Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: primaryDark.withOpacity(0.3)),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('📅 ${event['date']}'),
                          Text('📍 ${event['location']}'),
                          Text('🕔 ${event['startTime']}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
