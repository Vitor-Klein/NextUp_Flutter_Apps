import 'package:flutter/material.dart';

class ConsultPage extends StatelessWidget {
  const ConsultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultancy'),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem de header
            Image.asset(
              'assets/header.jpg',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Captação de Recursos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Em um mercado competitivo, a obtenção de recursos financeiros é fundamental para o crescimento e a sustentabilidade do seu negócio.\n\n'
                    'A Next.up oferece serviços especializados de captação de recursos, projetados para identificar e acessar as melhores oportunidades de financiamento para sua empresa.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Investigação Corporativa',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Em um ambiente de negócios complexo e dinâmico, informações precisas e confidenciais são cruciais para proteger seus ativos, mitigar riscos e tomar decisões estratégicas assertivas.\n\n'
                    'A Next.up oferece consultoria e serviços especializados de investigação corporativa, conduzidos com a máxima discrição, ética e profissionalismo.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
