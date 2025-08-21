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

  bool showMore = false;

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
      showMore = remoteConfig.getBool('more_visible'); // <- lê o flag
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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // handle tap
    });

    _firebaseMessaging.getToken().then((token) {
      // print('Token FCM: $token');
    });
  }

  void _initializeLocalNotifications() {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    _localNotifications.initialize(initSettings);
  }

  void _showLocalNotification(RemoteMessage message) {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'Descrição do canal',
      importance: Importance.max,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);
    _localNotifications.show(
      0,
      message.notification?.title ?? 'Sem título',
      message.notification?.body ?? 'Sem conteúdo',
      platformDetails,
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link')),
      );
    }
  }

  void _shareApp() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final String link = Platform.isAndroid
        ? remoteConfig.getString('android_share_url')
        : remoteConfig.getString('ios_share_url');
    final String message = 'Check out this amazing app! Download now:\n$link';
    await SharePlus.instance.share(ShareParams(text: message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(''),
      ),
      body: Stack(
        children: [
          /// Fundo em tela cheia (troque por Asset/Network à sua escolha)
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg', // <- sua imagem de fundo
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ), // padding left e right
              child: Column(
                children: [
                  const Spacer(),
                  const SizedBox(height: 280),

                  // Primeira linha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ImageTile(
                        imageAsset: 'assets/about.png',
                        align: Alignment.centerLeft,
                        onTap: () => Navigator.pushNamed(context, '/about'),
                      ),
                      _ImageTile(
                        imageAsset: 'assets/social.png',
                        align: Alignment.centerRight,
                        onTap: () => Navigator.pushNamed(context, '/social'),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 30,
                  ), // espaçamento vertical entre as duas linhas
                  // Segunda linha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ImageTile(
                        imageAsset: 'assets/merch.png',
                        align: Alignment.centerLeft,
                        onTap: () => Navigator.pushNamed(context, '/merch'),
                      ),
                      _ImageTile(
                        imageAsset: 'assets/share.png',
                        align: Alignment.centerRight,
                        onTap: _shareApp,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ), // espaçamento vertical entre as duas linhas
                  // Segunda linha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ImageTile(
                        imageAsset: 'assets/messages.png',
                        align: Alignment.centerLeft,
                        onTap: () => Navigator.pushNamed(context, '/messages'),
                      ),
                      Visibility(
                        visible: showMore,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: _ImageTile(
                          imageAsset: 'assets/more.png',
                          align: Alignment.centerRight,
                          onTap: () => Navigator.pushNamed(context, '/more'),
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

/// Botão de imagem com ripple, cantos arredondados e leve sombra
class _ImageTile extends StatefulWidget {
  final String imageAsset;
  final Alignment align;
  final VoidCallback onTap;

  const _ImageTile({
    required this.imageAsset,
    required this.onTap,
    this.align = Alignment.center,
  });

  @override
  State<_ImageTile> createState() => _ImageTileState();
}

class _ImageTileState extends State<_ImageTile> {
  double _scale = 1.0;

  void _pressed(bool down) {
    setState(() => _scale = down ? 0.75 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapDown: (_) => _pressed(true),
        onTapCancel: () => _pressed(false),
        onTapUp: (_) => _pressed(false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: SizedBox(
            width: 130, // largura do “botão” (imagem)
            height: 30, // altura
            child: ClipRRect(
              child: Image.asset(
                widget.imageAsset,
                fit: BoxFit.fitHeight,
                alignment: widget.align,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
