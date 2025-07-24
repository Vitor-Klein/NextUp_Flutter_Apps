import 'package:flutter/material.dart';
import 'webview_page.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewPage(title: 'Education', url: 'https://opha.com/education/');
  }
}
