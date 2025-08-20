import 'package:flutter/material.dart';

class AboutLathanPage extends StatelessWidget {
  const AboutLathanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Lathan Ransom')),
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
                      '''Lathan Ransom (born July 16, 2002) is an American professional football safety for the Carolina Panthers of the National Football League (NFL). He played college football for the Ohio State Buckeyes and was selected by the Panthers in the fourth round of the 2025 NFL draft.

Early life
Ransom attended Salpointe Catholic High School in Tucson, Arizona. He was selected to play in the 2020 All-American Bowl. He committed to Ohio State University to play college football.

College career
As a freshman at Ohio State in 2020, Ransom played in seven games and had six tackles. As a sophomore in 2021, he played in 13 games and had 38 tackles and one sack. In the 2022 Rose Bowl, he suffered a broken leg. Ransom returned from the injury in time for the 2022 season. He was one of 12 semi-finalists for the Jim Thorpe Award.''',
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
