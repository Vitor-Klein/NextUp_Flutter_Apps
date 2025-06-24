// Podcast_page.dart
import 'package:flutter/material.dart';
import 'webview_page.dart';

class PodcastPage extends StatelessWidget {
  const PodcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      title: 'Podcast',
      url: 'http://play.obedira.com.py:8300/live',
    );
  }
}
