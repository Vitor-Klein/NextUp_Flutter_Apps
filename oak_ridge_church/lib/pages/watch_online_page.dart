import 'package:flutter/material.dart';
import 'webview_page.dart';

class WatchOnlinePage extends StatelessWidget {
  const WatchOnlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      title: 'Watch Online',
      url: 'https://ormbc.org/church-online/',
    );
  }
}
