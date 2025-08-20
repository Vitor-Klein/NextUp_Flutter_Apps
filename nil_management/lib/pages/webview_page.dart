import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Abre uma WebView em tela cheia recebendo apenas a URL.
/// Opcional: [title] para mostrar no AppBar (senão usa o host da URL).
Future<void> openWeb(BuildContext context, String url, {String? title}) async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => _InlineWebView(url: url, title: title),
    ),
  );
}

// Widget privado — não precisa expor nenhuma classe pública.
class _InlineWebView extends StatefulWidget {
  final String url;
  final String? title;

  const _InlineWebView({required this.url, this.title});

  @override
  State<_InlineWebView> createState() => _InlineWebViewState();
}

class _InlineWebViewState extends State<_InlineWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final host = Uri.tryParse(widget.url)?.host ?? 'Web';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? host),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () async {
              final uri = Uri.parse(widget.url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
