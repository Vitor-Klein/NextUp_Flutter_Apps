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
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // ok
    }
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((_) {});
    _firebaseMessaging.getToken().then((token) => debugPrint('FCM: $token'));
  }

  void _initializeLocalNotifications() {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const init = InitializationSettings(android: android);
    _localNotifications.initialize(init);
  }

  void _showLocalNotification(RemoteMessage message) {
    const android = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'Descrição do canal',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: android);
    _localNotifications.show(
      0,
      message.notification?.title ?? 'Sem título',
      message.notification?.body ?? 'Sem conteúdo',
      details,
    );
  }

  Future<void> _compartilharApp() async {
    final rc = FirebaseRemoteConfig.instance;
    final link = Platform.isAndroid
        ? rc.getString('android_share_url')
        : rc.getString('ios_share_url');
    await SharePlus.instance.share(
      ShareParams(text: 'Check out this app:\n$link'),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isNarrow = w < 380;

    return Scaffold(
      extendBodyBehindAppBar:
          true, // deixa a imagem de fundo subir atrás da AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 30),
            onPressed: () {
              // ação ao clicar em "more"
              Navigator.pushNamed(context, '/more');
            },
          ),
          const SizedBox(width: 1),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fundo com imagem
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),

          // Banner no fundo
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: 1,
                child: Image.asset(
                  'assets/banner.png',
                  fit: BoxFit.contain,
                  height: 90,
                ),
              ),
            ),
          ),

          // Conteúdo principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 220),

                  // Título grande como imagem
                  Center(
                    child: Image.asset(
                      'assets/text.png',
                      fit: BoxFit.contain,
                      height: isNarrow ? 110 : 140,
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ImageButton(
                          imageAsset: 'assets/button_about.png',
                          height: 38,
                          onTap: () => Navigator.pushNamed(context, '/about'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ImageButton(
                          imageAsset: 'assets/button_photos.png',
                          height: 38,
                          onTap: () => Navigator.pushNamed(context, '/photos'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Exclusive Content',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _ImageBottomButton(
                          imageAsset: 'assets/watch.png',
                          height: 160,
                          onTap: () => _openUrl('https://example.com/watch'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ImageBottomButton(
                          imageAsset: 'assets/share.png',
                          height: 160,
                          onTap: _compartilharApp,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ImageBottomButton(
                          imageAsset: 'assets/enter_win.png',
                          height: 160,
                          onTap: () => _openUrl('https://example.com/contest'),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Botão de imagem reutilizável, garantindo MESMA ALTURA para todos
class _ImageButton extends StatelessWidget {
  final String imageAsset;
  final double height;
  final double borderRadius;
  final VoidCallback onTap;
  final BoxFit fit;

  const _ImageButton({
    required this.imageAsset,
    required this.onTap,
    this.height = 38,
    this.borderRadius = 0,
    this.fit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink.image(image: AssetImage(imageAsset), fit: fit),
        ),
      ),
    );
  }
}

class _ImageBottomButton extends StatelessWidget {
  final String imageAsset;
  final double height;
  final double borderRadius;
  final VoidCallback onTap;
  final BoxFit fit;

  const _ImageBottomButton({
    required this.imageAsset,
    required this.onTap,
    this.height = 0,
    this.borderRadius = 0,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink.image(image: AssetImage(imageAsset), fit: fit),
        ),
      ),
    );
  }
}
