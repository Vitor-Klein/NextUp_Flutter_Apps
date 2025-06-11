import 'package:flutter/material.dart';

class Calling988LifelinePage extends StatelessWidget {
  const Calling988LifelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calling the 988 Lifeline')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Calling the 988 Lifeline',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5280d5),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                const FAQBlock(
                  question:
                      'What do I do if I have trouble connecting when I call?',
                  answer:
                      'We work hard to make sure that everyone can reach a 988 counselor as quickly as possible. '
                      'If you call 988 and are having trouble connecting to a counselor, please let us know using our Contact Us form.\n\n'
                      'Please call 911 if you are having a medical emergency. If you are in suicidal crisis and cannot connect via phone, '
                      'you can also try texting 988 or using chat. You can also call 911.',
                ),
                const FAQBlock(
                  question:
                      'Does the 988 Lifeline feature TTY services for the hearing impaired?',
                  answer:
                      'For TTY Users: Use your preferred relay service or dial 711 then 988.\n'
                      'We also offer 988 ASL Videophone for people who are deaf or hard of hearing.',
                ),
                const FAQBlock(
                  question:
                      'Is the 988 Lifeline available in other languages for non-English speakers?',
                  answer:
                      'Yes. When calling 988, press 2 to connect to a trained Spanish-speaking crisis counselor.\n\n'
                      'When texting 988 in Spanish, you will be asked to type “Ayuda” to connect with a Spanish-speaking counselor.\n\n'
                      'For people who speak other languages, call 988 and you will be provided translation in more than 240 additional languages through Language Line Solutions. '
                      'This is available 24/7 through voice calling only.\n\n'
                      'When calling 988, you or one of your friends or family can ask for an interpreter in English if you are able or you can say the name of the language you need. '
                      'You will then be connected with an interpreter. The connection to an interpreter typically takes about 20 seconds. '
                      'Interpreters receive special training to provide this service over the phone and they follow a code of ethics related to confidentiality, accuracy, and impartiality.',
                ),
                const SizedBox(height: 20),
                const Text(
                  'MORE ON CALLING THE 988 LIFELINE',
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
