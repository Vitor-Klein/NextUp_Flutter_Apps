import 'package:flutter/material.dart';

class LifelineChatPage extends StatelessWidget {
  const LifelineChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('988 Lifeline Chat')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '988 Lifeline Chat',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5280d5),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                const FAQBlock(
                  question: 'Who should use the 988 Lifeline Chat service?',
                  answer:
                      'Anyone who is depressed, going through a hard time, needs to talk, or is thinking about suicide can use the chat. '
                      'Our caring counselors are here to listen and support you through whatever difficult times you may be facing.',
                ),
                const FAQBlock(
                  question:
                      'What should I expect during a 988 Lifeline Chat session?',
                  answer:
                      'Our goal is to help you reduce stress and feel empowered to make healthy decisions. You will be asked questions regarding your safety, feelings, social situation, and if you have any thoughts of suicide.\n\n'
                      'If a counselor feels you are in danger, they will speak with you about accessing emergency services, and/or gather additional contact information to ensure your safety. '
                      'The counselor will work with you to create a safety plan if necessary.\n\n'
                      'For more information about what to expect during a 988 Lifeline chat session, please see our page here.',
                ),
                const FAQBlock(
                  question: 'When is 988 Lifeline Chat available?',
                  answer:
                      'The 988 Lifeline Chat service is available 24/7. If you have trouble connecting to the chat service we encourage you to call the 988 Suicide & Crisis Lifeline at 988.',
                ),

                const SizedBox(height: 20),
                const Text(
                  'MORE ON 988 CHAT',
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
