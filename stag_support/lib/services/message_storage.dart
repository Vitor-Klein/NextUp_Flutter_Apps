import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> saveMessageLocally(RemoteMessage message) async {
  final prefs = await SharedPreferences.getInstance();
  final existing = prefs.getStringList('push_messages') ?? [];

  final imageUrl =
      message.notification?.android?.imageUrl ??
      message.notification?.apple?.imageUrl;

  final newMessage = jsonEncode({
    'title': message.notification?.title ?? '',
    'body': message.notification?.body ?? '',
    'imageUrl': imageUrl ?? '',
    'timestamp': DateTime.now().toIso8601String(),
  });

  existing.add(newMessage);
  await prefs.setStringList('push_messages', existing);
}
