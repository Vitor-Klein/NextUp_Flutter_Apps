import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5280d5),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                const FAQBlock(
                  question: 'What is 988 and is it active?',
                  answer:
                      '988 is now active across the United States. This new, shorter phone number will make it easier for people to remember and access mental health crisis services. '
                      '(Please note, the previous 1-800-273-TALK (8255) number will continue to function indefinitely.) Click here to learn more about 988.',
                ),
                const FAQBlock(
                  question: 'Does 1-800-273-TALK (8255) still work?',
                  answer:
                      'On July 16, 2022 the ten-digit National Suicide Prevention Lifeline number, 1-800-273-TALK (8255), was converted to an easy to remember three-digit number, 988. '
                      'Even though this change happened to expand service and strengthen access to mental health care to those in need, the original number will remain in service.',
                ),
                const FAQBlock(
                  question:
                      'Does the 988 Lifeline have geolocation capabilities?',
                  answer:
                      'Geolocation, or receiving pinpoint information for dispatch during an emergency, is not enabled for the 988 Lifeline and is not under active consideration.',
                ),

                const SizedBox(height: 20),
                const Text(
                  'MORE ON ABOUT US',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF5280d5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FAQBlock extends StatelessWidget {
  final String question;
  final String answer;

  const FAQBlock({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FAQ: $question',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF5280d5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF444444),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
