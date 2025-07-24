import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  Future<void> _ligarPara(String numero) async {
    final Uri telUri = Uri(scheme: 'tel', path: numero);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      print('Não foi possível iniciar a chamada para $numero');
    }
  }

  Future<void> _abrirUrl(String url) async {
    final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Não foi possível abrir o link: $url');
    }
  }

  Widget _linkText(String label, String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GestureDetector(
        onTap: () => _abrirUrl(url),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/header.jpg'),
            const Text(
              'Resources',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Helpful Phone Numbers:\n\nState and Community Organizations\n',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _ligarPara('8005831264'),
                  icon: const Icon(Icons.phone),
                  label: const Text('NAMI Oklahoma'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAEAEA),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _ligarPara('9185851213'),
                  icon: const Icon(Icons.phone),
                  label: const Text('Mental Health Association of Oklahoma'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAEAEA),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _ligarPara('3124022006'),
                  icon: const Icon(Icons.phone),
                  label: const Text('AFSP Oklahoma'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAEAEA),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Youth Mental Health\n',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Our Youth Mental Health service provides education for 2nd-12th graders in school districts across Oklahoma. With parental consent, the Association provides free, evidence-based mental health screenings to youth in grades 5th-12th. It is used to identify both general and mental health concerns, including suicide risk. If any concerns are discovered, the parent/guardian and screener will develop a plan to connect the teen with necessary treatment and support.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            _linkText(
              'COMPLETE FORM',
              'https://forms.office.com/pages/responsepage.aspx?id=zKILIYYJvUqfTN4sXKPzMnQflITrd-dCu9n8cDUTMHFUOTZUVzNBU0dGNUFPS1hTWkY3VzlFWlhMNy4u',
            ),
            const SizedBox(height: 24),
            const Text(
              'Children\'s Behavioral Health Coalition\n',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'The Children’s Behavioral Health partnership provides leadership and ongoing collaboration to support an accessible system of care for children, youth, and families. It ensures emotional, behavioral and social wellness by promoting family-driven integrated comprehensive services. Also, under this umbrella is our Empowered Voices youth program.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            _linkText(
              'LEARN MORE',
              'https://mhaok.org/about/suicide-prevention-form/',
            ),
            const SizedBox(height: 24),
            const Text(
              'Suicide Prevention Training\n',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Our one-hour emergency QPR training intervention teaches people how to recognize and respond positively to someone exhibiting suicide signs and behaviors. QPR, a nationally recognized evidenced-based training, stands for question, persuade and refer. Trainees will learn to question the individual’s meaning to determine suicide intent or desire, persuade the person to accept or seek help and refer them to the appropriate resources.\n\n'
              'Our QPR training will empower your business, school, faith community or civic organization to effectively intervene on behalf of someone with thoughts of suicide or who is in crisis. To schedule a QPR training for your business, school, faith community or civic organization, please give us a call at (918) 585-1213, (405) 943-3700 or by using the form below.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            _linkText(
              'COMPLETE FORM',
              'https://mhaok.org/about/suicide-prevention-form/',
            ),
            const SizedBox(height: 24),
            const Text(
              'Creating Connections\n',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Our Creating Connections program in Tulsa presents an alternative to isolation by breaking down barriers to social involvement while providing a stable atmosphere for participants. This critical program provides a safe way for participants to practice building relationships, engage in social connection, and join local community life.\n\n'
              'Each month, participants are invited to join in group activities and social outings such as seeing a movie, visiting the library, or enjoying a local museum. This type of support is proven to significantly reduce symptoms of mental illness, as well as expedite the recovery of individuals impacted by these struggles. We believe this growing service supports the people we serve by walking beside them on their road to recovery through connection and social inclusion.\n\n'
              'Creating Connections is open to adults ages 18 or above with a verified mental health diagnosis.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            _linkText(
              'REFERRAL FORM',
              'https://mhaok.org/creating-connections-referral/',
            ),
          ],
        ),
      ),
    );
  }
}
