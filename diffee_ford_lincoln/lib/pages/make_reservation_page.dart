import 'package:flutter/material.dart';

class MakeReservationPage extends StatelessWidget {
  const MakeReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário Simples')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preencha os campos abaixo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Campo Nome
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo Email
            const TextField(
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Campo Mensagem
            const TextField(
              decoration: InputDecoration(
                labelText: 'Mensagem',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            // Botão Enviar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // ação fictícia
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Formulário enviado!')),
                  );
                },
                child: const Text('Enviar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
