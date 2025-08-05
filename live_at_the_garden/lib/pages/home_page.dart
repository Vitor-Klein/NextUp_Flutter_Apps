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
          Positioned.fill(
            child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo no canto superior esquerdo
                      Image.asset('assets/logo.png', height: 40),
                      // Ícones no canto superior direito
                      Row(
                        children: [
                          PopupMenuButton<String>(
                            icon: Image.asset('assets/more.png', height: 40),
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
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'submit_photo',
                                child: Text('Submit a Photo'),
                              ),
                              const PopupMenuItem(
                                value: 'know_before',
                                child: Text('Know Before You Go'),
                              ),
                              const PopupMenuItem(
                                value: 'share_app',
                                child: Text('Share Our App'),
                              ),
                              const PopupMenuItem(
                                value: 'social',
                                child: Text('Social'),
                              ),
                              const PopupMenuItem(
                                value: 'email_us',
                                child: Text('Email Us'),
                              ),
                            ],
                          ),

                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/messages'),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Image.asset(
                                'assets/notification.png',
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 280),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ImageButton(
                        imageAsset: 'assets/about.png',
                        onTap: () => Navigator.pushNamed(context, '/about'),
                      ),
                      _ImageButton(
                        imageAsset: 'assets/events.png',
                        onTap: () => Navigator.pushNamed(context, '/events'),
                      ),
                      _ImageButton(
                        imageAsset: 'assets/pictures.png',
                        onTap: () => Navigator.pushNamed(context, '/pictures'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _ImageCard(
                    imageAsset: 'assets/event_gallery.png',
                    onTap: () => Navigator.pushNamed(context, '/contact'),
                    height: 120,
                  ),
                  const SizedBox(height: 18),
                  _ImageCard(
                    imageAsset: 'assets/banner.png',
                    onTap: () => Navigator.pushNamed(context, '/'),
                    height: 100,
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
  final String imageAsset;
  final VoidCallback onTap;

  const _ImageButton({required this.imageAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Animate(
        effects: [
          ScaleEffect(
            begin: Offset(1.0, 1.0),
            end: Offset(1.1, 1.1),
            duration: 250.ms,
          ),
        ],
        onComplete: (controller) => controller.reverse(),
        child: Image.asset(
          imageAsset,
          height: 160,
          width: 110,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;
  final double height; // novo parâmetro

  const _ImageCard({
    required this.imageAsset,
    required this.onTap,
    this.height = 120, // valor padrão
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Animate(
        effects: [FadeEffect(duration: 300.ms)],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imageAsset,
            height: height,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
