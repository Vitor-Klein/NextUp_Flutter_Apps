import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions();
    _initializeFirebaseMessaging();
    _initializeLocalNotifications();
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

  Widget _buildGradientButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(vertical: 2),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(
                0x00FFFFFF,
              ), // branco totalmente transparente (00 = 0% opacidade)
              Color(0xFFd4def7), // azul claro
              Color(0xFF5280d5), // azul escuro
            ],
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
            child: Image.asset(
              'assets/background_image.jpg', // Substitua pela imagem correta
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(
                  flex: 8,
                ), // Espaço antes dos botões (empurra eles para baixo)

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
                        _buildGradientButton(
                          "MORE",
                          () => Navigator.pushNamed(context, '/more'),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(
                  flex: 2,
                ), // Espaço depois dos botões (ajusta altura final)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
