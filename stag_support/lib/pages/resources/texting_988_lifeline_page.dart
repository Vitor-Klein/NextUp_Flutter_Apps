import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Texting988LifelinePage extends StatelessWidget {
  const Texting988LifelinePage({super.key});
  void _launchMore() async {
    final Uri _url = Uri.parse(
      'https://988lifeline.org/faq/texting-the-988-lifeline/',
    );
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Texting the 988 Lifeline')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Texting the 988 Lifeline',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5280d5),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                const FAQBlock(
                  question: 'Who should text the 988 Lifeline?',
                  answer:
                      'Anyone who is struggling can use this service, whether it be someone who is depressed, needs to talk, or is contemplating suicide. '
                      'Our caring counselors are here to listen and support you through whatever difficult times you may be facing.',
                ),
                const FAQBlock(
                  question: 'How do I text the 988 Lifeline?',
                  answer:
                      'To start a text conversation with the 988 Lifeline, you can send any message to 988.',
                ),
                const FAQBlock(
                  question: 'What happens when I text the 988 Lifeline?',
                  answer:
                      'For details on what happens when you text the 988 Lifeline, visit our What to Expect page. '
                      'If demand is high, you can call the Lifeline at 988 or chat with us.\n\n'
                      'Once you answer the questions in our pre-text survey and accept our Terms of Service, you will be connected as soon as possible with a skilled, caring counselor. '
                      'This person will listen to you, understand how your problem is affecting you, provide support, and share resources that may be helpful.',
                ),

                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _launchMore,
                  child: const Text(
                    'MORE ON TEXTING THE 988 LIFELINE',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF5280d5),
                    ),
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
