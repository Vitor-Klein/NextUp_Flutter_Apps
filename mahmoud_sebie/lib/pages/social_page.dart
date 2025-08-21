import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'webview_page.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: Column(
        children: [
          Image.asset('assets/header.jpg'), // header sem padding
          const SizedBox(height: 24),

          // Botões com padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SocialButton(
                  label: 'Youtube',
                  icon: FontAwesomeIcons.youtube,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewPage(
                          title: 'Youtube',
                          url:
                              'https://www.youtube.com/@princesebiehs6Q0FxGnY7s7fK_1-nKxWUM-DpFJlvpkGjIjeVP4',
                        ),
                      ),
                    );
                  },
                ),
                SocialButton(
                  label: 'Instagram',
                  icon: FontAwesomeIcons.instagram,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewPage(
                          title: 'Instagram',
                          url: 'https://www.instagram.com/mahmoud_sebie/?hl=en',
                        ),
                      ),
                    );
                  },
                ),
                SocialButton(
                  label: 'Gofundme',
                  icon: FontAwesomeIcons.hospital,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewPage(
                          title: 'Gofundme',
                          url:
                              'https://www.gofundme.com/f/support-michael-babbs-fight-against-cancer',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
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
        icon: FaIcon(icon, color: Colors.black, size: 18),
        label: Text(label, style: const TextStyle(color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFF59D), // amarelo pastel
          side: const BorderSide(color: Colors.black),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
