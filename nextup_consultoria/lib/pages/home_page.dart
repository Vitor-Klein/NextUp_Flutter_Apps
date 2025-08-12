import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    _loadRemoteConfig();
  }

  Future<void> _loadRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    setState(() {
      showMenu = remoteConfig.getBool('show_menu');
      print(showMenu);
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
      print('Mensagem recebida: ${message.notification?.title}');
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

  Widget _buildCard(String image, VoidCallback onTap) {
    return _AnimatedCardButton(image: image, onTap: onTap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/messages'),
                        child: Image.asset(
                          'assets/notifications.png',
                          height: 28,
                        ),
                      ),
                      if (showMenu) // só exibe se vier true do Remote Config
                        PopupMenuButton<String>(
                          icon: Image.asset('assets/menu.png', height: 28),
                          onSelected: (value) {
                            switch (value) {
                              case 'agendar':
                                Navigator.pushNamed(context, '/schedule');
                                break;
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'agendar',
                              child: Text('Agendar reunião'),
                            ),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 0),

                  // Logo
                  Image.asset('assets/logo.png', height: 180),

                  const SizedBox(height: 0),

                  // 4 Botões principais com animação individual
                  _buildCard(
                    'assets/consultoria.png',
                    () => Navigator.pushNamed(context, '/consult'),
                  ),
                  _buildCard(
                    'assets/tecnologia.png',
                    () => Navigator.pushNamed(context, '/tecnologi'),
                  ),
                  _buildCard(
                    'assets/servicos.png',
                    () => Navigator.pushNamed(context, '/services'),
                  ),
                  _buildCard(
                    'assets/suporte.png',
                    () => Navigator.pushNamed(context, '/suport'),
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

// --- Componente do botão com animação individual ---
class _AnimatedCardButton extends StatefulWidget {
  final String image;
  final VoidCallback onTap;

  const _AnimatedCardButton({required this.image, required this.onTap});

  @override
  State<_AnimatedCardButton> createState() => _AnimatedCardButtonState();
}

class _AnimatedCardButtonState extends State<_AnimatedCardButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 100.ms,
      reverseDuration: 200.ms,
    );

    _scale = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 110,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),

            image: DecorationImage(
              image: AssetImage(widget.image),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
