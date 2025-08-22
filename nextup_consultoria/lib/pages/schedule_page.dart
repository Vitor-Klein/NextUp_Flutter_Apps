import 'package:flutter/material.dart';
import 'webview_page.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      title: 'Schedule Meeting',
      url: 'https://calendly.com/nextupconsultoria/15min',
    );
  }
}
