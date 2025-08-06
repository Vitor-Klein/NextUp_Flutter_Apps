import 'package:flutter/material.dart';
import 'webview_page.dart';

class SuportPage extends StatelessWidget {
  const SuportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      title: 'Suporte',
      url: 'https://appstorepublishing.com/suporte-nextup/',
    );
  }
}
