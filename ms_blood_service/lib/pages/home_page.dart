import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ms_blood_service/pages/webview_page.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool showMenu = false;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions();
    _initializeFirebaseMessaging();
    _initializeLocalNotifications();
    _loadBannerConfig();
  }

  Future<void> _loadBannerConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    setState(() {
      showMenu = remoteConfig.getBool('show_menu');
    });
  }

  void _requestNotificationPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permissões de notificação concedidas');
    } else {
      print('Permissões de notificação negadas');
    }
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Recebeu mensagem no foreground: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Usuário abriu a notificação');
    });

    _firebaseMessaging.getToken().then((token) {
      print('Token FCM: $token');
    });
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    _localNotifications.initialize(initSettings);
  }

  void _showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'Descrição do canal',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    _localNotifications.show(
      0,
      message.notification?.title ?? 'Sem título',
      message.notification?.body ?? 'Sem conteúdo',
      platformDetails,
    );
  }

  void _compartilharApp() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    final String link = Platform.isAndroid
        ? remoteConfig.getString('android_share_url')
        : remoteConfig.getString('ios_share_url');

    final String mensagem = 'Check out this amazing app! Download now:\n$link';

    await SharePlus.instance.share(ShareParams(text: mensagem));
  }

  Future<void> _openLink(String url, {String? fallbackRoute}) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted && fallbackRoute != null) {
      Navigator.pushNamed(context, fallbackRoute);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link.')),
      );
    }
  }

  Future<void> _call(String number) async {
    final digits = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: digits);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o discador.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (showMenu)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _compartilharApp,
            ),
        ],
      ),
      body: Stack(
        children: [
          // IMAGEM DE FUNDO
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg', // ajuste o caminho
              fit: BoxFit.cover,
            ),
          ),

          // CAMADA DE CONTEÚDO
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // IMAGEM RETANGULAR COMPRIDA CLICÁVEL (banner/topo)
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/about'),
                    child: ClipRRect(
                      child: AspectRatio(
                        aspectRatio: 16 / 5, // “retangular comprido”
                        child: Image.asset(
                          'assets/donate.png', // ajuste
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3 IMAGENS CLICÁVEIS EM LINHA
                  Row(
                    children: [
                      Expanded(
                        child: _ImageTile(
                          asset: 'assets/blood_type.png', // ajuste
                          onTap: () => openWeb(
                            context,
                            'https://msblood.com/blood-type',
                            title: "Blood Type",
                          ),
                          label: 'Blood Type',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ImageTile(
                          asset: 'assets/donnor_history.png', // ajuste
                          onTap: () => openWeb(
                            context,
                            'https://xpress.donorhistory.com/1/prescreen',
                            title: "Donor History",
                          ),
                          label: 'Donor History',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ImageTile(
                          asset: 'assets/contact_us.png', // ajuste
                          onTap: () => openWeb(
                            context,
                            'https://msblood.com/contact',
                            title: "Contact Us",
                          ),
                          label: 'Contact Us',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // GRANDE IMAGEM CLICÁVEL (hero)
                  InkWell(
                    onTap: () => _compartilharApp(),
                    child: ClipRRect(
                      child: Image.asset(
                        'assets/share.png', // ajuste
                        fit: BoxFit.cover,
                        height: size.height * 0.32, // grande e responsivo
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;
  final String? label;

  const _ImageTile({required this.asset, required this.onTap, this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 1, // quadradinho bonito
              child: Image.asset(asset, fit: BoxFit.cover),
            ),
          ),
          if (label != null && label!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              label!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
