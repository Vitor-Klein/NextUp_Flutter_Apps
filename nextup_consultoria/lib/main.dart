import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nextup_consultoria/pages/consult_page.dart';
import 'package:nextup_consultoria/pages/home_page.dart';
import 'package:nextup_consultoria/pages/messages_page.dart';
import 'package:nextup_consultoria/pages/services_page.dart';
import 'package:nextup_consultoria/pages/splash_screen.dart';
import 'package:nextup_consultoria/pages/suport_page.dart';
import 'package:nextup_consultoria/pages/oportuniti_page.dart';
import 'package:nextup_consultoria/pages/schedule_page.dart';
import 'package:nextup_consultoria/pages/peoples_page.dart';
import 'package:nextup_consultoria/pages/contact_page.dart';
import 'firebase_options.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'services/message_storage.dart';

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
          backgroundColor: Colors.black87,
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
      onGenerateRoute: (settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case '/home':
            builder = (_) => const HomePage();
            break;
          case '/consult':
            builder = (_) => const ConsultPage();
            break;
          case '/oportuniti':
            builder = (_) => const OportunitiPage();
            break;
          case '/services':
            builder = (_) => const ServicesPage();
            break;
          case '/suport':
            builder = (_) => const SuportPage();
            break;
          case '/messages':
            builder = (_) => const MessagesPage();
            break;
          case '/peoples':
            builder = (_) => const PeoplesPage();
            break;
          case '/contact':
            builder = (_) => const ContactPage();
            break;
          case '/schedule':
            builder = (_) => const SchedulePage();
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
          transitionDuration: const Duration(milliseconds: 800),
          settings: settings,
        );
      },
    );
  }
}
