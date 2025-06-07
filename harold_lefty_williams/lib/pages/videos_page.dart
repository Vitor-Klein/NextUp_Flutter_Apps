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
    {'id': 'NRgX_MvzyDQ', 'title': 'Vídeo 1'},
    {'id': 'pvL48a4-LAc', 'title': 'Vídeo 2'},
    {'id': 'w5rPxDx2X58', 'title': 'Vídeo 3'},
    {'id': 'icnxhUmHrcw', 'title': 'Vídeo 4'},
    {'id': 'LHbubxNXGGI', 'title': 'Vídeo 5'},
    {'id': '7GFNIoi59JA', 'title': 'Vídeo 6'},
    {'id': 'cHWLnVHnHwA', 'title': 'Vídeo 7'},
    {'id': '2uJRl8pWqFI', 'title': 'Vídeo 8'},
    {'id': 'VP4AzpmC00w', 'title': 'Vídeo 9'},
    {'id': 'dCAzSRO98Vw', 'title': 'Vídeo 10'},
    {'id': 'L1rkasz74KA', 'title': 'Vídeo 11'},
    {'id': 'rgIb-R-rTM0', 'title': 'Vídeo 12'},
    {'id': 'fRUvNwKQ5m4', 'title': 'Vídeo 13'},
    {'id': 'MMVLYaUH-b0', 'title': 'Vídeo 14'},
    {'id': '5YtcO1J446Q', 'title': 'Vídeo 15'},
    {'id': 'rAkyidU9WCk', 'title': 'Vídeo 16'},
    {'id': 'xduWtJYPJkQ', 'title': 'Vídeo 17'},
    {'id': '8uyxI3OUOks', 'title': 'Vídeo 18'},
    {'id': 'PR2hKQEGD54', 'title': 'Vídeo 19'},
    {'id': 'vYQYcEHKtZg', 'title': 'Vídeo 20'},
    {'id': 'EsTLfSK9g7M', 'title': 'Vídeo 21'},
    {'id': 'iJMWG8vLA44', 'title': 'Vídeo 22'},
    {'id': 'Ibikui3uUik', 'title': 'Vídeo 23'},
    {'id': '_lKQXmVGXBM', 'title': 'Vídeo 24'},
    {'id': '2XliIrPMjxs', 'title': 'Vídeo 25'},
    {'id': 'tqbfIS_xxMc', 'title': 'Vídeo 26'},
    {'id': 'TRKahWL-er4', 'title': 'Vídeo 27'},
    {'id': '4PSD6TuMQpk', 'title': 'Vídeo 28'},
    {'id': '2lKg8RqXaxo', 'title': 'Vídeo 29'},
    {'id': 'E2e9IG-ODj0', 'title': 'Vídeo 30'},
    {'id': 'kHqyDEryhLk', 'title': 'Vídeo 31'},
    {'id': 'y_8_8SNUYw0', 'title': 'Vídeo 32'},
    {'id': 'LSeQuLjP8uE', 'title': 'Vídeo 33'},
    {'id': 'IU79baB53rg', 'title': 'Vídeo 34'},
    {'id': 'lv8eWD8LP-8', 'title': 'Vídeo 35'},
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
          appBar: AppBar(title: const Text('Dare 2 Dream - Vídeos')),
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
