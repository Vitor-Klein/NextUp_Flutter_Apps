import 'package:flutter/material.dart';
import 'webview_page.dart';

class AnnualMeetingPage extends StatelessWidget {
  const AnnualMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      title: 'Annual Meeting',
      url: 'https://opha.com/annual-convention/',
    );
  }
}
