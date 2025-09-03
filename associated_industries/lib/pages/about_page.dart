import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/header.png'),
            const SizedBox(height: 16),
            Text(
              'Associated Environmental Industries, Corp. was founded in 1992 by Robert C. Keyes in Norman, Oklahoma.\n\n'
              'In February of 1992, Associated Industries owned a single Failing F6 vertical drilling rig. Today, Associated Industries consists of three divisions: Associated Environmental Industries, Corp., Associated Directional Drilling, Inc. and Associated Tool Works, Inc. All three Associated Industries divisions work seamlessly together to provide our clients the quality services they demand.\n\n'
              'Associated Industries currently owns and operates seven vertical rigs, two pump rigs, two directional drilling rigs, and a down-hole camera unit. AI also operates its own in-house machine and manufacturing division (Associated Tool Works) to produce its own down-hole drilling tools.\n\n'
              'Associated Industries and its subdivisions are dedicated to serving our clients with quality and integrity. We stand by our work and our employees to get the job done right. We are committed to the highest standards in drilling and drilling equipment manufacturing. We earn our clients\' confidence by meeting their environmental needs with work that satisfies the most exacting standards.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
