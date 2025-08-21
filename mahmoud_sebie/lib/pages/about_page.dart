import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Mahmoud Sebie'),
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
                'Mahmoud Sebie is a distinguished Egyptian athlete, renowned for his achievements in Greco-Roman wrestling and mixed martial arts (MMA). Born with a deep passion for combat sports, Sebie rose through the ranks of wrestling to become an Olympian, representing Egypt on the world stage. His career in Greco-Roman wrestling saw him claim multiple national and international titles, earning him widespread recognition for his technical skill, strength, and resilience. Competing in the 2016 Rio Olympics was a highlight of his wrestling career, where he showcased his talent and dedication to his sport.\n\n'
                'Following his successful tenure in wrestling, Sebie made a bold transition to the world of MMA, leveraging his grappling background to become a formidable force in the cage. His wrestling foundation has allowed him to dominate opponents with superior clinch work, takedowns, and ground control, making him a rising star in the sport.\n\n'
                'Beyond his personal athletic achievements, Sebie is an advocate for fitness, martial arts, and youth empowerment. He is committed to giving back to his community by promoting sports as a means of self-discipline, health, and personal growth. Sebie’s journey from Olympic wrestler to MMA fighter highlights his relentless work ethic, adaptability, and passion for combat sports, making him a respected figure in both disciplines.\n\n'
                'In addition to his athletic pursuits, Sebie is known for his charismatic personality and ability to inspire the next generation of athletes. Whether in the wrestling arena or the MMA cage, Mahmoud Sebie’s legacy is one of perseverance, skill, and an unwavering commitment to excellence.',
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
