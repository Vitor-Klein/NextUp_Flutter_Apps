import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nil_management/pages/webview_page.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset('assets/header.jpg'),
            const SizedBox(height: 24),

            SocialButton(
              label: 'Instagram',
              icon: FontAwesomeIcons.instagram,
              onPressed: () => openWeb(
                context,
                'https://www.instagram.com/',
                title: 'Instagram',
              ),
            ),

            SocialButton(
              label: 'X (Twitter)',
              icon: FontAwesomeIcons.xTwitter,
              onPressed: () => openWeb(
                context,
                'https://twitter.com/',
                title: 'X (Twitter)',
              ),
            ),

            SocialButton(
              label: 'Facebook',
              icon: FontAwesomeIcons.facebookF,
              onPressed: () =>
                  openWeb(context, 'https://facebook.com/', title: 'Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: FaIcon(icon, color: Colors.white, size: 18),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87, // fundo preto/cinza escuro
          side: const BorderSide(color: Colors.grey), // borda cinza
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
