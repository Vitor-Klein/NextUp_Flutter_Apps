import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _ligarPara(String numero) async {
    final Uri telUri = Uri(scheme: 'tel', path: numero);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      print('Não foi possível iniciar a chamada para $numero');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/header.png'),
            const Text(
              'About Us',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'The Brandon First Responders Suicide Prevention App is a vital tool created to support the mental health and well-being of our community. '
              'Backed by the dedicated men and women of the Brandon Police Department, this app is part of a citywide commitment to save lives, offer hope, and connect individuals in crisis to immediate help.\n\n'
              'Our Purpose\n\n'
              'In Brandon, we believe that protecting life goes beyond emergency response—it includes recognizing the silent struggles many face every day. '
              'This app is designed to offer direct access to suicide prevention resources, crisis tools, and guidance when it’s needed most.\n\n'
              'What We Offer\n'
              '• Crisis Help – Immediate access to local and national suicide prevention hotlines, including 988.\n'
              '• Warning Signs & Support Tools – Learn how to identify signs of mental distress and what steps to take.\n'
              '• Community Resources – Find local counseling services, support groups, and mental health professionals.\n'
              '• Safety Planning – Tools for individuals and families to create personalized safety plans.\n'
              '• Educational Materials – Empowering residents with knowledge about suicide prevention, self-care, and how to support others.\n\n'
              'Our Commitment\n\n'
              'The Brandon Police Department, along with other first responders, is committed to serving not just with protection, but with compassion. '
              'Through this app, we aim to reduce stigma, raise awareness, and ensure that no one in our community feels alone in their time of need.\n\n'
              'Whether you’re struggling yourself or worried about someone else, the Brandon First Responders App is here for you—24/7. '
              'Together, we can build a safer, more compassionate Brandon.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 24),
            const Text(
              'Contact us by phone:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _ligarPara('(918) 585-1213'),
                  icon: const Icon(Icons.phone),
                  label: const Text('(918) 585-1213'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAEAEA),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _ligarPara('(405) 943-3700'),
                  icon: const Icon(Icons.phone),
                  label: const Text('(405) 943-3700'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAEAEA),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Available Monday–Friday from 8:30 a.m. to 5:00 p.m., or anytime by completing the form below.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(
                    'https://mhaok.org/about/mental-health-assistance-center-form/',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    print('Não foi possível abrir o formulário.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAEAEA),
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Complete Form'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
