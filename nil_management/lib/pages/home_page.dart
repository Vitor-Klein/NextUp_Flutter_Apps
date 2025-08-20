import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:nil_management/pages/webview_page.dart';

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
      showMenu = remoteConfig.getBool(
        'show_menu',
      ); // ainda disponível se quiser usar
    });
  }

  void _requestNotificationPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (!mounted) return;
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Permissões de notificação concedidas');
    } else {
      debugPrint('Permissões de notificação negadas');
    }
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Usuário abriu a notificação');
      // TODO: navegar para alguma tela específica se quiser
    });

    _firebaseMessaging.getToken().then((token) {
      debugPrint('Token FCM: $token');
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

  Future<void> _compartilharApp() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final String link = Platform.isAndroid
        ? remoteConfig.getString('android_share_url')
        : remoteConfig.getString('ios_share_url');

    final String msg = 'Check out this amazing app! Download now:\n$link';
    await SharePlus.instance.share(ShareParams(text: msg));
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Falha ao abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.04;

    return Scaffold(
      backgroundColor: const Color(0xFF191919),

      body: Stack(
        children: [
          // BG
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg', // TODO: sua imagem de fundo
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // Leve overlay para legibilidade
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Linha superior: ícone de notificação no canto ESQUERDO
                  Row(
                    children: [
                      _IconCircle(
                        asset:
                            'assets/notification_bell.png', // TODO: ícone de notificação
                        tooltip: 'Notificações',
                        onTap: () {
                          // Pode abrir uma tela de notificações, permissões, etc.
                          _requestNotificationPermissions();
                        },
                      ),
                      const Spacer(),

                      // (Opcional) botão de share no canto direito
                    ],
                  ),
                  const SizedBox(height: 110),

                  // 2 retangulares no topo (lado a lado)
                  Row(
                    children: [
                      _ImageButtonTop(
                        asset: 'assets/social.png', // TODO
                        onTap: () => _openUrl('https://exemplo.com/top-left'),
                      ),
                      const SizedBox(width: 6),
                      _ImageButtonTop(
                        asset: 'assets/share.png', // TODO
                        onTap: () => _openUrl('https://exemplo.com/top-right'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // 3 em linha
                  Row(
                    children: [
                      Expanded(
                        child: _ImageButtonAthletes(
                          asset: 'assets/jyaire_brown.png', // TODO
                          onTap: () => _openUrl('https://exemplo.com/grid1'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ImageButtonAthletes(
                          asset: 'assets/cade_stover.png', // TODO
                          onTap: () => _openUrl('https://exemplo.com/grid2'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ImageButtonAthletes(
                          asset: 'assets/lathan_ranson.png', // TODO
                          onTap: () => _openUrl('https://exemplo.com/grid3'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ImageButtonAthletes(
                          asset: 'assets/athletes_talent.png', // TODO
                          onTap: () => openWeb(
                            context,
                            'https://nilmanagement.com/athletes/talent',
                            title: 'Athletes Talent',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 2 em linha
                  Row(
                    children: [
                      Expanded(
                        child: _ImageButton(
                          asset: 'assets/about.png', // TODO
                          aspectRatio: 16 / 9,
                          onTap: () => openWeb(
                            context,
                            'https://nilmanagement.com/en-us/about-us',
                            title: 'About Us',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ImageButton(
                          asset: 'assets/reach_out.png', // TODO
                          aspectRatio: 16 / 9,
                          onTap: () => openWeb(
                            context,
                            'https://nilmanagement.com/contact-us',
                            title: 'Contact Us',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Footer com botão Careers por cima
                  // Coloque isto onde você quer o footer dentro do Column
                  FooterWithCareers(
                    height: 160, // defina a altura fixa do footer
                    footerAsset: 'assets/footer.png',
                    careersAsset: 'assets/careers_button_footer.png',
                    careersWidth: 150,
                    careersHeight: 35,
                    onCareersTap: () => openWeb(
                      context,
                      'https://nilmanagement.com/careers',
                      title: 'Careers',
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bolinha com ícone (imagem) – para notificação/share
class _IconCircle extends StatelessWidget {
  final String asset;
  final String? tooltip;
  final VoidCallback? onTap;

  const _IconCircle({required this.asset, this.tooltip, this.onTap});

  @override
  Widget build(BuildContext context) {
    final btn = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(shape: BoxShape.circle),
        margin: EdgeInsets.symmetric(horizontal: 90, vertical: 30),
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip!, child: btn) : btn;
  }
}

/// Card de imagem clicável com raio e sombra.
/// Usa AspectRatio para manter proporção visual estável.
class _ImageButton extends StatelessWidget {
  final String asset;
  final double aspectRatio;
  final VoidCallback? onTap;

  const _ImageButton({
    required this.asset,
    required this.aspectRatio,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: AssetImage(asset),
            fit: BoxFit.cover,
            child: InkWell(onTap: onTap),
          ),
        ),
      ),
    );
  }
}

class _ImageButtonTop extends StatelessWidget {
  final String asset;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const _ImageButtonTop({
    required this.asset,
    this.width = 80, // largura padrão
    this.height = 30, // altura padrão
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: AssetImage(asset),
            fit: BoxFit.cover,
            child: InkWell(onTap: onTap),
          ),
        ),
      ),
    );
  }
}

class _ImageButtonAthletes extends StatelessWidget {
  final String asset;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const _ImageButtonAthletes({
    required this.asset,
    this.width = 50, // largura padrão
    this.height = 150, // altura padrão
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: AssetImage(asset),
            fit: BoxFit.cover,
            child: InkWell(onTap: onTap),
          ),
        ),
      ),
    );
  }
}

class FooterWithCareers extends StatelessWidget {
  final double height;
  final String footerAsset;
  final String careersAsset;
  final double careersWidth;
  final double careersHeight;
  final VoidCallback? onCareersTap;

  const FooterWithCareers({
    super.key,
    required this.height,
    required this.footerAsset,
    required this.careersAsset,
    required this.careersWidth,
    required this.careersHeight,
    this.onCareersTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // full width
      height: height, // altura fixa do footer
      child: Stack(
        children: [
          // imagem de fundo do footer (não clicável)
          Positioned.fill(
            child: Image.asset(
              footerAsset,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          // botão Careers por cima
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: Offset(0, 20), // ↓ quanto maior o valor, mais para baixo
              child: SizedBox(
                width: careersWidth,
                height: careersHeight,
                child: _ImageButtonFooter(
                  asset: careersAsset,
                  onTap: onCareersTap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageButtonFooter extends StatelessWidget {
  final String asset;
  final VoidCallback? onTap;
  const _ImageButtonFooter({required this.asset, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: AssetImage(asset),
          fit: BoxFit.cover,
          child: InkWell(onTap: onTap),
        ),
      ),
    );
  }
}
