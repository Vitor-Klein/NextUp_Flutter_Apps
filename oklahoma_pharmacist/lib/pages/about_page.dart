import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _abrirLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Não foi possível abrir o link: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle linkStyle = const TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/header-about.jpg'),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pharmacy with a difference',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'OPhA Put The Focus Back On Exceptional Service\n\n',
                        ),
                        const TextSpan(
                          text: 'Want to join OPhA for all the benefits?\n',
                        ),
                        TextSpan(
                          text: 'JOIN TODAY\n\n',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink(
                                'https://opha.site-ym.com/general/register_member_type.asp?',
                              );
                            },
                        ),
                        const TextSpan(
                          text:
                              'Your Voice in Pharmacy\n\nTo unite and promote the profession of pharmacy through advocacy, communication and education. '
                              'We facilitate member pharmacists in the development of innovative pharmacy practices that demonstrate improved health outcomes '
                              'for patients and reinforce the role of pharmacists as essential members of the healthcare team.\n\n',
                        ),
                        const TextSpan(
                          text:
                              'Exceptional Council\n\nWe’re supported by a great board, lobbyist and staff that allow us to provide top-notch service to our members. '
                              'They work hard to support our members while developing innovative ideas to expand our reach.\n',
                        ),
                        TextSpan(
                          text: 'VIEW OUR COUNCIL & STAFF\n\n',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink('https://opha.com/council-and-staff/');
                            },
                        ),
                        const TextSpan(
                          text:
                              'Trusted Partners\n\nOur partners have committed to supporting Oklahoma pharmacists in ensuring we have exceptional education, '
                              'products and customer service throughout the state.',
                        ),
                      ],
                    ),
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
