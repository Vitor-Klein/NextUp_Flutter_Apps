import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool showMeetGreetButton = false;
  bool showBanner = false;
  String bannerImageUrl = '';
  String bannerLinkUrl = '';

  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions();
    _initializeFirebaseMessaging();
    _initializeLocalNotifications();
    _loadRemoteConfigValues();
  }

  Future<void> _loadRemoteConfigValues() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetchAndActivate();

      final visible = remoteConfig.getBool('meet_greet_visible');
      final bannerVisible = remoteConfig.getBool('show_banner');
      final bannerImage = remoteConfig.getString('banner_image_url');
      final bannerLink = remoteConfig.getString('banner_link_url');

      setState(() {
        showMeetGreetButton = visible;
        showBanner = bannerVisible;
        bannerImageUrl = bannerImage;
        bannerLinkUrl = bannerLink;
      });

      print('🎯 Meet & Greet visível? $visible');
    } catch (e) {
      print('❌ Erro ao acessar Remote Config: $e');
    }
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

    final String link =
        Platform.isAndroid
            ? remoteConfig.getString('android_share_url')
            : remoteConfig.getString('ios_share_url');

    final String mensagem = 'Check out this amazing app! Download now:\n$link';

    await SharePlus.instance.share(ShareParams(text: mensagem));
  }

  void _launchBanner() async {
    final Uri uri = Uri.parse(bannerLinkUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/Luke_background.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _compartilharApp,
                        child: const Icon(
                          Icons.share,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          size: 28,
                          color: Colors.white,
                        ),
                        color: Colors.white,
                        onSelected: (value) {
                          Navigator.pushNamed(context, value);
                        },
                        itemBuilder: (BuildContext context) {
                          final items = <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: '/podcast',
                              child: Row(
                                children: [
                                  Icon(Icons.mic_outlined, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text(
                                    'Podcast',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ];

                          if (showMeetGreetButton) {
                            items.add(
                              const PopupMenuItem<String>(
                                value: '/meet_greet',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Meet & Greet',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return items;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 280),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/Living_the_Gospel_Mission.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 8.5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ImageButton(
                        label: "",
                        imageAsset: 'assets/about_luke.png',
                        onTap: () {
                          Navigator.pushNamed(context, '/about');
                        },
                      ),
                      _ImageButton(
                        label: "",
                        imageAsset: 'assets/books_button.png',
                        onTap: () {
                          Navigator.pushNamed(context, '/books');
                        },
                      ),
                      _ImageButton(
                        label: "",
                        imageAsset: 'assets/messages_button.png',
                        onTap: () {
                          Navigator.pushNamed(context, '/messages');
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: GestureDetector(
                    onTap:
                        showBanner && bannerImageUrl.isNotEmpty
                            ? _launchBanner
                            : null,
                    child: Container(
                      width: double.infinity,
                      height: 110,
                      decoration: BoxDecoration(
                        color:
                            showBanner && bannerImageUrl.isNotEmpty
                                ? null
                                : Colors.transparent,
                        image:
                            showBanner && bannerImageUrl.isNotEmpty
                                ? DecorationImage(
                                  image: NetworkImage(bannerImageUrl),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                    ),
                  ),
                ),
              ],
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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageAsset),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
