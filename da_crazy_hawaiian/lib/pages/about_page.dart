import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Da Crazy Hawaiian'),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header com imagem
            SizedBox(
              width: double.infinity,
              height: 220,
              child: Image.asset(
                'assets/header.jpg', // substitua pelo seu asset
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            /// Texto principal
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Layne Viernes, better known as the Da Crazy Hawaiian, is America\'s first EVER Super Heavyweight SLAP CHAMPION and Russia\'s Heavyweight Stonefaces Slap Champion currently in the Slap Fight Game. ',
                style: TextStyle(fontSize: 16, height: 1.6),
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
