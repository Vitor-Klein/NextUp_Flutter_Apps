import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class Episode {
  final String id;
  final String title;
  final String audioUrl;
  final DateTime? pubDate;
  final String? imageUrl;
  final String? description;
  final Duration? duration;

  Episode({
    required this.id,
    required this.title,
    required this.audioUrl,
    this.pubDate,
    this.imageUrl,
    this.description,
    this.duration,
  });
}

class PodcastRepository {
  final String rssUrl;
  PodcastRepository(this.rssUrl);

  Future<List<Episode>> fetchEpisodes() async {
    final res = await http.get(Uri.parse(rssUrl));
    if (res.statusCode != 200) throw Exception('Falha ao baixar RSS');
    final doc = XmlDocument.parse(res.body);

    // iTunes image do canal (fallback)
    final channelImage = doc
        .findAllElements('image')
        .map((e) {
          final url = e.getElement('url')?.innerText.trim();
          return url;
        })
        .whereType<String>()
        .cast<String?>()
        .firstOrNull;

    final items = doc.findAllElements('item');
    final episodes = <Episode>[];

    for (final item in items) {
      final title = item.getElement('title')?.innerText.trim() ?? 'Untitled';
      final guid = item.getElement('guid')?.innerText.trim() ?? title;
      final pubDateStr = item.getElement('pubDate')?.innerText.trim();
      final enclosure = item.getElement('enclosure');
      final audioUrl = enclosure?.getAttribute('url') ?? '';

      if (audioUrl.isEmpty) continue; // precisa do mp3/m4a

      // iTunes tags
      final itunesNS = 'http://www.itunes.com/dtds/podcast-1.0.dtd';
      final imageTag =
          item.findElements('image').firstOrNull ??
          item.findElements('itunes:image', namespace: itunesNS).firstOrNull;
      final imgAttr =
          imageTag?.getAttribute('href') ??
          imageTag?.getElement('url')?.innerText;

      // duration (HH:MM:SS ou MM:SS)
      final durationStr = item
          .findElements('itunes:duration', namespace: itunesNS)
          .map((e) => e.innerText.trim())
          .firstOrNull;
      Duration? parsedDuration;
      if (durationStr != null) {
        final parts = durationStr
            .split(':')
            .map((p) => int.tryParse(p) ?? 0)
            .toList();
        if (parts.length == 3) {
          parsedDuration = Duration(
            hours: parts[0],
            minutes: parts[1],
            seconds: parts[2],
          );
        } else if (parts.length == 2) {
          parsedDuration = Duration(minutes: parts[0], seconds: parts[1]);
        }
      }

      episodes.add(
        Episode(
          id: guid,
          title: title,
          audioUrl: audioUrl,
          pubDate: pubDateStr != null ? DateTime.tryParse(pubDateStr) : null,
          imageUrl: imgAttr ?? channelImage,
          description: item.getElement('description')?.innerText,
          duration: parsedDuration,
        ),
      );
    }
    return episodes;
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
