import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_animate/flutter_animate.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Positioned.fill(
            child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
          ),

          // Conteúdo
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // === Top bar (padding só aqui) ===
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 35,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PopupMenuButton<String>(
                        icon: Image.asset('assets/more_icon.png', height: 25),
                        onSelected: (value) {
                          switch (value) {
                            case 'submit_photo':
                              Navigator.pushNamed(context, '/upload_image');
                              break;
                            case 'know_before':
                              Navigator.pushNamed(context, '/know_before');
                              break;
                            case 'share_app':
                              _compartilharApp();
                              break;
                            case 'social':
                              Navigator.pushNamed(context, '/social');
                              break;
                            case 'email_us':
                              // _launchEmail();
                              break;
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'submit_photo',
                            child: Text('Submit a Photo'),
                          ),
                          PopupMenuItem(
                            value: 'know_before',
                            child: Text('Know Before You Go'),
                          ),
                          PopupMenuItem(
                            value: 'share_app',
                            child: Text('Share Our App'),
                          ),
                          PopupMenuItem(value: 'social', child: Text('Social')),
                          PopupMenuItem(
                            value: 'email_us',
                            child: Text('Email Us'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // === Botão central (padding só aqui) ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: _CentralActionButton(
                      imageAsset: 'assets/shop_button.png',
                      onTap: () => Navigator.pushNamed(context, '/connect'),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // === Primeira linha: 2 botões grandes (padding só aqui) ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _TopImageButton(
                        imageAsset: 'assets/shop_new_ford.png',
                        onTap: () => Navigator.pushNamed(context, '/about'),
                      ),
                      _TopImageButton(
                        imageAsset: 'assets/shop_new_lincoln.png',
                        onTap: () => Navigator.pushNamed(context, '/events'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // === Segunda linha: 3 botões pequenos colados (padding só aqui) ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: _BottomImageButton(
                          imageAsset: 'assets/service_button.png',
                          onTap: () => Navigator.pushNamed(context, '/about'),
                        ),
                      ),
                      Expanded(
                        child: _BottomImageButton(
                          imageAsset: 'assets/contact_us_button.png',
                          onTap: () => Navigator.pushNamed(context, '/contact'),
                        ),
                      ),
                      Expanded(
                        child: _BottomImageButton(
                          imageAsset: 'assets/share_button.png',
                          onTap: _compartilharApp,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 76), // dá espaço para o footer fixo
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/footer.png',
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class _CentralActionButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _CentralActionButton({required this.imageAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Animate(
        effects: [
          ScaleEffect(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            duration: 200.ms,
          ),
        ],
        onComplete: (c) => c.reverse(),
        child: Container(
          width: 250,
          height: 60,
          padding: const EdgeInsets.all(12),
          child: Image.asset(imageAsset, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _TopImageButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _TopImageButton({required this.imageAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Animate(
        effects: [
          ScaleEffect(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            duration: 200.ms,
          ),
        ],
        onComplete: (c) => c.reverse(),
        child: Container(
          height: 220,
          width: 180,
          // padding horizontal total 24 + gap 8
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(imageAsset, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _BottomImageButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _BottomImageButton({required this.imageAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Animate(
        effects: [
          ScaleEffect(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.03, 1.03),
            duration: 160.ms,
          ),
        ],
        onComplete: (c) => c.reverse(),
        child: Container(
          height: 110,
          child: Image.asset(imageAsset, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
