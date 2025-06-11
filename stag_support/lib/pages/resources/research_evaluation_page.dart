import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResearchEvaluationPage extends StatelessWidget {
  const ResearchEvaluationPage({super.key});

  void _launchMore() async {
    final Uri _url = Uri.parse(
      'https://988lifeline.org/faq/research-and-evaluation/',
    );
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Research and Evaluation')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Research and Evaluation',
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
                      'I want to partner with the 988 Lifeline on a research opportunity. How do I apply?',
                  answer:
                      'The 988 Lifeline accepts research applications on a rolling basis. '
                      'Please visit our Research and Evaluation Process page to learn if you qualify, how to apply, and more.',
                ),

                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _launchMore,
                  child: const Text(
                    'MORE ON RESEARCH AND EVALUATION',
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
