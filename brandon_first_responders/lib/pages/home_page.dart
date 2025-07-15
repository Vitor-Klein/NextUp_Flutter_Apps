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
    final Uri uri = Uri.parse(statusLinkUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  void _requestNotificationPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
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
          SizedBox.expand(
            child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 220),
                  GestureDetector(
                    onTap: () async {
                      final Uri telUri = Uri(scheme: 'tel', path: '988');
                      if (await canLaunchUrl(telUri)) {
                        await launchUrl(telUri);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/Call-Button.png'),
                          fit: BoxFit.contain,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: _SquareImageButton(
                          imageAsset: 'assets/resources.png',
                          onTap: () =>
                              Navigator.pushNamed(context, '/resources'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SquareImageButton(
                          imageAsset: 'assets/share.png',
                          onTap: _compartilharApp,
                        ),
                      ),
                    ],
                  ),

                  /// Imagem retangular 1 (About)
                  _RectImageButton(
                    imageAsset: 'assets/Button-About.png',
                    onTap: () => Navigator.pushNamed(context, '/about'),
                  ),

                  /// Imagem retangular 2 (ADS)
                  _RectImageButton(
                    imageAsset: 'assets/Ads.png',
                    onTap: () {
                      // Adicione a navegação ou ação desejada
                    },
                  ),

                  /// Banner do Remote Config
                  if (showStatus && statusImageUrl.isNotEmpty)
                    GestureDetector(
                      onTap: _launchBanner,
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(statusImageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 80,
            right: 16,
            child: Material(
              color: Colors.lightBlue,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.menu, color: Colors.white),
                onSelected: (value) {
                  if (value == 'messages') {
                    Navigator.pushNamed(context, '/messages');
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'messages',
                    child: Row(
                      children: [
                        Icon(Icons.message),
                        SizedBox(width: 8),
                        Text('Messages'),
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

class _SquareImageButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _SquareImageButton({required this.imageAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageAsset),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class _RectImageButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _RectImageButton({required this.imageAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageAsset),
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
