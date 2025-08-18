import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:diffee_ford_lincoln/pages/webview_page.dart';

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
  String footerLink =
      'https://www.diffeeford.net/schedule-service.htm'; // fallback

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

    final rcShowMenu = remoteConfig.getBool('show_menu');
    final rcFooter = remoteConfig.getString('footer_link').trim();

    setState(() {
      showMenu = rcShowMenu;
      footerLink = rcFooter.isNotEmpty
          ? rcFooter
          : 'https://www.diffeeford.net/schedule-service.htm'; // fallback seguro
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Positioned.fill(
            child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
          ),

          // Conteúdo
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 25,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: showMenu,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: PopupMenuButton<String>(
                          icon: Image.asset('assets/more_icon.png', height: 25),
                          onSelected: (value) {
                            switch (value) {
                              case 'make_reservation':
                                Navigator.pushNamed(
                                  context,
                                  '/make_reservation',
                                );
                                break;
                              case 'schedule_reservation':
                                Navigator.pushNamed(
                                  context,
                                  '/schedule_test_drive',
                                );
                                break;
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'make_reservation',
                              child: Text('Make a Reservation'),
                            ),
                            PopupMenuItem(
                              value: 'schedule_reservation',
                              child: Text('Schedule a Reservation'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: _CentralActionButton(
                      imageAsset: 'assets/shop_button.png',
                      onTap: () => openWeb(
                        context,
                        'https://www.diffeeford.net/used-inventory/index.htm',
                        title: 'Shop Pré-owned', // opcional
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _TopImageButton(
                        imageAsset: 'assets/shop_new_ford.png',
                        onTap: () => openWeb(
                          context,
                          'https://www.diffeeford.net/',
                          title: 'Shop New Ford', // opcional
                        ),
                      ),
                      _TopImageButton(
                        imageAsset: 'assets/shop_new_lincoln.png',
                        onTap: () => openWeb(
                          context,
                          'https://www.diffeelincoln.com/',
                          title: 'Shop New Lincoln', // opcional
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: _BottomImageButton(
                          imageAsset: 'assets/service_button.png',
                          onTap: () => openWeb(
                            context,
                            'https://www.diffeeford.net/schedule-service.htm',
                            title: 'Service', // opcional
                          ),
                        ),
                      ),
                      Expanded(
                        child: _BottomImageButton(
                          imageAsset: 'assets/contact_us_button.png',
                          onTap: () => Navigator.pushNamed(context, '/contact'),
                        ),
                      ),
                      Expanded(
                        child: _BottomImageButton(
                          imageAsset: 'assets/share_button.png',
                          onTap: _compartilharApp,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 76), // espaço para o footer fixo
              ],
            ),
          ),

          // Footer clicável controlado por 'footer_link'
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => openWeb(
                context,
                footerLink, // <-- do Remote Config
                title: 'Employee Pricing',
              ),
              child: Image.asset(
                'assets/footer.png',
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CentralActionButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _CentralActionButton({required this.imageAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Animate(
        effects: [
          ScaleEffect(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            duration: 200.ms,
          ),
        ],
        onComplete: (c) => c.reverse(),
        child: Container(
          width: 250,
          height: 60,
          padding: const EdgeInsets.all(12),
          child: Image.asset(imageAsset, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _TopImageButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _TopImageButton({required this.imageAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Animate(
        effects: [
          ScaleEffect(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            duration: 200.ms,
          ),
        ],
        onComplete: (c) => c.reverse(),
        child: Container(
          height: 220,
          width: 180,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(imageAsset, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _BottomImageButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _BottomImageButton({required this.imageAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Animate(
        effects: [
          ScaleEffect(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.03, 1.03),
            duration: 160.ms,
          ),
        ],
        onComplete: (c) => c.reverse(),
        child: SizedBox(
          height: 110,
          child: Image.asset(imageAsset, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
