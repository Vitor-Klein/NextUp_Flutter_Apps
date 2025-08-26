// core/remote_radio_config.dart
import 'dart:convert';
import 'package:audio_service/audio_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RadioConfig {
  final String title;
  final String artist;
  final String streamUrl;
  final String artUri;

  RadioConfig({
    required this.title,
    required this.artist,
    required this.streamUrl,
    required this.artUri,
  });

  factory RadioConfig.fromJson(Map<String, dynamic> map) => RadioConfig(
    title: (map['title'] ?? '').toString(),
    artist: (map['artist'] ?? '').toString(),
    streamUrl: (map['streamUrl'] ?? '').toString(),
    artUri: (map['artUri'] ?? '').toString(),
  );

  MediaItem toMediaItem() {
    return MediaItem(
      id: streamUrl, // usado como source pelo player
      title: title.isEmpty ? ' ' : title, // evita null no Android notif
      artist: artist.isEmpty ? null : artist,
      artUri: artUri.isEmpty ? null : Uri.tryParse(artUri),
      extras: const {'source': 'remote_config'},
    );
  }
}

Future<RadioConfig> readRadioConfigFromRC({bool fetch = false}) async {
  final rc = FirebaseRemoteConfig.instance;

  if (fetch) {
    await rc.fetchAndActivate();
  }

  if (!rc.getAll().containsKey('radio_config')) {
    // Sem chave no RC -> retorna vazio (sem tocar nada)
    return RadioConfig(title: '', artist: '', streamUrl: '', artUri: '');
  }

  final raw = rc.getString('radio_config');
  if (raw.isEmpty) {
    return RadioConfig(title: '', artist: '', streamUrl: '', artUri: '');
  }

  try {
    final map = jsonDecode(raw);
    return RadioConfig.fromJson(Map<String, dynamic>.from(map));
  } catch (_) {
    return RadioConfig(title: '', artist: '', streamUrl: '', artUri: '');
  }
}
