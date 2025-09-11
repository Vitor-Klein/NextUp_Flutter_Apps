import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mda_workforce/pages/webview_page.dart';
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

  Future<void> _openMoreMenu() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            widthFactor: 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'More Options',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.phone,
                        color: Color(0xFF2b4a83),
                      ),
                      title: const Text('Phone list'),
                      onTap: () => Navigator.pop(ctx, 'phone_list'),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.share,
                        color: Color(0xFF2b4a83),
                      ),
                      title: const Text('Share'),
                      onTap: () => Navigator.pop(ctx, 'share'),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.message,
                        color: Color(0xFF2b4a83),
                      ),
                      title: const Text('Messages'),
                      onTap: () => Navigator.pop(ctx, 'messages'),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (!mounted) return;

    switch (result) {
      case 'phone_list':
        // Garanta que a rota '/phone-list' exista no seu MaterialApp
        Navigator.pushNamed(context, '/phones');
        break;
      case 'share':
        _compartilharApp();
        break;
      case 'messages':
        Navigator.pushNamed(context, '/messages');
        break;
      default:
        break;
    }
  }

  Future<void> _call(String number) async {
    // Normaliza para apenas dígitos, e usa tel:
    final digits = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: digits);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o discador.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND em tela cheia
          Positioned.fill(
            child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
          ),

          // CONTEÚDO
          SafeArea(
            child: SizedBox.expand(
              child: Stack(
                children: [
                  // IMAGEM GRANDE CENTRAL (logo/selo) — CLICÁVEL
                  Positioned(
                    left: 16,
                    right: 16,
                    top: size.height * 0.32,
                    child: GestureDetector(
                      onTap: () => openWeb(
                        context,
                        'https://mississippi.org/contact/',
                        title: "Let's Talk",
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/body.png',
                          width: size.width * 0.75,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // 3 IMAGENS CLICÁVEIS (linha)
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 150, // deixa espaço para o footer
                    child: Row(
                      children: [
                        Expanded(
                          child: _ImageButton(
                            label: '',
                            imageAsset: 'assets/about.png',
                            onTap: () => Navigator.pushNamed(context, '/about'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ImageButton(
                            label: '',
                            imageAsset: 'assets/leadership.png',
                            onTap: () => openWeb(
                              context,
                              'https://mississippi.org/about/leadership/',
                              title: 'Leadership',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ImageButton(
                            label: '',
                            imageAsset: 'assets/emergency.png',
                            onTap: () => _call('6013599449'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // FOOTER CLICÁVEL (imagem larga) -> abre o bottom sheet
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 16,
                    child: GestureDetector(
                      onTap: _openMoreMenu,
                      child: Container(
                        height: 88,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/more.png'),
                            fit: BoxFit.contain,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  // (Opcional) menu no topo como no seu exemplo
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (v) => Navigator.pushNamed(context, v),
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: '/messages',
                          child: Row(
                            children: [
                              Icon(Icons.message, color: Colors.black),
                              SizedBox(width: 8),
                              Text('Messages'),
                            ],
                          ),
                        ),
                      ],
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

class _ImageButton extends StatelessWidget {
  final String label;
  final String imageAsset;
  final VoidCallback onTap;

  const _ImageButton({
    required this.label,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageAsset),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (label.isNotEmpty)
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
