import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../podcast/podcast_repository.dart';
import '../audio_handler.dart' show PodcastAudioHandler;

class PodcastPage extends StatefulWidget {
  final String rssUrl; // Pode vir do Remote Config
  final PodcastAudioHandler audioHandler;

  const PodcastPage({
    super.key,
    required this.rssUrl,
    required this.audioHandler,
  });

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  late final PodcastRepository _repo;
  late Future<List<Episode>> _future;

  @override
  void initState() {
    super.initState();
    _repo = PodcastRepository(widget.rssUrl);
    _future = _bootstrap();
  }

  Future<List<Episode>> _bootstrap() async {
    final eps = await _repo.fetchEpisodes();
    // Converte episódios do RSS em MediaItems do audio_service
    final items = eps
        .map(
          (e) => MediaItem(
            id: e.audioUrl, // URL do .mp3 / .m4a
            title: e.title,
            artUri: e.imageUrl != null ? Uri.parse(e.imageUrl!) : null,
            duration: e.duration,
            extras: {
              'episodeId': e.id,
              'pubDate': e.pubDate?.toIso8601String(),
              'description': e.description,
            },
          ),
        )
        .toList();

    // Carrega a fila no handler unificado (PodcastAudioHandler)
    await widget.audioHandler.loadQueueFromMediaItems(items);
    return eps;
  }

  Future<void> _refresh() async {
    final eps = await _repo.fetchEpisodes();
    final items = eps
        .map(
          (e) => MediaItem(
            id: e.audioUrl,
            title: e.title,
            artUri: e.imageUrl != null ? Uri.parse(e.imageUrl!) : null,
            duration: e.duration,
            extras: {
              'episodeId': e.id,
              'pubDate': e.pubDate?.toIso8601String(),
              'description': e.description,
            },
          ),
        )
        .toList();
    await widget.audioHandler.loadQueueFromMediaItems(items);
    setState(() {}); // Rebuild da lista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Podcast')),
      body: FutureBuilder<List<Episode>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Erro: ${snap.error}'));
          }

          final episodes = snap.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: episodes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final e = episodes[i];
                return ListTile(
                  leading: e.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            e.imageUrl!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.podcasts),
                          ),
                        )
                      : const Icon(Icons.podcasts),
                  title: Text(
                    e.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    e.pubDate?.toLocal().toString().split('.').first ?? '',
                  ),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () => widget.audioHandler.playFromMediaId(e.audioUrl),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: StreamBuilder<MediaItem?>(
        stream: widget.audioHandler.mediaItem,
        builder: (context, snap) {
          final item = snap.data;
          if (item == null) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (item.artUri != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.artUri.toString(),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.podcasts, size: 48),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StreamBuilder<PlaybackState>(
                  stream: widget.audioHandler.playbackState,
                  builder: (context, s) {
                    final playing = s.data?.playing ?? false;
                    return Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: widget.audioHandler.skipToPrevious,
                        ),
                        IconButton(
                          icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                          onPressed: playing
                              ? widget.audioHandler.pause
                              : widget.audioHandler.play,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed: widget.audioHandler.skipToNext,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
