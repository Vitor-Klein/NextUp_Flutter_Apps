import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'webview_page.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/contact-background.jpg', // coloque sua imagem aqui
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildGlassContainer(
                  child: SocialButton(
                    label: 'YouTube',
                    icon: FontAwesomeIcons.youtube,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WebViewPage(
                            title: 'YouTube',
                            url:
                                'https://www.youtube.com/channel/UCjJJBB8dqi-s3CDG9DF7Lww',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildGlassContainer(
                  child: SocialButton(
                    label: 'X (Twitter)',
                    icon: FontAwesomeIcons.xTwitter,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WebViewPage(
                            title: 'X (Twitter)',
                            url: 'https://twitter.com/OkPharmAssoc',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildGlassContainer(
                  child: SocialButton(
                    label: 'Facebook',
                    icon: FontAwesomeIcons.facebookF,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WebViewPage(
                            title: 'Facebook',
                            url: 'https://www.facebook.com/OkPharmAssoc/',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Container com fundo translúcido branco
  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: FaIcon(icon, color: const Color(0xFF5280d5), size: 18),
        label: Text(label, style: const TextStyle(color: Color(0xFF5280d5))),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFd4def7),
          side: const BorderSide(color: Color(0xFF5280d5)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
