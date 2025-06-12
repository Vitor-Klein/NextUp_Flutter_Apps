import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/header.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  ResourcesButton(
                    label: 'Calling the 988 Lifeline',
                    icon: FontAwesomeIcons.phone,
                    onPressed: () {
                      Navigator.pushNamed(context, '/calling_988_lifeline');
                    },
                  ),
                  ResourcesButton(
                    label: 'Texting the 988 Lifeline',
                    icon: FontAwesomeIcons.commentDots,
                    onPressed: () {
                      Navigator.pushNamed(context, '/texting_988_lifeline');
                    },
                  ),
                  ResourcesButton(
                    label: '988 Lifeline Chat',
                    icon: FontAwesomeIcons.comments,
                    onPressed: () {
                      Navigator.pushNamed(context, '/lifeline_chat');
                    },
                  ),
                  ResourcesButton(
                    label: 'About Us',
                    icon: FontAwesomeIcons.circleInfo,
                    onPressed: () {
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                  ResourcesButton(
                    label: 'Promoting the Lifeline',
                    icon: FontAwesomeIcons.bullhorn,
                    onPressed: () {
                      Navigator.pushNamed(context, '/promoting_lifeline');
                    },
                  ),
                  ResourcesButton(
                    label: 'Research and Evaluation',
                    icon: FontAwesomeIcons.chartLine,
                    onPressed: () {
                      Navigator.pushNamed(context, '/research_evaluation');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResourcesButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const ResourcesButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: FaIcon(icon, color: const Color(0xFF5280d5), size: 18),
        label: Text(label, style: const TextStyle(color: Color(0xFF5280d5))),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFb4dcf2),
          side: const BorderSide(color: Color(0xFF5280d5)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
