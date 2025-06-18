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
      print('Recebeu mensagem no foreground: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Usuário abriu a notificação');
      // Navegação futura, se necessário
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
          // Imagem de fundo
          SizedBox.expand(
            child: Image.asset('assets/stagbg.jpg', fit: BoxFit.cover),
          ),

          // Conteúdo por cima da imagem de fundo
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 7),

                // Container branco com os 3 botões
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ImageButton(
                          imagePath: 'assets/helpLine.png',
                          onTap: () async {
                            final Uri telUri = Uri(scheme: 'tel', path: '988');
                            if (await canLaunchUrl(telUri)) {
                              await launchUrl(telUri);
                            } else {
                              print('Não foi possível iniciar a chamada.');
                            }
                          },
                        ),

                        _ImageButton(
                          imagePath: 'assets/resources.png',
                          onTap: () {
                            Navigator.pushNamed(context, '/resources');
                          },
                        ),
                        _ImageButton(
                          imagePath: 'assets/share.png',
                          onTap: _compartilharApp,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const _ImageButton({required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(imagePath, width: 110, height: 120),
    );
  }
}
