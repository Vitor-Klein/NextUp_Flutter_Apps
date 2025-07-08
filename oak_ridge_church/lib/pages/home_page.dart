import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oak_ridge_church/pages/more_page.dart';
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

  int _selectedIndex = 2;

  final List<Widget> _pages = const [
    CalendarPage(),
    WatchOnlinePage(),
    HomeBody(),
    VisitPage(),
    MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(height: 45, color: const Color(0xFFe5e5e5)),
          Padding(
            padding: const EdgeInsets.only(bottom: 42),
            child: CurvedNavigationBar(
              index: _selectedIndex,
              height: 80,
              backgroundColor: Colors.transparent,
              color: const Color(0xFFe5e5e5),
              animationDuration: const Duration(milliseconds: 300),
              iconPadding: 18,
              items: const [
                CurvedNavigationBarItem(
                  child: Icon(Icons.calendar_month, color: Color(0xFF2b4a83)),
                  label: 'Calendar',
                ),
                CurvedNavigationBarItem(
                  child: Icon(Icons.share, color: Color(0xFF2b4a83)),
                  label: 'Share',
                ),
                CurvedNavigationBarItem(
                  child: Icon(Icons.home, color: Color(0xFF2b4a83)),
                  label: 'Home',
                ),
                CurvedNavigationBarItem(
                  child: Icon(Icons.place, color: Color(0xFF2b4a83)),
                  label: 'Visit Us',
                ),
                CurvedNavigationBarItem(
                  child: Icon(Icons.more_horiz, color: Color(0xFF2b4a83)),
                  label: 'More',
                ),
              ],
              onTap: (index) {
                if (index == 1) {
                  _compartilharApp();
                } else {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  int _currentIndex = 0;

  final List<String> _carouselImages = [
    'assets/header.png',
    'assets/header2.jpg',
    'assets/header3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 320,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    height: 320,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: _carouselImages.map((img) {
                    return Image.asset(
                      img,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }).toList(),
                ),
                Positioned(
                  bottom: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _carouselImages.asMap().entries.map((entry) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentIndex == entry.key ? 12.0 : 8.0,
                        height: 10.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Image.asset('assets/Text.png', height: 80),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _imageButton('assets/Watch_Online.png', () {
                  Navigator.pushNamed(context, '/watch-online');
                }),
                _imageButton('assets/Worship.png', () {
                  Navigator.pushNamed(context, '/worship');
                }),
                _imageButton('assets/About_Us.png', () {
                  Navigator.pushNamed(context, '/about');
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageButton(String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 240,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(asset), fit: BoxFit.contain),
        ),
      ),
    );
  }
}
