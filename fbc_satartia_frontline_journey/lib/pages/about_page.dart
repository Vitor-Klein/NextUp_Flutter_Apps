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
            Image.asset('assets/header.png'),
            Container(
              width: 350,
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: const Text(
                '''Welcome to Front Line Journey, the APP.

For more than thirty years it has been my calling to help individuals find LIFE and PURPOSE. 

From work in the education system to courts and behavioral health circles, to developing community events and forums for public awareness, I’ve committed my life to building people and serving families. I’ve called it, living and serving “on the front line,” and life truly is a journey. 
With that, to bring all of my tributaries of service under one heading, we’ve created this great umbrella we call, “Front Line Journey. . . from The Village”. It is my hope that you will find many life-affirming benefits in our APP. Take your time and explore our site! 

There’s much to be found here, and we did it just for YOU. The front line is where real life happens – life and death, joy and grief, circumstances of all kinds, beyond our belief. 
Whether we ever meet face to face is still to be determined. Yet, it is my hope to proverbially walk with you on your journey because you too were created FOR LIFE and WITH PURPOSE. This, I know for a fact. 

Traveling with you, Royce R. Lott, Jr. – CLC, LOM, CPC, SELS CEO/Founder – Life Coach South Sold Out Ministries – est. 1994.''',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF121212),
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
