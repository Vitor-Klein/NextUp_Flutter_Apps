import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final blue = Colors.blueAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho opcional (mantenha sua imagem em assets/header.jpg)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset('assets/header.jpg', fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),

            const Text(
              'Central Holmes Christian School',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const SelectableText(
              """Central Holmes Christian School is a private Christian school in Lexington, Mississippi. It includes an elementary, middle, and high school grades K3-12. Central Holmes Christian School’s mission is to provide a college preparatory curriculum in a safe environment. It emphasizes the role of young people as productive American citizens and offers extra-curricular activities to provide positive experiences for developing a sense of purpose and well-being.""",
              style: TextStyle(fontSize: 16, height: 1.6),
            ),

            const SizedBox(height: 24),
            Text(
              'Our Objectives',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: blue.shade700,
              ),
            ),
            const SizedBox(height: 12),

            const _ObjectiveItem(
              number: 1,
              text:
                  'To provide a curriculum which meets college entrance requirements.',
            ),
            const _ObjectiveItem(
              number: 2,
              text:
                  'To develop an awareness of the student’s responsibility as a productive citizen and to provide opportunities to develop good citizenship.',
            ),
            const _ObjectiveItem(
              number: 3,
              text: 'To provide a safe learning environment.',
            ),
            const _ObjectiveItem(
              number: 4,
              text:
                  'To instill respect for authority, rules, rights of others, and America.',
            ),
            const _ObjectiveItem(
              number: 5,
              text:
                  'To motivate students to achieve their highest educational goals.',
            ),
            const _ObjectiveItem(
              number: 6,
              text:
                  'To provide assistance in strengthening weaknesses in students.',
            ),
            const _ObjectiveItem(
              number: 7,
              text:
                  'To initiate a form of discipline that promotes cooperation.',
            ),
            const _ObjectiveItem(
              number: 8,
              text: 'To provide guidance through counseling and testing.',
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ObjectiveItem extends StatelessWidget {
  final int number;
  final String text;

  const _ObjectiveItem({required this.number, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final blue = Colors.blueAccent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bolinha numerada
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: blue.shade100,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: blue.shade700),
            ),
            child: Text(
              '$number',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: blue.shade700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Texto
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
