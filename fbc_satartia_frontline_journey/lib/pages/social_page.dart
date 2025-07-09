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
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Image.asset('assets/header.png'),
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
                      url: 'https://www.instagram.com/broroyce',
                    ),
                  ),
                );
              },
            ),
            SocialButton(
              label: 'X (Twitter)',
              icon: FontAwesomeIcons.xTwitter,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      title: 'X (Twitter)',
                      url: 'https://www.twitter.com/celebratelcs',
                    ),
                  ),
                );
              },
            ),
            SocialButton(
              label: 'Facebook',
              icon: FontAwesomeIcons.facebookF,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      title: 'Facebook',
                      url: 'https://www.facebook.com/lifecoachsouth',
                    ),
                  ),
                );
              },
            ),
            SocialButton(
              label: 'YouTube',
              icon: FontAwesomeIcons.youtube,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      title: 'Youtube',
                      url:
                          'https://www.youtube.com/channel/UC1G2MywiczQHaDBIqbeamKQ',
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
        icon: FaIcon(icon, color: const Color(0xFF9b8a53), size: 18),
        label: Text(label, style: const TextStyle(color: Color(0xFF9b8a53))),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFf9ecd8),
          side: const BorderSide(color: Color(0xFF9b8a53)),
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
