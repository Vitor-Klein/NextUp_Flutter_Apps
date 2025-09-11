import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
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
          /// Fundo
          Positioned.fill(
            child: Image.asset("assets/background.jpg", fit: BoxFit.cover),
          ),

          /// Conteúdo
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Botão retangular comprido (CTA)
                CtaBannerButton(
                  assetPath: "assets/donate.png",
                  routeName: "/donate", // ajuste conforme suas rotas
                ),

                const SizedBox(height: 24),

                // Linha com 3 botões
                TripleMenuRow(
                  items: const [
                    NavItem(
                      assetPath: "assets/blood_type.png",
                      routeName: "/bloodType",
                    ),
                    NavItem(
                      assetPath: "assets/donnor_history.png",
                      routeName: "/donorHistory",
                    ),
                    NavItem(
                      assetPath: "assets/contact_us.png",
                      routeName: "/contactUs",
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Imagem grande clicável embaixo
                _LargeImageButton(
                  assetPath: "assets/share.png",
                  routeName: "/spreadTheWord",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem {
  final String assetPath;
  final String routeName;
  const NavItem({required this.assetPath, required this.routeName});
}

class CtaBannerButton extends StatelessWidget {
  final String assetPath;
  final String routeName;
  const CtaBannerButton({
    super.key,
    required this.assetPath,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, routeName),
        child: Ink(
          width: double.infinity,
          child: ClipRRect(child: Image.asset(assetPath, fit: BoxFit.cover)),
        ),
      ),
    );
  }
}

class TripleMenuRow extends StatelessWidget {
  final List<NavItem> items;
  const TripleMenuRow({super.key, required this.items})
    : assert(items.length == 3, "TripleMenuRow requer exatamente 3 itens.");

  @override
  Widget build(BuildContext context) {
    Widget buildTile(NavItem item) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, item.routeName),
              child: Ink(
                height: 90,
                child: ClipRRect(
                  child: Image.asset(item.assetPath, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(children: items.map(buildTile).toList());
  }
}

class _LargeImageButton extends StatelessWidget {
  final String assetPath;
  final String routeName;
  const _LargeImageButton({required this.assetPath, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, routeName),
        child: Ink(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(assetPath, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
