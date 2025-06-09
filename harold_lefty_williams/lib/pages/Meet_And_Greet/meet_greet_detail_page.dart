import 'package:flutter/material.dart';

class MeetGreetDetailPage extends StatefulWidget {
  final Map<String, String> event;

  const MeetGreetDetailPage({super.key, required this.event});

  @override
  State<MeetGreetDetailPage> createState() => _MeetGreetDetailPageState();
}

class _MeetGreetDetailPageState extends State<MeetGreetDetailPage> {
  final Color primaryDark = const Color(0xFF5280d5);
  final Color backgroundColor = const Color(0xFFF5F5F5);

  TimeOfDay? _selectedTime;

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primaryDark,
            colorScheme: ColorScheme.light(primary: primaryDark),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scheduled time: ${picked.format(context)}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text(event['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📅 ${event['date']}', style: const TextStyle(fontSize: 16)),
            Text(
              '📍 ${event['location']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(event['description']!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _selectTime,
              icon: const Icon(Icons.access_time),
              label: const Text('Select Time'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (_selectedTime != null) ...[
              const SizedBox(height: 16),
              Text(
                'You scheduled it at: ${_selectedTime!.format(context)}',
                style: TextStyle(color: primaryDark, fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
