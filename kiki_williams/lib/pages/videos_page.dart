import 'package:flutter/material.dart';
import 'webview_page.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      title: 'Videos',
      url: 'https://www.tiktok.com/@kiki.williams42',
    );
  }
}
