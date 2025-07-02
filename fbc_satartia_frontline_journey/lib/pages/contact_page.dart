import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Não foi possível abrir o link.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Colors.brown.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/header.png'),

            const SizedBox(height: 16),

            // Botão: Email geral
            _contactTile(
              context,
              icon: Icons.email_outlined,
              label: 'Email',
              onTap: () => _launchUrl(context, 'mailto:info@frontlinejourney.org'),
            ),

            // Card: Worship Center
            _contactCard(
              context,
              title: 'Worship Center',
              address: '310 Plum St. Satartia, MS 39162',
              phone: '769-231-6702',
              website: 'https://frontlinejourney.org',
            ),

            // Card: Mailing Address
            _contactCard(
              context,
              title: 'Mailing Address',
              address: 'P. O. Box 2646 Madison, MS 39130',
            ),

            // Botão: E-mail para Royce
            _contactTile(
              context,
              icon: Icons.email,
              label: 'Contact Brother Royce, CEO/Founder directly',
              onTap: () => _launchUrl(context, 'mailto:brotherroyce@frontlinejourney.org'),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _contactTile(BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Icon(icon, color: Colors.brown.shade700),
          title: Text(label),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _contactCard(
    BuildContext context, {
    required String title,
    required String address,
    String? phone,
    String? website,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(address),

              if (phone != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 18),
                    const SizedBox(width: 8),
                    Text(phone),
                  ],
                ),
              ],

              if (website != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(FontAwesomeIcons.globe, size: 16),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _launchUrl(context, website),
                      child: Text(
                        website,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
