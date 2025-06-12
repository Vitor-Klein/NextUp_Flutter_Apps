import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'services/message_storage.dart';

import 'pages/home_page.dart';
import 'pages/resources_page.dart';
import 'pages/splash_screen.dart';
import 'pages/messages_page.dart';

import 'pages/resources/about_page.dart';
import 'pages/resources/calling_988_lifeline_page.dart';
import 'pages/resources/lifeline_chat_page.dart';
import 'pages/resources/promoting_lifeline_page.dart';
import 'pages/resources/research_evaluation_page.dart';
import 'pages/resources/texting_988_lifeline_page.dart';

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
          backgroundColor: const Color(0xFFb4dcf2),
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
          case '/resources':
            builder = (_) => const ResourcesPage();
            break;
          case '/messages':
            builder = (_) => const MessagesPage();
            break;
          case '/calling_988_lifeline':
            builder = (_) => const Calling988LifelinePage();
            break;
          case '/texting_988_lifeline':
            builder = (_) => const Texting988LifelinePage();
            break;
          case '/lifeline_chat':
            builder = (_) => const LifelineChatPage();
            break;
          case '/research_evaluation':
            builder = (_) => const ResearchEvaluationPage();
            break;
          case '/promoting_lifeline':
            builder = (_) => const PromotingLifelinePage();
            break;
          case '/about':
            builder = (_) => const AboutPage();
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
