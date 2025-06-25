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

  bool showBanner = false;
  String bannerImageUrl = '';
  String bannerLinkUrl = '';
  bool meetGreetVisible = false;

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
      showBanner = remoteConfig.getBool('show_banner');
      bannerImageUrl = remoteConfig.getString('banner_image_url');
      bannerLinkUrl = remoteConfig.getString('banner_link_url');
      meetGreetVisible = remoteConfig.getBool('meet_greet_visible');
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

    await Share.share(mensagem);
  }

  void _launchBanner() async {
    final Uri uri = Uri.parse(bannerLinkUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  Widget _buildBigTile(String label, String imagePath, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imagePath, height: 200, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onTap) {
    return _AnimatedIconButton(icon: icon, label: label, onTap: onTap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBigTile('About', 'assets/about.png', () {
                        Navigator.pushNamed(context, '/about');
                      }),
                      const SizedBox(width: 12),
                      _buildBigTile('Social', 'assets/Social.png', () {
                        Navigator.pushNamed(context, '/social');
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIconButton(Icons.video_library, 'Videos', () {
                        Navigator.pushNamed(context, '/videos');
                      }),
                      _buildIconButton(Icons.message, 'Messages', () {
                        Navigator.pushNamed(context, '/messages');
                      }),
                      _buildIconButton(Icons.share, 'Share', _compartilharApp),
                      if (meetGreetVisible) _buildMoreDropdown(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: showBanner && bannerImageUrl.isNotEmpty
                        ? _launchBanner
                        : null,
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: showBanner && bannerImageUrl.isNotEmpty
                            ? null
                            : Colors.transparent,
                        image: showBanner && bannerImageUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(bannerImageUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
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

  Widget _buildMoreDropdown() {
    return _AnimatedIconButton(
      icon: Icons.more_horiz,
      label: 'More',
      onTap: () {
        showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(
            MediaQuery.of(context).size.width - 100,
            MediaQuery.of(context).size.height - 100,
            0,
            0,
          ),
          color: Colors.grey.shade900,
          items: [
            if (meetGreetVisible)
              const PopupMenuItem<String>(
                value: 'meet_greet',
                child: Text(
                  'Meet & Greet',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            const PopupMenuItem<String>(
              value: 'podcast',
              child: Text('Podcast', style: TextStyle(color: Colors.white)),
            ),
          ],
        ).then((value) {
          if (value == 'meet_greet') {
            Navigator.pushNamed(context, '/meet_greet');
          } else if (value == 'podcast') {
            Navigator.pushNamed(context, '/podcast');
          }
        });
      },
    );
  }
}

class _AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AnimatedIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton> {
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() {
      _scale = 0.9;
    });
  }

  void _onTapUp(_) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(widget.icon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 4),
            Text(widget.label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
