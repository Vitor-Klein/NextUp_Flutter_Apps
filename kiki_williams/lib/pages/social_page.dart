import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'webview_page.dart';

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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      title: 'Instagram',
                      url: 'http://instagram.com/kikiwilliams42	',
                    ),
                  ),
                );
              },
            ),
            SocialButton(
              label: 'Threads',
              icon: FontAwesomeIcons.threads,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      title: 'Threads',
                      url: 'https://www.threads.com/@kikiwilliams42	',
                    ),
                  ),
                );
              },
            ),
            SocialButton(
              label: 'TikTok',
              icon: FontAwesomeIcons.tiktok,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      title: 'TikTok',
                      url: 'https://www.tiktok.com/@kiki.williams42	',
                    ),
                  ),
                );
              },
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
        icon: FaIcon(icon, color: const Color(0xFFe3dede), size: 18),
        label: Text(label, style: const TextStyle(color: Color(0xFFe3dede))),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF786e6e),
          side: const BorderSide(color: Color(0xFF424242)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // Menos arredondado
          ),
        ),
      ),
    );
  }
}
