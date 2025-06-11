import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'services/message_storage.dart';

import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/videos_page.dart';
import 'pages/messages_page.dart';
import 'pages/social_page.dart';
import 'pages/more_page.dart';
import 'pages/Meet_And_Greet/meet_greet_page.dart';
import 'pages/splash_screen.dart'; // ⬅️ Certifique-se de importar isso

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Handling a background message: ${message.messageId}");
  print('Message data: ${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
    await saveMessageLocally(message); // 💾 salvando localmente
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print('Opened app from notification: ${message.notification?.title}');
    await saveMessageLocally(message); // 💾 salvando localmente
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
          backgroundColor: const Color(0xFF5280d5),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Ícones da AppBar
          ),
          elevation: 0,
        ),
      ),
      home: const SplashScreen(), // 👈 Define a SplashScreen como tela inicial
      onGenerateRoute: (settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case '/home':
            builder = (_) => const HomePage();
            break;
          case '/about':
            builder = (_) => const AboutPage();
            break;
          case '/videos':
            builder = (_) => const VideosPage();
            break;
          case '/messages':
            builder = (_) => const MessagesPage();
            break;
          case '/social':
            builder = (_) => const SocialPage();
            break;
          case '/more':
            builder = (_) => const MorePage();
            break;
          case '/meet_greet':
            builder = (_) => const MeetGreetPage();
            break;
          default:
            builder = (_) => const HomePage(); // fallback
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
