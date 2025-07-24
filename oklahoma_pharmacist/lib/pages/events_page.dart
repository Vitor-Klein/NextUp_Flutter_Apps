import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final TextStyle linkStyle = const TextStyle(
  fontSize: 16,
  color: Colors.blue,
  decoration: TextDecoration.underline,
);

Future<void> _abrirLink(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    print('Não foi possível abrir o link: $url');
  }
}

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/header-events.jpg'),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OPhA Events',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connecting & Growing\n\nMembers get discounts on all events\n',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                      children: [
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
                          text: 'Why attend an OPhA Event?\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              'Education\nProviding avenues to grow your business and the pharmacy profession\n\n',
                        ),
                        const TextSpan(
                          text:
                              'Networking\nExclusive networking opportunities with key industry professionals & decision-makers\n\n',
                        ),
                        const TextSpan(
                          text:
                              'CE Credits\nWe work hard to provide CE credits at our events. See individual events for more details\n\n',
                        ),
                        const TextSpan(
                          text:
                              'Annual Meeting\nLearn from experts and have a candid discussion on issues facing pharmacies in Oklahoma\n',
                        ),
                        TextSpan(
                          text: 'Learn More\n\n',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink('https://opha.com/annual-convention/');
                            },
                        ),
                        const TextSpan(
                          text:
                              'Law Seminar\nReview compliance laws and techniques while earning CE credits\n',
                        ),
                        TextSpan(
                          text: 'Learn More\n\n',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink('https://opha.com/law-seminar/');
                            },
                        ),
                        const TextSpan(
                          text:
                              'Legislative Day\nJoin pharmacists, technicians and students at the state capitol\n',
                        ),
                        TextSpan(
                          text: 'Learn More\n\n',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink('https://opha.com/legislative-day/');
                            },
                        ),
                        const TextSpan(
                          text:
                              'District Meetings\nConnecting with professionals and legislators in every corner of the state\n',
                        ),
                        TextSpan(
                          text: 'Learn More\n\n',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink('https://opha.com/district-meetings/');
                            },
                        ),
                        const TextSpan(
                          text: 'We Know You’ll Love OPhA Events\n\n',
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Image.asset(
                              'assets/header-events2.jpg', // substitua pelo seu caminho de imagem
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const TextSpan(
                          text:
                              'Don’t miss another opportunity to network, educate and more!\n\n',
                        ),
                        TextSpan(
                          text: 'Upcoming Events',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink('https://opha.com/upcoming-events/');
                            },
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
