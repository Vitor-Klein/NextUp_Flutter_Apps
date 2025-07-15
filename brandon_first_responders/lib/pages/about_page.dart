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
            Image.asset('assets/header.jpg'),
            const Text(
              'About Us',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Standing Together for Canadian County\n\n'
              'This app was created as a safe and supportive space for anyone in Canadian County who is experiencing emotional distress, mental health struggles, or thoughts of suicide. Backed by the Canadian County Sheriff\'s Office, our mission is simple: reach out, find support, and know that you\'re not alone.\n\n'
              'We believe in the power of community and the importance of timely support. Through this app, you can access trusted resources, connect with professionals, and find hope when you need it most. Whether you’re seeking help for yourself or someone else, we\'re here 24/7.\n\n'
              'Our goal is to make sure every person in Canadian County feels seen, supported, and safe. Together, we can build a stronger, more caring community.\n\n'
              'Mental Health Assistance Center\n\n'
              'Get information and resources from our caring mental health professionals on topics related to mental illness, suicide prevention, employment and housing support. For many, finding mental health information and connecting with services is daunting and requires navigating a complex network of community resources. Our free resource referral line provides one-on-one customer service to help find the best referral option for individuals in need. We’re here to work with you and help you navigate the mental health system.\n',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 16),
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
