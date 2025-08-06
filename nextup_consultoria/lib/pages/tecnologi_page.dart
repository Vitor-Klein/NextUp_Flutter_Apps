import 'package:flutter/material.dart';

class TecnologiPage extends StatelessWidget {
  const TecnologiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tecnologia'),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Image(image: AssetImage('assets/header.jpg')), // sem padding
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Na Next.up, a inovação é o coração do que fazemos.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Nossa equipe trabalha com as tecnologias mais modernas e avançadas do mercado para desenvolver soluções ágeis, seguras e escaláveis. '
                    'Utilizamos stacks atualizadas e ferramentas de ponta como Flutter, Node.js, Firebase, Docker e CI/CD com GitHub Actions, garantindo máxima performance e eficiência em todos os projetos.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Tecnologia como diferencial competitivo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Adotamos arquiteturas modernas, como microserviços e serverless, que nos permitem entregar produtos flexíveis e preparados para o futuro. '
                    'Estamos constantemente explorando novas tendências, como inteligência artificial, cloud computing e automação inteligente, para oferecer aos nossos clientes experiências digitais cada vez mais completas e inovadoras.\n\n'
                    'Na Next.up, tecnologia não é apenas ferramenta — é diferencial competitivo.',
                    style: TextStyle(fontSize: 16, height: 1.5),
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
