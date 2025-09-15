import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

late AudioHandler audioHandler;

/// Player com suporte a Fila (Podcast)
class PodcastAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  StreamSubscription<PlaybackEvent>? _eventSub;

  PodcastAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    // Para podcasts, "speech" costuma dar prioridade melhor de ducking.
    await session.configure(const AudioSessionConfiguration.speech());

    // Atributos Android (boa prática)
    await _player.setAndroidAudioAttributes(
      const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        usage: AndroidAudioUsage.media,
      ),
    );

    // Lidar com fone removido/car mode
    session.becomingNoisyEventStream.listen((_) {
      if (_player.playing) pause();
    });

    // Interrupções (chamada, etc.)
    session.interruptionEventStream.listen((event) async {
      if (event.begin) {
        if (_player.playing) await pause();
      } else {
        // Se quiser retomar automaticamente quando encerra a interrupção, trate aqui.
      }
    });

    // Espelha estado do just_audio -> audio_service
    _eventSub = _player.playbackEventStream.listen(_broadcastState);

    // Atualiza MediaItem quando muda índice
    _player.currentIndexStream.listen((index) {
      if (index != null && index < queue.value.length) {
        mediaItem.add(queue.value[index]);
      }
    });

    // Fonte inicial (vazia)
    await _player.setAudioSource(_playlist);
  }

  /// Carrega/atualiza a fila de episódios a partir de MediaItems (id = URL do mp3/m4a)
  Future<void> loadQueueFromMediaItems(List<MediaItem> items) async {
    // Atualiza fila do audio_service (notificação/controles)
    queue.add(items);

    // Atualiza playlist do just_audio
    await _playlist.clear();
    await _playlist.addAll(
      items.map<AudioSource>((m) => AudioSource.uri(Uri.parse(m.id))).toList(),
    );
  }

  // —— Controles básicos ——
  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    try {
      await _player.stop();
    } finally {
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.idle,
          playing: false,
          controls: const [MediaControl.play],
        ),
      );
      await _eventSub?.cancel();
      await super.stop();
    }
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() =>
      _player.hasNext ? _player.seekToNext() : Future.value();

  @override
  Future<void> skipToPrevious() =>
      _player.hasPrevious ? _player.seekToPrevious() : Future.value();

  /// Permite tocar diretamente um episódio pelo mediaId (URL do áudio)
  @override
  Future<void> playFromMediaId(
    String mediaId, [
    Map<String, dynamic>? extras,
  ]) async {
    final index = queue.value.indexWhere((m) => m.id == mediaId);
    if (index != -1) {
      await _player.seek(Duration.zero, index: index);
      await _player.play();
    }
  }

  /// Compatibilidade com seu fluxo atual: tocar um único MediaItem diretamente
  @override
  Future<void> playMediaItem(MediaItem item) async {
    // Se já existir na fila, apenas pula para ele
    final idx = queue.value.indexWhere((m) => m.id == item.id);
    if (idx != -1) {
      await _player.seek(Duration.zero, index: idx);
      if (!_player.playing) await _player.play();
      return;
    }

    // Se não existir, adiciona ao fim e toca
    final newQueue = [...queue.value, item];
    await loadQueueFromMediaItems(newQueue);
    await _player.seek(Duration.zero, index: newQueue.length - 1);
    if (!_player.playing) await _player.play();
  }

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    final processingState = const {
      ProcessingState.idle: AudioProcessingState.idle,
      ProcessingState.loading: AudioProcessingState.loading,
      ProcessingState.buffering: AudioProcessingState.buffering,
      ProcessingState.ready: AudioProcessingState.ready,
      ProcessingState.completed: AudioProcessingState.completed,
    }[_player.processingState]!;

    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: processingState,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: _player.currentIndex,
      ),
    );
  }

  @override
  Future<void> onTaskRemoved() async {
    if (_player.playing) return;
    await stop();
  }
}

Future<PodcastAudioHandler> initAudioService() async {
  final handler = await AudioService.init(
    builder: () => PodcastAudioHandler(),
    config: const AudioServiceConfig(
      androidResumeOnClick: true,
      androidNotificationChannelId: 'podcast_player_channel',
      androidNotificationChannelName: 'Podcast Playback',
      androidNotificationChannelDescription:
          'Notificações de reprodução de podcast',
      androidShowNotificationBadge: true,
      androidStopForegroundOnPause: true,
      androidNotificationClickStartsActivity: true,
    ),
  );
  return handler as PodcastAudioHandler;
}
