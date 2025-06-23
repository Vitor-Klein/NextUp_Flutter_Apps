import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'calendar_page.dart';
import 'visit_page.dart';
import 'about_page.dart';
import 'watch_online_page.dart';
import 'worship_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // bool showBanner = false;
  // String bannerImageUrl = '';
  // String bannerLinkUrl = '';

  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions();
    _initializeFirebaseMessaging();
    _initializeLocalNotifications();
    // _loadBannerConfig();
  }

  // Future<void> _loadBannerConfig() async {
  //   final remoteConfig = FirebaseRemoteConfig.instance;
  //   await remoteConfig.fetchAndActivate();

  //   setState(() {
  //     showBanner = remoteConfig.getBool('show_banner');
  //     bannerImageUrl = remoteConfig.getString('banner_image_url');
  //     bannerLinkUrl = remoteConfig.getString('banner_link_url');
  //   });
  // }

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

  // void _launchBanner() async {
  //   final Uri uri = Uri.parse(bannerLinkUrl);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.platformDefault);
  //   }
  // }
  int _selectedIndex = 2;

  final List<Widget> _pages = const [
    CalendarPage(),
    WatchOnlinePage(),
    HomeBody(),
    VisitPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 65,
        backgroundColor: Colors.transparent,
        color: Colors.brown.shade700,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.calendar_month, color: Colors.white),
            label: 'Calendar',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.tv, color: Colors.white),
            label: 'Watch',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.place, color: Colors.white),
            label: 'Visit',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.info_outline, color: Colors.white),
            label: 'About',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: height * 0.33,
            child: CarouselSlider(
              options: CarouselOptions(autoPlay: true, viewportFraction: 1.0),
              items:
                  [
                    'assets/header.png',
                    'assets/header.png',
                    'assets/header.png',
                  ].map((img) {
                    return Image.asset(
                      img,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Image.asset('assets/Text.png', height: 60),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _circleButton('assets/Watch_Online.png', 'Watch Online', () {
                  Navigator.pushNamed(context, '/watch-online');
                }),
                _circleButton('assets/Worship.png', 'Worship', () {
                  Navigator.pushNamed(context, '/worship');
                }),
                _circleButton('assets/About_Us.png', 'About Us', () {
                  Navigator.pushNamed(context, '/about');
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(String asset, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage(asset)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
