import 'package:bob_stoops/pages/webview_page.dart';
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

  bool showMenu = false;
  bool showStatus = false;
  String statusImageUrl = '';
  String statusLinkUrl = '';

  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions();
    _initializeFirebaseMessaging();
    _initializeLocalNotifications();
    _loadBannerConfig();
  }

  void _requestNotificationPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // ok
    }
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((_) {});
    _firebaseMessaging.getToken().then((token) => debugPrint('FCM: $token'));
  }

  void _initializeLocalNotifications() {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const init = InitializationSettings(android: android);
    _localNotifications.initialize(init);
  }

  void _showLocalNotification(RemoteMessage message) {
    const android = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'Descrição do canal',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: android);
    _localNotifications.show(
      0,
      message.notification?.title ?? 'Sem título',
      message.notification?.body ?? 'Sem conteúdo',
      details,
    );
  }

  Future<void> _compartilharApp() async {
    final rc = FirebaseRemoteConfig.instance;
    final link = Platform.isAndroid
        ? rc.getString('android_share_url')
        : rc.getString('ios_share_url');
    await SharePlus.instance.share(
      ShareParams(text: 'Check out this app:\n$link'),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _loadBannerConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    setState(() {
      showStatus = remoteConfig.getBool('show_status');
      statusImageUrl = remoteConfig.getString('status_image_url');
      statusLinkUrl = remoteConfig.getString('status_link_url');
    });
  }

  void _launchBanner() async {
    if (statusLinkUrl.isEmpty) return;
    final Uri uri = Uri.parse(statusLinkUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white, size: 30),
          onPressed: () => Navigator.pushNamed(context, '/messages'),
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 30),
              items: const [
                DropdownMenuItem(value: 'Twitter', child: Text('Twitter')),
                DropdownMenuItem(
                  value: 'LaunchWithCoach',
                  child: Text('Launch with Coach'),
                ),
              ],
              onChanged: (value) async {
                if (value == null) return;
                switch (value) {
                  case 'Twitter':
                    openWeb(
                      context,
                      'https://twitter.com/CoachBobStoops',
                      title: 'Twitter',
                    );
                    break;
                  case 'LaunchWithCoach':
                    final rc = FirebaseRemoteConfig.instance;
                    await rc.fetchAndActivate();
                    final launchUrl = rc
                        .getString('launch_with_coach_url')
                        .trim();
                    if (launchUrl.isEmpty) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Link de "Launch with Coach" não configurado no Remote Config.',
                            ),
                          ),
                        );
                      }
                      return;
                    }
                    openWeb(context, launchUrl, title: 'Launch with Coach');
                    break;
                }
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: Colors.black,

      // ✅ Fundo 100% tela + artboard por cima
      body: Stack(
        children: [
          // Fundo ocupando a tela inteira
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),

          // Seu layout proporcional por cima
          ResponsiveArtboard(
            designSize: const Size(1080, 1920),
            // opcional: se quiser evitar que o conteúdo passe sob a status bar
            safePadding: EdgeInsets.only(top: paddingTop),
            // sem background aqui ✅
            children: [
              PercentBox(
                left: 0.20,
                top: 0.12,
                width: 0.95,
                height: 0.45,
                child: Image.asset('assets/text.png', fit: BoxFit.contain),
              ),
              PercentBox(
                left: 0.15,
                top: 0.54,
                width: 0.95,
                height: 0.05,
                child: Row(
                  children: [
                    Expanded(
                      child: _ImageButton(
                        imageAsset: 'assets/button_about.png',
                        height: double.infinity,
                        fit: BoxFit.fill,
                        onTap: () => Navigator.pushNamed(context, '/about'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ImageButton(
                        imageAsset: 'assets/button_photos.png',
                        height: double.infinity,
                        fit: BoxFit.fill,
                        onTap: () => Navigator.pushNamed(context, '/pictures'),
                      ),
                    ),
                  ],
                ),
              ),
              PercentBox(
                left: 0.25,
                top: 0.64,
                width: 0.50,
                height: 0.050,
                child: Image.asset('assets/title.png', fit: BoxFit.contain),
              ),
              PercentBox(
                left: 0.07,
                top: 0.78,
                width: 0.86,
                height: 0.22,
                child: Row(
                  children: [
                    Expanded(
                      child: _ImageBottomButton(
                        imageAsset: 'assets/watch.png',
                        height: double.infinity,
                        fit: BoxFit.contain,
                        onTap: () => openWeb(
                          context,
                          'https://www.youtube.com/@coachbobstoops/videos',
                          title: 'Watch Now',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ImageBottomButton(
                        imageAsset: 'assets/share.png',
                        height: double.infinity,
                        fit: BoxFit.contain,
                        onTap: _compartilharApp,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ImageBottomButton(
                        imageAsset: 'assets/enter_win.png',
                        height: double.infinity,
                        fit: BoxFit.contain,
                        onTap: () => openWeb(
                          context,
                          'https://docs.google.com/forms/d/e/1FAIpQLSf_cEdpgnMlmd3iyD56BlnnFxEDePYLQzB-DwH_MD3Qrxt2Ug/viewform?usp=pp_url',
                          title: 'Enter to Win',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (showStatus && statusImageUrl.isNotEmpty)
                PercentBox(
                  // dica: mantenha width <= 1.0; aqui deixei 0.90 como exemplo
                  left: 0.05,
                  top: 1,
                  width: 1,
                  height: 0.10,
                  child: GestureDetector(
                    onTap: _launchBanner,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(statusImageUrl),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImageButton extends StatelessWidget {
  final String imageAsset;
  final double height;
  final VoidCallback onTap;
  final BoxFit fit;

  const _ImageButton({
    required this.imageAsset,
    required this.onTap,
    this.height = 38,
    this.fit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink.image(image: AssetImage(imageAsset), fit: fit),
        ),
      ),
    );
  }
}

class _ImageBottomButton extends StatelessWidget {
  final String imageAsset;
  final double height;
  final double borderRadius;
  final VoidCallback onTap;
  final BoxFit fit;

  const _ImageBottomButton({
    required this.imageAsset,
    required this.onTap,
    this.height = 0,
    this.borderRadius = 0,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink.image(image: AssetImage(imageAsset), fit: fit),
        ),
      ),
    );
  }
}

class ResponsiveArtboard extends StatelessWidget {
  final Size designSize; // ex.: Size(1080,1920)
  final Widget? background;
  final List<Widget> children;
  final EdgeInsets safePadding;

  const ResponsiveArtboard({
    super.key,
    required this.designSize,
    this.background,
    required this.children,
    this.safePadding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final aspect = designSize.width / designSize.height;

    return LayoutBuilder(
      builder: (context, c) {
        final maxW = c.maxWidth;
        final maxH = c.maxHeight;
        final byWidthHeight = maxW / aspect;
        final useW = byWidthHeight <= maxH;
        final artW = useW ? maxW : maxH * aspect;
        final artH = useW ? maxW / aspect : maxH;

        return Center(
          child: Padding(
            padding: safePadding,
            child: SizedBox(
              width: artW,
              height: artH,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (background != null) ClipRRect(child: background!),
                  ...children,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Posiciona um widget por frações do artboard (0..1)
class PercentBox extends StatelessWidget {
  final double left; // 0..1
  final double top; // 0..1
  final double width; // 0..1
  final double height; // 0..1
  final Widget child;

  const PercentBox({
    super.key,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cx = left + width / 2;
    final cy = top + height / 2;
    final ax = cx * 2 - 1;
    final ay = cy * 2 - 1;

    return Positioned.fill(
      child: Align(
        alignment: Alignment(ax, ay),
        child: FractionallySizedBox(
          widthFactor: width,
          heightFactor: height,
          child: child,
        ),
      ),
    );
  }
}
