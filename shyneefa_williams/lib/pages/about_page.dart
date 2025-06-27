import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset('assets/header.jpg'),
            Container(
              width: 350,
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: const Text(
                '''Shyneefa Williams is the Co-Founder of the Harold Lefty Williams Dare2Dream Foundation, created alongside her husband, former Harlem Globetrotter Harold “Lefty” Williams. Together, they’ve impacted communities around the world by empowering youth and young adults to dream bigger and live with purpose.
Recognized by the NBA’s Milwaukee Bucks G League team, the Wisconsin Herd, three years in a row for her philanthropic leadership, Shyneefa is also an author, speaker, and passionate advocate for youth development. With a background in psychology, she brings a thoughtful, purpose-driven approach to every initiative.
Above all, Shyneefa is a proud wife and mother of three, committed to faith, family, and making a lasting difference.''',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF5280d5),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
