import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OportunitiPage extends StatefulWidget {
  const OportunitiPage({super.key});

  @override
  State<OportunitiPage> createState() => _OportunitiPageState();
}

class _OportunitiPageState extends State<OportunitiPage> {
  late final WebViewController _controller;
  bool _loading = true;

  static const String _url = 'https://nextup.com.br/oportunidades';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _loading = false),
          onNavigationRequest: (request) {
            // Mantém a navegação dentro da própria WebView
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oportunities'),
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
