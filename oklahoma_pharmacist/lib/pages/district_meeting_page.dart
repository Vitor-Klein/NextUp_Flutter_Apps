import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DistrictMeetingPage extends StatelessWidget {
  const DistrictMeetingPage({super.key});

  static const String meetingUrl = 'https://opha.com/district-meetings/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('District Meeting'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Imagem grande clicável
            Material(
              color: Colors.transparent,
              elevation: 2,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: _openMeetingLink,
                child: AspectRatio(
                  aspectRatio: 12 / 9,
                  child: Ink.image(
                    image: const AssetImage('assets/save_date.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Botão abaixo da imagem
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openMeetingLink,
                icon: const Icon(Icons.open_in_new),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    'District Meeting',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMeetingLink() async {
    final uri = Uri.parse(meetingUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
