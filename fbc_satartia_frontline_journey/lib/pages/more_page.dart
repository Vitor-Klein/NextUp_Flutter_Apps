import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  bool showScheduleButton = false;

  @override
  void initState() {
    super.initState();
    _loadRemoteConfig();
  }

  Future<void> _loadRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    setState(() {
      showScheduleButton = remoteConfig.getBool('show_schedule_button');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: Column(
        children: [
          // Header com imagem
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Image.asset(
              'assets/header.png',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 30),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'More Options',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Botão de Messages
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/messages');
              },
              icon: const Icon(Icons.message),
              label: const Text('Messages', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Botão de agendamento condicional
          if (showScheduleButton)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/schedule_an_appointment');
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text(
                  'Schedule an Appointment',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
