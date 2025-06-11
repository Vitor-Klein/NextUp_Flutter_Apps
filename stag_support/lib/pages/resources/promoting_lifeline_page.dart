import 'package:flutter/material.dart';

class PromotingLifelinePage extends StatelessWidget {
  const PromotingLifelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Promoting or Joining the Lifeline')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Promoting or Joining the Lifeline',
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
                      'Can I use the 988 Lifeline logo in my campaign / website / poster?',
                  answer:
                      'Absolutely! The 988 Lifeline is a public service and our logo is available for anyone to use. '
                      'You do not need to ask for permission, though we ask that you do not alter the logo in any way. '
                      'Please visit our Media Resources page to access logos.',
                ),
                const FAQBlock(
                  question:
                      'Do you have 988 Lifeline materials that I can order?',
                  answer:
                      'Yes. 988 Lifeline posters, wallet cards, and other print materials can be ordered through the SAMHSA store. '
                      'PDF versions are also available on the SAMHSA website. All orders must be placed via the SAMHSA store – the 988 Lifeline does not take orders or ship print materials directly.',
                ),
                const FAQBlock(
                  question:
                      'Can I link to the 988 Lifeline website through my organization’s website or my personal website?',
                  answer:
                      'We encourage all organizations interested in promoting the 988 Suicide & Crisis Lifeline to provide a link to 988lifeline.org on their own websites. '
                      'Logos are available on our Media Resources page.',
                ),

                const SizedBox(height: 20),
                const Text(
                  'MORE ON PROMOTING OR JOINING THE LIFELINE',
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
