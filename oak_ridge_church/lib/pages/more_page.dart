import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
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

          // Botão de Contato em destaque
          _buildHighlightButton(
            context,
            icon: Icons.phone,
            title: 'Contact',
            onPressed: () => Navigator.pushNamed(context, '/contact'),
          ),

          _buildButton(
            context,
            icon: Icons.people,
            title: 'Social Media',
            onPressed: () => Navigator.pushNamed(context, '/social'),
          ),
          _buildButton(
            context,
            icon: Icons.volunteer_activism,
            title: 'Ministries',
            onPressed: () => Navigator.pushNamed(context, '/ministries'),
          ),
          _buildButton(
            context,
            icon: Icons.photo_library,
            title: 'Galery',
            onPressed: () => Navigator.pushNamed(context, '/gallery'),
          ),
          _buildButton(
            context,
            icon: Icons.school,
            title: 'ORYD School',
            onPressed: () => _launchUrl('https://orydschool.org'),
          ),
          _buildButton(
            context,
            icon: Icons.book,
            title: '1 Peter Bible Study - October',
            onPressed: () => Navigator.pushNamed(context, '/bible'),
          ),
          _buildButton(
            context,
            icon: Icons.favorite,
            title: 'Give',
            onPressed: () =>
                _launchUrl('https://app.easytithe.com/app/giving/oakr0629223'),
          ),
          _buildButton(
            context,
            icon: Icons.notifications,
            title: 'Notifications',
            onPressed: () => Navigator.pushNamed(context, '/messages'),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildHighlightButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2B4A83),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
