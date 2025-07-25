import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'webview_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  String contactUrl = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContactUrl();
  }

  Future<void> _loadContactUrl() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    setState(() {
      contactUrl = remoteConfig.getString('contact_url');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (contactUrl.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Erro ao carregar o link de contato.')),
      );
    }

    return WebViewPage(title: 'Contact', url: contactUrl);
  }
}
