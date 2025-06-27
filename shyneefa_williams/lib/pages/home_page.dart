import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
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

  bool showBanner = false;
  String bannerImageUrl = '';
  String bannerLinkUrl = '';
  bool showMoreButton = true;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions();
    _initializeFirebaseMessaging();
    _initializeLocalNotifications();
    _loadBannerConfig();
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
      channelDescription: 'Canal para notificações em foreground',
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

  void _compartilharApp() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    final String link = Platform.isAndroid
        ? remoteConfig.getString('android_share_url')
        : remoteConfig.getString('ios_share_url');

    final String mensagem = 'Check out this amazing app! Download now:\n$link';

    await SharePlus.instance.share(ShareParams(text: mensagem));
  }

  Future<void> _loadBannerConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    setState(() {
      showBanner = remoteConfig.getBool('show_banner');
      bannerImageUrl = remoteConfig.getString('banner_image_url');
      bannerLinkUrl = remoteConfig.getString('banner_link_url');
      showMoreButton = remoteConfig.getBool('show_more');
    });
  }

  void _launchBanner() async {
    final Uri _url = Uri.parse(bannerLinkUrl);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url, mode: LaunchMode.platformDefault);
    }
  }

  Widget _buildGradientButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(vertical: 2),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0x00FFFFFF), Color(0xFFd4def7), Color(0xFF5280d5)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 0.4, 1.2],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Text(
            text,
            style: GoogleFonts.bebasNeue(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26,
              letterSpacing: 1.8,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
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
                const Spacer(flex: 35),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildGradientButton(
                          "ABOUT",
                          () => Navigator.pushNamed(context, '/about'),
                        ),
                        _buildGradientButton(
                          "SOCIAL",
                          () => Navigator.pushNamed(context, '/social'),
                        ),
                        _buildGradientButton(
                          "VIDEOS",
                          () => Navigator.pushNamed(context, '/videos'),
                        ),
                        _buildGradientButton(
                          "MESSAGES",
                          () => Navigator.pushNamed(context, '/messages'),
                        ),
                        _buildGradientButton("SHARE", _compartilharApp),
                        if (showMoreButton)
                          _buildGradientButton(
                            "MORE",
                            () => Navigator.pushNamed(context, '/more'),
                          ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 1),

                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: GestureDetector(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
