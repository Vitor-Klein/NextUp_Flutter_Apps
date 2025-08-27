import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

late AudioHandler audioHandler;

class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  RadioAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

await _player.setAndroidAudioAttributes(
  const AndroidAudioAttributes(
    contentType: AndroidAudioContentType.music,
    usage: AndroidAudioUsage.media,
  ),
);


    session.becomingNoisyEventStream.listen((_) {
      if (_player.playing) pause();
    });

    session.interruptionEventStream.listen((event) async {
      if (event.begin) {
        if (event.type == AudioInterruptionType.pause ||
            event.type == AudioInterruptionType.duck) {
          if (_player.playing) await pause();
        }
      } else {}
    });

    _player.playbackEventStream.listen((event) {
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            _player.playing ? MediaControl.pause : MediaControl.play,
            MediaControl.stop,
          ],
          androidCompactActionIndices: const [0, 1],
          processingState: _mapProcessingState(_player.processingState),
          playing: _player.playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
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

  @override
  Future<void> playMediaItem(MediaItem item) async {
    final url = item.id.trim();
    if (url.isEmpty) return;

    mediaItem.add(item);

    await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
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
      await super.stop();
    }
  }

  @override
  Future<void> onTaskRemoved() async {
    if (_player.playing) {
      return;
    }
    await stop();
  }

  Future<void> setStreamUrl(String url) async {
    await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
  }
}

Future<AudioHandler> initAudioService() async {
  audioHandler = await AudioService.init(
    builder: () => RadioAudioHandler(),
    config: const AudioServiceConfig(
      androidResumeOnClick: true,
      androidNotificationChannelId: 'radio_player_channel',
      androidNotificationChannelName: 'Radio Playback',
      androidNotificationChannelDescription:
          'Canal de notificação para reprodução de rádio',
      androidShowNotificationBadge: false,
      androidStopForegroundOnPause: false,
      androidNotificationClickStartsActivity: true,
    ),
  );
  return audioHandler;
}
