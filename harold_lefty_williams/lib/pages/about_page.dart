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
                '''Harold “Lefty” Williams is a former professional basketball star, best known for his time with the world-famous Harlem Globetrotters, and now the Harlem Dreams.

Today, he’s a respected actor, executive producer, philanthropist, author, and entrepreneur, having co-produced projects like *The Real Stories of Basketball* with LeBron James and Maverick Carter.

Through the Harold Lefty Williams Dare2Dream Foundation, Lefty empowers youth and communities across the country, a commitment that earned him recognition by the Milwaukee Bucks G League team, the Wisconsin Herd, for his philanthropic impact three years in a row.

A proud husband to Shyneefa Williams and father to rising young stars KiKi, EJ, and CJ Williams, Lefty is celebrated for his leadership, creativity, and lifelong mission to inspire and uplift others.''',
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
