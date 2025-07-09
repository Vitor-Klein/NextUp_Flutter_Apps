import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header image
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              'assets/header.png',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),

          // Botões de redes sociais
          _buildButton(
            context,
            'Instagram',
            FontAwesomeIcons.instagram,
            () => _launchUrl('https://www.instagram.com/broroyce'),
          ),
          _buildButton(
            context,
            'X (Twitter)',
            FontAwesomeIcons.xTwitter,
            () => _launchUrl('https://www.twitter.com/celebratelcs'),
          ),
          _buildButton(
            context,
            'Facebook',
            FontAwesomeIcons.facebookF,
            () => _launchUrl('https://www.facebook.com/lifecoachsouth'),
          ),
          _buildButton(
            context,
            'YouTube',
            FontAwesomeIcons.youtube,
            () => _launchUrl(
              'https://www.youtube.com/channel/UC1G2MywiczQHaDBIqbeamKQ',
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: FaIcon(icon, color: const Color(0xFF9b8a53), size: 18),
        label: Text(label, style: const TextStyle(color: Color(0xFF9b8a53))),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFf9ecd8),
          side: const BorderSide(color: Color(0xFF9b8a53)),
          minimumSize: const Size(double.infinity, 50),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
