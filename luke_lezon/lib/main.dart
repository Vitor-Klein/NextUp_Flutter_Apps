import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'services/message_storage.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/books_page.dart';
import 'pages/messages_page.dart';
import 'pages/podcast_page.dart';
import 'pages/splash_screen.dart';
import 'pages/Meet_And_Greet/meet_greet_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
  print('Message data: ${message.data}');
  await saveMessageLocally(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Configura o Remote Config com segurança
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration(milliseconds: 10),
      ),
    );

    await remoteConfig.setDefaults({
      'meet_greet_visible': false,
      'android_share_url':
          'https://play.google.com/store/apps/details?id=com.seuapp.android',
      'ios_share_url': 'https://apps.apple.com/app/id0000000000',
    });

    final updated = await remoteConfig.fetchAndActivate();
    print('✅ Remote Config atualizado? $updated');
  } catch (e) {
    print('❌ Erro ao inicializar Remote Config: $e');
  }

  // ✅ Inicializa Firebase Messaging
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
          backgroundColor: Color(0xFFF5F5F5),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case '/home':
            builder = (_) => const HomePage();
            break;
          case '/about':
            builder = (_) => const AboutPage();
            break;
          case '/books':
            builder = (_) => const BooksPage();
            break;
          case '/messages':
            builder = (_) => const MessagesPage();
            break;
          case '/podcast':
            builder = (_) => const PodcastPage();
            break;
          case '/meet_greet':
            builder = (_) => const MeetGreetPage();
            break;
          default:
            builder = (_) => const HomePage();
        }

        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
          settings: settings,
        );
      },
    );
  }
}
