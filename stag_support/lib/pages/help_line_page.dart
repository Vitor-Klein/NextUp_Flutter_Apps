import 'package:flutter/material.dart';

class HelpLinePage extends StatelessWidget {
  const HelpLinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HelpLinePage')),
      body: const Center(child: Text('Página About')),
    );
  }
}
