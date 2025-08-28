import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  bool showStatus = false;
  String statusImageUrl = '';
  String statusLinkUrl = '';

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
      showStatus = remoteConfig.getBool('show_status');
      statusImageUrl = remoteConfig.getString('status_image_url');
      statusLinkUrl = remoteConfig.getString('status_link_url');
    });
  }

  void _launchBanner() async {
    if (statusLinkUrl.isEmpty) return;
    final Uri uri = Uri.parse(statusLinkUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  void _requestNotificationPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Permissões concedidas
    } else {
      // Permissões negadas
    }
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Usuário abriu a notificação
    });

    _firebaseMessaging.getToken().then((token) {
      // print('Token FCM: $token');
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
    final double buttonsBottom = (showStatus && statusImageUrl.isNotEmpty)
        ? 110
        : 30;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          SizedBox.expand(
            child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
          ),

          // Conteúdo
          SafeArea(
            child: SizedBox.expand(
              child: Stack(
                children: [
                  // Top menu
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          size: 28,
                          color: Colors.white,
                        ),
                        color: Colors.white,
                        onSelected: (value) {
                          Navigator.pushNamed(context, value);
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: '/messages',
                            child: Row(
                              children: const [
                                Icon(Icons.message, color: Colors.black),
                                SizedBox(width: 8),
                                Text(
                                  'Messages',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Botão grande (ligar 988)
                  Positioned.fill(
                    top: 300,
                    bottom: 220,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () async {
                          final Uri telUri = Uri(scheme: 'tel', path: '988');
                          if (await canLaunchUrl(telUri)) {
                            await launchUrl(telUri);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 200,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/A_Button.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Banner fixo no fundo (atrás dos botões)
                  if (showStatus && statusImageUrl.isNotEmpty)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: _launchBanner,
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(statusImageUrl),
                              fit: BoxFit.contain,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                  // Três botões (sempre acima do banner)
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: buttonsBottom,
                    top: 500,
                    child: Row(
                      children: [
                        Expanded(
                          child: _ImageButton(
                            label: "",
                            imageAsset: 'assets/About.png',
                            onTap: () => Navigator.pushNamed(context, '/about'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ImageButton(
                            label: "",
                            imageAsset: 'assets/Resources.png',
                            onTap: () =>
                                Navigator.pushNamed(context, '/resources'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ImageButton(
                            label: "",
                            imageAsset: 'assets/Share.png',
                            onTap: _compartilharApp,
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
            height: 140,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageAsset),
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(4, 10),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
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
