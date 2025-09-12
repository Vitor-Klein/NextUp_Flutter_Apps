import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ms_blood_service/pages/webview_page.dart';
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

    if (!mounted) return;
    setState(() {
      showMenu = remoteConfig.getBool('show_menu');
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

  Future<void> _openLink(String url, {String? fallbackRoute}) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted && fallbackRoute != null) {
      Navigator.pushNamed(context, fallbackRoute);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link.')),
      );
    }
  }

  Future<void> _call(String number) async {
    final digits = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: digits);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o discador.')),
      );
    }
  }

  // NÃO alterei o openWeb; use como já está definido no seu projeto.

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Helpers de responsividade (frações com limites para evitar distorção)
    double _bounded(double v, double min, double max) {
      if (v < min) return min;
      if (v > max) return max;
      return v;
    }

    final bool isShort = size.height < 700;

    // Posições e tamanhos responsivos
    final double heroTop = isShort ? size.height * 0.08 : size.height * 0.14;
    final double shareTop = heroTop + _bounded(size.height * 0.50, 120, 320);
    final double tilesHeight = _bounded(size.height * 0.18, 120, 200);
    final double tilesBottom = _bounded(size.height * 0.02, 80, 140);

    return Scaffold(
      body: Container(
        // Fundo cobre 100% da tela
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SizedBox.expand(
            child: Stack(
              children: [
                // Banner superior (donate) — clicável
                Positioned(
                  left: 36,
                  right: 36,
                  top: heroTop + 160,
                  child: InkWell(
                    onTap: () => openWeb(
                      context,
                      'https://msblood.com/give/',
                      title: "Donate Blood",
                    ),
                    child: AspectRatio(
                      aspectRatio: 10 / 5,
                      child: Image.asset(
                        'assets/donate.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 36,
                  right: 36,
                  top: shareTop,
                  child: Row(
                    children: [
                      Expanded(
                        child: _ImageTile(
                          asset: 'assets/blood_type.png',
                          onTap: () => openWeb(
                            context,
                            'https://msblood.com/blood-type',
                            title: "Blood Type",
                          ),
                          label: 'Blood Type',
                        ),
                      ),
                      Expanded(
                        child: _ImageTile(
                          asset: 'assets/donnor_history.png',
                          onTap: () => openWeb(
                            context,
                            'https://xpress.donorhistory.com/1/prescreen',
                            title: "Donor History",
                          ),
                          label: 'Donor History',
                        ),
                      ),
                      Expanded(
                        child: _ImageTile(
                          asset: 'assets/contact_us.png',
                          onTap: () => openWeb(
                            context,
                            'https://msblood.com/contact',
                            title: "Contact Us",
                          ),
                          label: 'Contact Us',
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  left: 36,
                  right: 36,
                  bottom: 0,

                  child: InkWell(
                    onTap: _compartilharApp,
                    child: SizedBox(
                      height: _bounded(size.height * 0.28, 160, 280),
                      child: Image.asset(
                        'assets/share.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;
  final String? label;

  const _ImageTile({required this.asset, required this.onTap, this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 130, // altura fixa para todos
            width: 130, // largura fixa para todos
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
          if (label != null && label!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              label!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
