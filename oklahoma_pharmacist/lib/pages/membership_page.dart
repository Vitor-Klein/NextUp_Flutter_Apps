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

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/header-membership.jpg'),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Membership',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Coming together to make a difference in pharmacy\n\n'
                    'Connecting the Industry throughout Oklahoma\n',
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
                          text:
                              'OPhA serves all Oklahoma professionals in the pharmacy industry. We support all pharmacists, in every county, in every way we can. With members in 132 cities, we strive daily to remain a viable and powerful voice for the pharmacy industry.\n\n'
                              'We come together to make a difference in the pharmacy industry! No matter your position, we are representing you and your interest!\n\n',
                        ),
                        TextSpan(
                          text: 'Advocacy\n',
                          style: linkStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink('https://opha.com/advocacy/');
                            },
                        ),
                        const TextSpan(
                          text:
                              'Our team is continuously fighting for your rights at the State Legislature. Our lobbyist, board and committee meet regularly to discuss policy changes, arising legislative issues and other items crossing the legislative floor.\n\n',
                        ),
                        TextSpan(
                          text: 'Continuing Education\n',
                          style: linkStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink('https://opha.com/events/');
                            },
                        ),
                        const TextSpan(
                          text:
                              'We provide continuing education opportunities throughout the year, in all corners of Oklahoma! You can join OPhA events or trainings with our partners and get CE credits all year long.\n\n',
                        ),
                        TextSpan(
                          text: 'Networking\n',
                          style: linkStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink('https://opha.com/events/');
                            },
                        ),
                        const TextSpan(
                          text:
                              'Exclusive, one-on-one networking opportunities with other Oklahoma pharmacists, technicians and decision-makers in the state!\n\n',
                        ),
                        TextSpan(
                          text: 'Members Discounts\n',
                          style: linkStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink('https://opha.com/events/');
                            },
                        ),
                        const TextSpan(
                          text:
                              'Members receive discounted pricing for all OPhA programs and events! As a member, you’ll be the first to know all OPhA opportunities.\n\n',
                        ),
                        const TextSpan(
                          text: 'Careers\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              'Members can access the OPhA job board to post an opening or search for their next position.\n\n',
                        ),
                        TextSpan(
                          text: 'Partner Discounts\n',
                          style: linkStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink('https://opha.com/about/');
                            },
                        ),
                        const TextSpan(
                          text:
                              'Members have access to special programs, discounts and information with our partners: PharmaCanna, PPOk, Pharmacists Mutual, APMS\n\n',
                        ),
                        const TextSpan(
                          text: 'Member-only Information\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              'Our members have access to exclusive information and documents through their custom logins.\n\n',
                        ),
                        TextSpan(
                          text: 'Legislative Alerts\n',
                          style: linkStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink('https://opha.com/news/');
                            },
                        ),
                        const TextSpan(
                          text:
                              'We want to ensure you always know what is happening at the state capitol! We’ll let you know the latest news and bills possibly affecting our industry in our action alerts and grassroots efforts.\n\n',
                        ),
                        const TextSpan(
                          text: 'Quick & Monthly Dose\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              'The Quick Dose & Monthly Dose is our e-newsletters sent to our members twice a month.\n\n',
                        ),
                        TextSpan(
                          text: 'Join OPhA today',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _abrirLink(
                                'https://opha.site-ym.com/general/register_member_type.asp?',
                              );
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
