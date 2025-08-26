import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

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

  // Bottom bar: começa no centro (Home)
  int _selectedIndex = 2;

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
      // print(showMenu);
    });
  }

  void _requestNotificationPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
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
      // aqui você pode navegar conforme o payload
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
      channelDescription: 'Descrição do canal',
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

  // SHARE (igual seu exemplo)
  Future<void> _compartilharApp() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final String link = Platform.isAndroid
        ? remoteConfig.getString('android_share_url')
        : remoteConfig.getString('ios_share_url');

    final String mensagem = 'Check out this amazing app! Download now:\n$link';
    await SharePlus.instance.share(ShareParams(text: mensagem));
  }

  Future<void> _openMoreMenu() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Mais opções',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.radio, color: Color(0xFF2b4a83)),
                title: const Text('Rádio'),
                onTap: () => Navigator.pop(ctx, 'radio'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.schedule, color: Color(0xFF2b4a83)),
                title: const Text('Schedule'),
                onTap: () => Navigator.pop(ctx, 'schedule'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!mounted) return;

    switch (result) {
      case 'radio':
        Navigator.pushNamed(context, '/radio');
        break;
      case 'schedule': // certifique-se que sua rota é /schedule
        Navigator.pushNamed(context, '/schedule');
        break;
      default:
        // usuário fechou o sheet sem escolher nada
        break;
    }
  }

  // --- Helper para animar entrada lateral ---
  Widget _introSlide({
    required Widget child,
    required bool fromLeft,
    required int delayMs,
  }) {
    final w = MediaQuery.of(context).size.width;
    final begin = Offset(fromLeft ? -w : w, 0);
    return child
        .animate(delay: Duration(milliseconds: delayMs))
        .move(
          begin: begin,
          end: Offset.zero,
          duration: 450.ms,
          curve: Curves.easeOutCubic,
        )
        .fadeIn(duration: 300.ms, curve: Curves.easeOut);
  }

  Widget _buildCard({
    required String image,
    required VoidCallback onTap,
    double height = 160,
  }) {
    return _AnimatedCardButton(image: image, onTap: onTap, height: height);
  }

  Widget _homeBody() {
    final servicos = _introSlide(
      child: _buildCard(
        image: 'assets/servicos.png',
        onTap: () => Navigator.pushNamed(context, '/services'),
        height: 160,
      ),
      fromLeft: true,
      delayMs: 0,
    );

    final suporte = _introSlide(
      child: _buildCard(
        image: 'assets/oportunidades.png',
        onTap: () => Navigator.pushNamed(context, '/oportuniti'),
        height: 160,
      ),
      fromLeft: false,
      delayMs: 120,
    );

    final consultTecnologiRow = Row(
      children: [
        Expanded(
          child: _introSlide(
            child: _buildCard(
              image: 'assets/consultoria.png',
              onTap: () => Navigator.pushNamed(context, '/consult'),
              height: 140,
            ),
            fromLeft: true,
            delayMs: 240,
          ),
        ),
        const SizedBox(width: 50),
        Expanded(
          child: _introSlide(
            child: _buildCard(
              image: 'assets/suporte.png',
              onTap: () => Navigator.pushNamed(context, '/suport'),
              height: 140,
            ),
            fromLeft: false,
            delayMs: 300,
          ),
        ),
      ],
    );

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
        ),
        SafeArea(
          child: Padding(
            // 👇 padding inferior dinâmico para não ficar atrás da barra
            padding: EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 0),
            child: Column(
              children: [
                // Top bar
                const SizedBox(height: 155),

                servicos,
                const SizedBox(height: 0),

                suporte,
                const SizedBox(height: 10),

                consultTecnologiRow,
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = _selectedIndex == 2
        ? _homeBody()
        : const SizedBox.shrink();

    return Scaffold(
      extendBodyBehindAppBar: true, // 👈 faz o body ocupar atrás da AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // transparente
        elevation: 0, // sem sombra
        title: const Text(''), // sem título
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/messages');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          body,
          // Barra por cima
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0), // pode ajustar
              child: CurvedNavigationBar(
                index: _selectedIndex,
                height: 60,
                backgroundColor: Colors.transparent,
                color: const Color(0xFFffffff),
                animationDuration: const Duration(milliseconds: 300),
                iconPadding: 18,
                items: const [
                  CurvedNavigationBarItem(
                    child: Icon(Icons.group, color: Color(0xFF2b4a83)),
                    label: '',
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(Icons.share, color: Color(0xFF2b4a83)),
                    label: '',
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(Icons.home, color: Color(0xFF2b4a83)),
                    label: '',
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(Icons.place, color: Color(0xFF2b4a83)),
                    label: '',
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(Icons.more_horiz, color: Color(0xFF2b4a83)),
                    label: '',
                  ),
                ],
                onTap: (index) async {
                  switch (index) {
                    case 0:
                      Navigator.pushNamed(context, '/peoples');
                      break;
                    case 1:
                      await _compartilharApp();
                      break;
                    case 2:
                      setState(() => _selectedIndex = 2);
                      break;
                    case 3:
                      Navigator.pushNamed(context, '/contact');
                      break;
                    case 4:
                      await _openMoreMenu();
                      break;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Botão com animação de "press" ---
class _AnimatedCardButton extends StatefulWidget {
  final String image;
  final VoidCallback onTap;
  final double height;

  const _AnimatedCardButton({
    required this.image,
    required this.onTap,
    this.height = 150,
  });

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
      duration: 300.ms,
      reverseDuration: 200.ms,
    );

    _scale = Tween<double>(
      begin: 1,
      end: 1.1,
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
          margin: const EdgeInsets.only(bottom: 10),
          height: widget.height,
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
