import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'webview_page.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: SingleChildScrollView(
        // ← agora a tela é rolável
        child: Column(
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
                    url:
                        'https://www.youtube.com/@princesebiehs6Q0FxGnY7s7fK_1-nKxWUM-DpFJlvpkGjIjeVP4',
                  ),
                  SocialButton(
                    label: 'Instagram',
                    icon: FontAwesomeIcons.instagram,
                    url: 'https://www.instagram.com/mahmoud_sebie/?hl=en',
                  ),
                  SocialButton(
                    label: 'Gofundme',
                    icon: FontAwesomeIcons.hospital,
                    url:
                        'https://www.gofundme.com/f/support-michael-babbs-fight-against-cancer',
                  ),
                  SocialButton(
                    label: 'Instagram (Crazy Hawaiian)',
                    icon: FontAwesomeIcons.instagram,
                    url: 'https://www.instagram.com/da_crazy_hawaiian/?hl=en',
                  ),
                  SocialButton(
                    label: 'Rumble',
                    icon: FontAwesomeIcons.video,
                    url:
                        'https://rumble.com/powerslap?fbclid=PAAaZa46db656EOBXNW5wozUrurDCl6BwmfQwmxWKE9aT6aw3Zvv3z5diCExI_aem_ATkrGxrcH2RBEtRYJckaV5-GOQgHnUVGZbUwMDhBCJpra8Y36ERRJ-_VuYIy7vCrfag',
                  ),
                  SocialButton(
                    label: 'Youtube (Crazy Hawaiian)',
                    icon: FontAwesomeIcons.youtube,
                    url:
                        'https://www.youtube.com/channel/UCx-QObyTDynqOUbC23hHmCA',
                  ),
                  SocialButton(
                    label: 'Twitch',
                    icon: FontAwesomeIcons.twitch,
                    url: 'https://www.twitch.tv/dacrazyhawaiian',
                  ),
                  SocialButton(
                    label: 'Facebook',
                    icon: FontAwesomeIcons.facebook,
                    url: 'https://www.facebook.com/DACRAZYHAWAIIANSLAPCHAMP',
                  ),
                  SocialButton(
                    label: 'TikTok',
                    icon: FontAwesomeIcons.tiktok,
                    url: 'https://tiktok.com/@dacrazyhawaiian',
                  ),
                  SocialButton(
                    label: 'Whatsapp',
                    icon: FontAwesomeIcons.whatsapp,
                    url: 'https://api.whatsapp.com/send?phone=17026652731',
                  ),
                ],
              ),
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
  final String url;

  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewPage(title: label, url: url),
            ),
          );
        },
        icon: FaIcon(icon, color: Colors.black, size: 18),
        label: Text(label, style: const TextStyle(color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF90CAF9), // azul pastel
          side: const BorderSide(color: Colors.black),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
