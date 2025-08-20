import 'package:flutter/material.dart';

class AboutCadePage extends StatelessWidget {
  const AboutCadePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Cade Stover')),
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
                      '''Cade Stover (born June 12, 2000) is an American professional football tight end for the Houston Texans of the National Football League (NFL). He played college football for the Ohio State Buckeyes, and was selected by the Texans in the fourth round of the 2024 NFL draft.

Early life
Stover was born on June 12, 2000, in Mansfield, Ohio, later attending Lexington High School in Lexington, Ohio. He was named Ohio's Mr. Football and the Ohio Gatorade Player of the Year as a senior after rushing for 1,477 yards and 17 touchdowns on offense and recording 163 tackles and four interceptions on defense. Stover also set Lexington's all-time scoring and rebounding records in basketball. He was rated a four-star recruit and committed to play college football at Ohio State over offers from Michigan, Oklahoma, Penn State, Texas, and Wisconsin.

College career
Stover was initially recruited to play linebacker at Ohio State, but was moved to defensive end before the start of his freshman season. He played in four games before redshirting the season. Stover was moved to tight end during spring practice in 2020. He returned back to linebacker during the season. Stover was again moved to tight end for his redshirt junior season and caught five passes for 76 yards. He played linebacker in the 2022 Rose Bowl due to a shortage of players at the position. In 2023, Stover was one of the three finalists for the Mackey Award, which is awarded to the nation's best tight end.''',
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
