import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'home_page.dart'; // ou o caminho correto para sua HomePage

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String routeName = 'SplashScreen';
  static String routePath = '/splashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, animation, __) => const HomePage(),
          transitionsBuilder: (_, animation, __, child) {
            // aqui o fade começa já visível em 40% e termina em 100%
            final fadeAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            );

            return FadeTransition(opacity: fadeAnimation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color.fromRGBO(247, 242, 222, 1),
      body: SizedBox.expand(
        child: Image.asset('assets/splash.png', fit: BoxFit.cover),
      ),
    );
  }
}
