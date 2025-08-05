import 'package:flutter/material.dart';
import 'webview_page.dart';

class UploadImagePage extends StatelessWidget {
  const UploadImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewPage(
      title: 'Submit a Photo',
      url: 'https://appdocuments.com/forms/app/form?id=AoARBw&b=0',
    );
  }
}
