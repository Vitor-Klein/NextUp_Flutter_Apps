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

          // Botões
          _buildButton(context, 'Social Media', () {
            Navigator.pushNamed(context, '/social');
          }),
          _buildButton(context, 'Ministries', () {
            Navigator.pushNamed(context, '/ministries');
          }),
          _buildButton(context, 'Galery', () {
            Navigator.pushNamed(context, '/galery');
          }),
          _buildButton(context, 'ORYD School', () {
            _launchUrl('https://orydschool.org');
          }),
          _buildButton(context, '1 Peter Bible Study - October', () {
            Navigator.pushNamed(context, '/bible');
          }),
          _buildButton(context, 'Give', () {
            _launchUrl('https://app.easytithe.com/app/giving/oakr0629223');
          }),
          _buildButton(context, 'Notifications', () {
            Navigator.pushNamed(context, '/notification');
          }),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String title,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // menos arredondado
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
