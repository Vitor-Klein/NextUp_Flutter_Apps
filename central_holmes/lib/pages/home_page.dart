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
      showMenu = remoteConfig.getBool('show_menu');
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
          SizedBox.expand(
            child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 150),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: 180,
                      child: Image.asset(
                        'assets/title.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _ImageButton(
                    imageAsset: 'assets/call_988.png',
                    onTap: () async {
                      final telUri = Uri(scheme: 'tel', path: '988');
                      if (await canLaunchUrl(telUri)) {
                        await launchUrl(telUri);
                      }
                    },
                    height: 64,
                    borderRadius: 32,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ImageButton(
                          imageAsset: 'assets/messages.png',
                          onTap: () =>
                              Navigator.pushNamed(context, '/messages'),
                          height: 140,
                          borderRadius: 0,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ImageButton(
                          imageAsset: 'assets/share.png',
                          onTap: _compartilharApp,
                          height: 140,
                          borderRadius: 0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _ImageButton(
                          imageAsset: 'assets/about.png',
                          onTap: () => Navigator.pushNamed(context, '/about'),
                          height: 80,
                          borderRadius: 14,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ImageButton(
                          imageAsset: 'assets/resources.png',
                          onTap: () =>
                              Navigator.pushNamed(context, '/resources'),
                          height: 80,
                          borderRadius: 14,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ImageButton(
                          imageAsset: 'assets/more.png',
                          onTap: () => Navigator.pushNamed(context, '/more'),
                          height: 80,
                          borderRadius: 14,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                if (showStatus && statusImageUrl.isNotEmpty)
                  GestureDetector(
                    onTap: _launchBanner,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(statusImageUrl),
                          fit: BoxFit.contain,
                        ),
                        borderRadius: BorderRadius.circular(8),
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
  final String imageAsset;
  final VoidCallback onTap;
  final double height;
  final double borderRadius;
  final BoxFit fit;

  const _ImageButton({
    super.key,
    required this.imageAsset,
    required this.onTap,
    this.height = 140,
    this.borderRadius = 10,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.asset(imageAsset, fit: fit),
        ),
      ),
    );
  }
}
