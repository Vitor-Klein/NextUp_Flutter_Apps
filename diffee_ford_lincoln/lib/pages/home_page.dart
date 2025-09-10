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

  bool showMakeReservation = false;
  bool showScheduleReservation = false;
  bool showFooter = false;
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

    final rcShowMakeReservation = remoteConfig.getBool('show_make_reservation');
    final rcShowFooter = remoteConfig.getBool('show_footer');
    final rcShowScheduleReservation = remoteConfig.getBool(
      'show_schedule_reservation',
    );
    final rcFooter = remoteConfig.getString('footer_link').trim();

    setState(() {
      showMakeReservation = rcShowMakeReservation;
      showScheduleReservation = rcShowScheduleReservation;
      showFooter = rcShowFooter;
      footerLink = rcFooter.isNotEmpty
          ? rcFooter
          : 'https://www.diffeeford.net/schedule-service.html'; // fallback seguro
    });
  }

  void _requestNotificationPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Permissões concedidas
    } else {
      // Permissões negadas
    }
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Usuário abriu a notificação
    });

    _firebaseMessaging.getToken().then((token) {
      // print('Token FCM: $token');
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
      body: LayoutBuilder(
        builder: (context, c) {
          final h = c.maxHeight;
          final w = c.maxWidth;

          double clamp(double v, double min, double max) =>
              v < min ? min : (v > max ? max : v);

          // Margens gerais
          final side = clamp(w * 0.05, 14, 22);
          final topBarPad = clamp(h * 0.02, 12, 24);

          // Gaps verticais entre blocos
          final gapXS = clamp(h * 0.18, 23, 120);
          final gapS = clamp(h * 0.02, 12, 20);
          final gapM = clamp(h * 0.03, 16, 28);
          final gapL = clamp(h * 0.04, 20, 36);

          // Botão central (maior, próximo ao mockup)
          final centralW = clamp(w * 0.40, 180, 250);
          final centralH = clamp(h * 0.07, 48, 56);

          // Cards do topo (2 lado a lado) — mais “retangulares”
          final topCardW = (w - side * 2 - gapS) / 2;
          final topCardAspect = 4 / 5; // w:h (mais próximo do mock)
          final topCardH = topCardW / topCardAspect;

          // Trinca inferior — um pouco menores
          final bottomSide = clamp(w * 0.5, 80, 117);
          final bottomHeight = clamp(h * 0.5, 80, 135);

          // Footer
          final footerH = clamp(h * 0.12, 88, 110);

          return Stack(
            children: [
              // Fundo
              Positioned.fill(
                child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
              ),

              // Conteúdo
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: side),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top bar com menu
                      Padding(
                        padding: EdgeInsets.only(top: topBarPad, bottom: gapS),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              icon: Image.asset(
                                'assets/more_icon.png',
                                height: clamp(h * 0.03, 20, 26),
                              ),
                              onSelected: (v) {
                                switch (v) {
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
                                  case 'messages':
                                    Navigator.pushNamed(context, '/messages');
                                    break;
                                }
                              },
                              itemBuilder: (context) {
                                final it = <PopupMenuEntry<String>>[];
                                if (showMakeReservation) {
                                  it.add(
                                    const PopupMenuItem(
                                      value: 'make_reservation',
                                      child: Text('Make a Reservation'),
                                    ),
                                  );
                                }
                                if (showScheduleReservation) {
                                  it.add(
                                    const PopupMenuItem(
                                      value: 'schedule_reservation',
                                      child: Text('Schedule a Reservation'),
                                    ),
                                  );
                                }
                                it.add(
                                  const PopupMenuItem(
                                    value: 'messages',
                                    child: Text('Messages'),
                                  ),
                                );
                                return it;
                              },
                            ),
                          ],
                        ),
                      ),

                      // Hero + botão central (fica um pouco mais alto e respiro melhor)
                      SizedBox(height: gapXS),
                      Center(
                        child: _CentralActionButton(
                          imageAsset: 'assets/shop_button.png',
                          width: centralW,
                          height: centralH,
                          onTap: () => openWeb(
                            context,
                            'https://www.diffeeford.net/used-inventory/index.htm',
                            title: 'Shop Pre-owned',
                          ),
                        ),
                      ),

                      SizedBox(height: gapM),

                      // Linha com 2 cards (Ford / Lincoln)
                      Row(
                        children: [
                          Expanded(
                            child: _TopImageButton(
                              imageAsset: 'assets/shop_new_ford.png',
                              width: topCardW,
                              height: topCardH,
                              onTap: () => openWeb(
                                context,
                                'https://www.diffeeford.net/',
                                title: 'Shop New Ford',
                              ),
                            ),
                          ),
                          SizedBox(width: gapS),
                          Expanded(
                            child: _TopImageButton(
                              imageAsset: 'assets/shop_new_lincoln.png',
                              width: topCardW,
                              height: topCardH,
                              onTap: () => openWeb(
                                context,
                                'https://www.diffeelincoln.com/',
                                title: 'Shop New Lincoln',
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: gapL),

                      // Trinca inferior (Service / Contact / Share)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _BottomImageButton(
                            imageAsset: 'assets/service_button.png',
                            side: bottomSide,
                            height: bottomHeight,
                            onTap: () => openWeb(
                              context,
                              'https://www.diffeeford.net/schedule-service.htm',
                              title: 'Service',
                            ),
                          ),
                          _BottomImageButton(
                            imageAsset: 'assets/contact_us_button.png',
                            side: bottomSide,
                            height: bottomHeight,

                            onTap: () =>
                                Navigator.pushNamed(context, '/contact'),
                          ),
                          _BottomImageButton(
                            imageAsset: 'assets/share_button.png',
                            side: bottomSide,
                            height: bottomHeight,

                            onTap: _compartilharApp,
                          ),
                        ],
                      ),

                      // Reserva pro footer
                      SizedBox(height: footerH * 0.70),
                    ],
                  ),
                ),
              ),

              // Footer fixo clicável
              if (showFooter)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () =>
                        openWeb(context, footerLink, title: 'Employee Pricing'),
                    child: Image.asset(
                      'assets/footer.png',
                      height: footerH,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CentralActionButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;
  final double width;
  final double height;
  const _CentralActionButton({
    required this.imageAsset,
    required this.onTap,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Animate(
        effects: [
          ScaleEffect(
            begin: const Offset(1, 1),
            end: const Offset(1.04, 1.04),
            duration: 160.ms,
          ),
        ],
        onComplete: (c) => c.reverse(),
        child: SizedBox(
          width: width,
          height: height,
          child: Image.asset(imageAsset, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _TopImageButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;
  final double width;
  final double height;
  const _TopImageButton({
    required this.imageAsset,
    required this.onTap,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Animate(
        effects: [
          ScaleEffect(
            begin: const Offset(1, 1),
            end: const Offset(1.03, 1.03),
            duration: 160.ms,
          ),
        ],
        onComplete: (c) => c.reverse(),
        child: Container(
          height: height,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
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
  final double side;
  final double height;
  const _BottomImageButton({
    required this.imageAsset,
    required this.onTap,
    required this.side,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Animate(
        effects: [],
        onComplete: (c) => c.reverse(),
        child: SizedBox(
          width: side,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.asset(imageAsset, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
