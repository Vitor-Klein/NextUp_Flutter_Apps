import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  late YoutubePlayerController _controller;

  final List<String> videoIds = ['85yBqGwOV2k', 'I8vRFb-ZP8k', 'Fb9-x9BCBS0'];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    // Carrega o primeiro vídeo
    _loadCurrentVideo();
  }

  void _loadCurrentVideo() {
    _controller.loadVideoById(videoId: videoIds[currentIndex]);
  }

  void _playNext() {
    if (currentIndex < videoIds.length - 1) {
      setState(() {
        currentIndex++;
        _loadCurrentVideo();
      });
    }
  }

  void _playPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _loadCurrentVideo();
      });
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(title: const Text('Dare 2 Dream - Vídeos')),
          body: Column(
            children: [
              Expanded(child: player),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: currentIndex > 0 ? _playPrevious : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Anterior'),
                  ),
                  Text('${currentIndex + 1} / ${videoIds.length}'),
                  ElevatedButton.icon(
                    onPressed: currentIndex < videoIds.length - 1
                        ? _playNext
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Próximo'),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }
}
