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
  String? _name;
  String? _email;

  void _openScheduleDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Schedule Appointment'),
          content: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Please enter your name'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return 'Please enter your email';
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          return emailRegex.hasMatch(value)
                              ? null
                              : 'Invalid email address';
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: primaryDark,
                                  colorScheme: ColorScheme.light(
                                    primary: primaryDark,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null) {
                            setModalState(() {
                              _selectedTime = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time),
                        label: const Text('Select Time'),
                      ),
                      if (_selectedTime != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Selected time: ${_selectedTime!.format(context)}',
                          style: TextStyle(color: primaryDark),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate() && _selectedTime != null) {
                  setState(() {
                    _name = nameController.text.trim();
                    _email = emailController.text.trim();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Scheduled for $_name at ${_selectedTime!.format(context)}\nEmail: $_email',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill all fields and select a time.',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Schedule'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text(event['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
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
              onPressed: _openScheduleDialog,
              icon: const Icon(Icons.calendar_today),
              label: const Text('Schedule Time'),
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
            if (_name != null && _selectedTime != null) ...[
              const SizedBox(height: 24),
              Text(
                'You scheduled for $_name at ${_selectedTime!.format(context)}\nEmail: $_email',
                style: TextStyle(color: primaryDark, fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
