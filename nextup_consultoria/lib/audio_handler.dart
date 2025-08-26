// audio_handler.dart
import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

// 🔹 Global acessível em toda a app
late AudioHandler audioHandler;

class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  RadioAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Não adiciona nada em queue nem mediaItem.
    // Estado do player atualizado sempre que algo mudar.
    _player.playbackEventStream.listen((event) {
      playbackState.add(
        PlaybackState(
          controls: [
            _player.playing ? MediaControl.pause : MediaControl.play,
            MediaControl.stop,
          ],
          androidCompactActionIndices: const [0, 1],
          processingState: _mapProcessingState(_player.processingState),
          playing: _player.playing,
          updatePosition: _player.position,
          speed: _player.speed,
          systemActions: const {
            MediaAction.play,
            MediaAction.pause,
            MediaAction.stop,
          },
        ),
      );
    });
  }

  AudioProcessingState _mapProcessingState(ProcessingState s) {
    switch (s) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  // ✅ Carrega e toca SEMPRE a URL do Remote Config (vem em item.id)
  @override
  Future<void> playMediaItem(MediaItem item) async {
    final url = item.id.trim();
    if (url.isEmpty) return;

    // Troca de fonte
    await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    // Atualiza metadados (title/artist/artUri/id) vindos do RC
    mediaItem.add(item);

    // Toca
    if (!_player.playing) {
      await _player.play();
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  // (Opcional) caso queira trocar só a URL manualmente em outro ponto
  Future<void> setStreamUrl(String url) async {
    await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    // Não seta metadados aqui — playMediaItem é a fonte da verdade.
  }
}

// Inicializa e preenche o global
Future<AudioHandler> initAudioService() async {
  audioHandler = await AudioService.init(
    builder: () => RadioAudioHandler(),
    config: const AudioServiceConfig(
      androidResumeOnClick: true,
      androidNotificationChannelId: 'radio_player_channel',
      androidNotificationChannelName: 'Radio Playback',
      androidNotificationOngoing: true,
    ),
  );
  return audioHandler;
}
