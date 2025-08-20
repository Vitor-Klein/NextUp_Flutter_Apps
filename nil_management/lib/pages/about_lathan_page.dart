import 'package:flutter/material.dart';

class AboutLathanPage extends StatelessWidget {
  const AboutLathanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Lathan')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset('assets/header.jpg'),
                  Container(
                    width: 350,
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: const Text(
                      '''Kiara “KiKi” Williams is a rising multi-hyphenate talent, known for her standout voice work on Disney’s Moon Girl, national commercial campaigns, and her memorable role as Latanya on ABC’s reimagined The Wonder Years. The daughter of Harlem Globetrotter legend Harold “Lefty” Williams and author Shyneefa Williams, KiKi brings passion, charisma, and heart to every project she touches. A gifted storyteller, she recently launched her clothing brand, Don’t I Have a Say, debuting it alongside a song and music video of the same name. Beyond the spotlight, KiKi is a devoted sister to her rising star brothers EJ and CJ, admired not only for her artistic gifts but also for her intelligence, kindness, and grounded spirit.''',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF424242),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
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
