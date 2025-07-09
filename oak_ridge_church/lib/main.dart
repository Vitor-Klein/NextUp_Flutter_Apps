import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:oak_ridge_church/pages/social_page.dart';
import 'firebase_options.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'services/message_storage.dart';

import 'pages/home_page.dart';
import 'pages/calendar_page.dart';
import 'pages/splash_screen.dart';
import 'pages/visit_page.dart';
import 'pages/about_page.dart';
import 'pages/watch_online_page.dart';
import 'pages/worship_page.dart';
import 'pages/more_page.dart';
import 'pages/messages_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Handling a background message: ${message.messageId}");
  print('Message data: ${message.data}');

  await saveMessageLocally(message); // 💾 Salvar mesmo com app fechado
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(milliseconds: 10),
    ),
  );
  await remoteConfig.fetchAndActivate();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.subscribeToTopic('all');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Received in foreground: ${message.notification?.title}');
    await saveMessageLocally(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print('Opened app from notification: ${message.notification?.title}');
    await saveMessageLocally(message);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5b97cc),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
      // home: const HomePage(),
      onGenerateRoute: (settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case '/home':
            builder = (_) => const HomePage();
            break;
          case '/calendar':
            builder = (_) => const CalendarPage();
            break;
          case '/visit':
            builder = (_) => const VisitPage();
            break;
          case '/watch-online':
            builder = (_) => const WatchOnlinePage();
            break;
          case '/worship':
            builder = (_) => const WorshipPage();
            break;
          case '/about':
            builder = (_) => const AboutPage();
            break;
          case '/more':
            builder = (_) => const MorePage();
            break;
          case '/social':
            builder = (_) => const SocialPage();
            break;
          case '/messages':
            builder = (_) => const MessagesPage();
            break;

          default:
            builder = (_) => const HomePage();
        }

        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
          settings: settings,
        );
      },
    );
  }
}
