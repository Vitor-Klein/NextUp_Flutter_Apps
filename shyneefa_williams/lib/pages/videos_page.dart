import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  late YoutubePlayerController _controller;

  final List<Map<String, String>> videos = [
    {'id': 'HDPq4gbVVvA', 'title': 'Vídeo 1'},
    {'id': '_lKQXmVGXBM', 'title': 'Vídeo 2'},
    {'id': 'MMVLYaUH-b0', 'title': 'Vídeo 3'},
    {'id': 'xduWtJYPJkQ', 'title': 'Vídeo 4'},
  ];

  String currentVideoId = '85yBqGwOV2k';

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    // Carrega o primeiro vídeo após um pequeno atraso
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadVideoById(videoId: currentVideoId);
    });
  }

  void _loadVideo(String videoId) {
    setState(() {
      currentVideoId = videoId;
      _controller.loadVideoById(videoId: videoId);
    });
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
          appBar: AppBar(title: const Text('Videos')),
          body: Column(
            children: [
              AspectRatio(aspectRatio: 16 / 9, child: player),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: videos.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return ListTile(
                      leading: Image.network(
                        'https://img.youtube.com/vi/${video['id']}/0.jpg',
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      title: Text(video['title']!),
                      selected: video['id'] == currentVideoId,
                      onTap: () => _loadVideo(video['id']!),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
