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
                '''Bob Stoops became Oklahoma’s head football coach prior to the 1999 season and set sail on a remarkable 18-year run.  

When he retired before the 2017 season, he had accumulated a record of 190-48 (0.798) and captured the 2000 National Championship and Big 12 titles - eight more than any other school during his tenure. No coach in NCAA history won as many games in his first 18 seasons, and under Stoops Oklahoma won more games than any other program during that period.  

Stoops reached 100 victories faster than any coach in the modern era of college football. His Sooners were 60-30 (0.677) against AP Top 25 opponents (best in the country during that span) with 21 wins against top-10 foes and 11 victories.  

In the Bowl Championship Series era, Stoops was the only coach to win a National Championship and each of the BCS bowl games (Fiesta, Orange, Rose, Sugar). He completed that cycle when Oklahoma registered a 45-31 victory over No. 3 Alabama in the 80th Allstate Sugar Bowl to cap the 2013 season.  

During his incredible run, Stoops picked up 19 Coach-of-the-Year honors including eight on the national level. Under his direction, the Sooners posted 14 seasons of 10 or more wins and played in a school-record 18 consecutive bowl games.  

OUs players were heavily decorated during Stoops’ years at OU. Two won the Heisman Trophy and a total of seven were finalists for the award. Thirty-eight of Stoops’s players won national awards, 37 were first-team All-Americans and 83 were drafted into the NFL.''',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFD32F2F),
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
