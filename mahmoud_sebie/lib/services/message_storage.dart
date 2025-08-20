import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> saveMessageLocally(RemoteMessage message) async {
  final prefs = await SharedPreferences.getInstance();
  final existing = prefs.getStringList('push_messages') ?? [];

  final notification = message.notification;
  final data = message.data;

  final title = notification?.title ?? data['title'] ?? '';
  final body = notification?.body ?? data['body'] ?? '';
  final imageUrl =
      notification?.android?.imageUrl ??
      notification?.apple?.imageUrl ??
      data['image'] ?? '';

  final item = jsonEncode({
    'id': message.messageId,
    'sentTime': message.sentTime?.toIso8601String(),
    'title': title,
    'body': body,
    'imageUrl': imageUrl,
    'data': data,
  });

  existing.insert(0, item);
  await prefs.setStringList('push_messages', existing.take(50).toList());
}
