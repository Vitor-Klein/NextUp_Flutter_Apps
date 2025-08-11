import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
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

    await Share.share(mensagem);
  }

  void _navegar(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/videos');
        break;
      case 1:
        Navigator.pushNamed(context, '/news');
        break;
      case 2:
        Navigator.pushNamed(context, '/events');
        break;
      case 3:
        Navigator.pushNamed(context, '/faq');
        break;
      case 4:
        Navigator.pushNamed(context, '/more');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com a imagem que você enviou
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg', // Coloque na pasta assets e registre no pubspec.yaml
              fit: BoxFit.cover,
            ),
          ),

          // Conteúdo principal com padding para não ficar atrás do menu
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ), // espaço para menu na área cinza
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 130),

                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/about'),
                    child: Image.asset('assets/about.png', height: 200),
                  ),
                  const SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ImageButton(
                          imageAsset: 'assets/request_visite.png',
                          onTap: () =>
                              Navigator.pushNamed(context, '/request_visit'),
                        ),
                        _ImageButton(
                          imageAsset: 'assets/handing.png',
                          onTap: () => Navigator.pushNamed(context, '/notice'),
                        ),
                        _ImageButton(
                          imageAsset: 'assets/form.png',
                          onTap: () =>
                              Navigator.pushNamed(context, '/question_form'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu sobreposto na parte inferior, sem sombra, transparente
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Container(
              // transparente, sem sombra, para ficar só os botões claros
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavButton(
                    icon: Icons.play_circle_fill,
                    label: "Videos",
                    onTap: () => _navegar(0),
                  ),
                  _NavButton(
                    icon: Icons.article,
                    label: "News",
                    onTap: () => _navegar(1),
                  ),
                  _NavButton(
                    icon: Icons.event,
                    label: "Events",
                    onTap: () => _navegar(2),
                  ),
                  _NavButton(
                    icon: Icons.help_outline,
                    label: "FAQ",
                    onTap: () => _navegar(3),
                  ),
                  _NavButton(
                    icon: Icons.more_horiz,
                    label: "More",
                    onTap: () => _navegar(4),
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

class _ImageButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _ImageButton({required this.imageAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Animate(
        effects: [
          ScaleEffect(
            begin: Offset(1.0, 1.0),
            end: Offset(1.1, 1.1),
            duration: 250.ms,
          ),
        ],
        onComplete: (controller) => controller.reverse(),
        child: ClipRRect(
          child: Image.asset(
            imageAsset,
            height: 160,
            width: 100,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: Colors.blueAccent, size: 28),
              const SizedBox(height: 2),
              Text(
                widget.label,
                style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
