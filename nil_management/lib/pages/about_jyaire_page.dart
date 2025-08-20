import 'package:flutter/material.dart';

class AboutJyairePage extends StatelessWidget {
  const AboutJyairePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Jyaire')),
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
                      '''Jyaire Brown (born February 15, 2004) is an American college football cornerback for the UCF Knights. He previously played for the LSU Tigers, and the Ohio State Buckeyes.

Brown attended Warren Easton Charter High School for two years before transferring to Lakota West High School during his junior year. As a senior, he had 26 receptions for 416 yards and four touchdowns, as well as five interceptions. Coming out of high school, Brown was rated as a four-star recruit, the 19th best cornerback, and the 155th overall player in the class of 2022. Brown committed to play college football for the Ohio State Buckeyes over offers from schools such as Alabama, LSU, and Mississippi State.''',
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
