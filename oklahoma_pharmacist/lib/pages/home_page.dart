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

  bool showStatus = false;
  bool showMenu = false;
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
      showMenu = remoteConfig.getBool('show_menu');
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

  void _onMenuSelected(String value) {
    switch (value) {
      case 'share':
        _compartilharApp();
        break;
      case 'messages':
        Navigator.pushNamed(context, '/messages');
        break;
      case 'social':
        Navigator.pushNamed(context, '/social');
        break;
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/logo.png', height: 60),
                        if (showMenu)
                          PopupMenuButton<String>(
                            icon: Image.asset('assets/menu.png', height: 40),
                            onSelected: _onMenuSelected,
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'share',
                                child: Text('Share'),
                              ),
                              const PopupMenuItem(
                                value: 'messages',
                                child: Text('Messages'),
                              ),
                              const PopupMenuItem(
                                value: 'social',
                                child: Text('Social'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  Image.asset('assets/description.png', height: 50),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ImageButton(
                        imageAsset: 'assets/about.png',
                        onTap: () => Navigator.pushNamed(context, '/about'),
                      ),
                      const SizedBox(width: 0),
                      _ImageButton(
                        imageAsset: 'assets/events.png',
                        onTap: () => Navigator.pushNamed(context, '/events'),
                      ),
                      const SizedBox(width: 0),
                      _ImageButton(
                        imageAsset: 'assets/contact.png',
                        onTap: () => Navigator.pushNamed(context, '/contact'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const SizedBox(height: 8),
                        _ImageCard(
                          imageAsset: 'assets/district_meeting.png',
                          onTap: () =>
                              Navigator.pushNamed(context, '/district_meeting'),
                        ),
                        const SizedBox(height: 8),
                        _ImageCard(
                          imageAsset: 'assets/membership.png',
                          onTap: () =>
                              Navigator.pushNamed(context, '/membership'),
                        ),
                        const SizedBox(height: 8),
                        _ImageCard(
                          imageAsset: 'assets/education.png',
                          onTap: () =>
                              Navigator.pushNamed(context, '/education'),
                        ),
                      ],
                    ),
                  ),
                  if (showStatus)
                    GestureDetector(
                      onTap: _launchBanner,
                      child: Container(
                        height: 68,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage('assets/banner.png'),
                            fit: BoxFit.contain,
                          ),
                          borderRadius: BorderRadius.circular(0),
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

class _ImageButton extends StatefulWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _ImageButton({required this.imageAsset, required this.onTap});

  @override
  State<_ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<_ImageButton> {
  Key animateKey = UniqueKey();

  void _handleTap() {
    setState(() {
      animateKey = UniqueKey();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      key: animateKey,
      effects: [
        ScaleEffect(
          begin: Offset(1.0, 1.0),
          end: Offset(1.1, 1.1),
          duration: 150.ms,
          curve: Curves.easeOut,
        ),
      ],
      onComplete: (controller) => controller.reverse(),
      child: GestureDetector(
        onTap: _handleTap,
        child: Image.asset(
          widget.imageAsset,
          height: 100,
          width: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _ImageCard extends StatefulWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _ImageCard({required this.imageAsset, required this.onTap});

  @override
  State<_ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<_ImageCard> {
  Key animateKey = UniqueKey();

  void _handleTap() {
    setState(() {
      animateKey = UniqueKey();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      key: animateKey,
      effects: [
        ScaleEffect(
          begin: Offset(1.0, 1.0),
          end: Offset(1.1, 1.1),
          duration: 150.ms,
          curve: Curves.easeOut,
        ),
      ],
      onComplete: (controller) => controller.reverse(),
      child: GestureDetector(
        onTap: _handleTap,
        child: Image.asset(
          widget.imageAsset,
          height: 100,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
