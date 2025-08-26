import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:nextup_consultoria/main.dart';
import 'package:rxdart/rxdart.dart';
import '../audio_handler.dart' hide audioHandler;
import 'package:nextup_consultoria/core/remote_radio_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RadioPlayerPage extends StatefulWidget {
  const RadioPlayerPage({super.key});

  @override
  State<RadioPlayerPage> createState() => _RadioPlayerPageState();
}

class _RadioPlayerPageState extends State<RadioPlayerPage> {
  // ---- ESTADO LOCAL vindo do Remote Config (prioridade na UI) ----
  String? _rcTitle;
  String? _rcArtist;
  String? _rcArtUri;

  @override
  void initState() {
    super.initState();
    _applyRemoteConfig();
  }

  // dentro de _applyRemoteConfig
  Future<void> _applyRemoteConfig({bool fetch = true}) async {
    final cfg = await readRadioConfigFromRC(fetch: fetch);

    setState(() {
      _rcTitle = cfg.title;
      _rcArtist = cfg.artist;
      _rcArtUri = cfg.artUri;
    });

    // Só toca se houver streamUrl no RC
    if (cfg.streamUrl.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Remote Config sem streamUrl.')),
        );
      }
      return;
    }

    final item = cfg.toMediaItem();
    await audioHandler.playMediaItem(item);
  }

  // Streams originais (sem mudança na lógica)
  Stream<_ScreenState> get _screenStateStream =>
      Rx.combineLatest2<MediaItem?, PlaybackState, _ScreenState>(
        audioHandler.mediaItem,
        audioHandler.playbackState,
        (m, s) => _ScreenState(mediaItem: m, playbackState: s),
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        title: const Text(
          'Rádio ao vivo',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Atualizar dados da rádio',
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: () => _applyRemoteConfig(fetch: true),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cs.primaryContainer.withOpacity(0.35),
              cs.secondaryContainer.withOpacity(0.25),
              cs.surface.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: StreamBuilder<_ScreenState>(
              stream: _screenStateStream,
              builder: (context, snap) {
                final media = snap.data?.mediaItem;
                final state = snap.data?.playbackState;

                final isPlaying = state?.playing ?? false;
                final isBuffering =
                    state == null ||
                    state.processingState == AudioProcessingState.loading ||
                    state.processingState == AudioProcessingState.buffering;

                // >>> PRIORIDADE NA EXIBIÇÃO: RC -> mediaItem -> fallback
                final title = (_rcTitle?.isNotEmpty == true)
                    ? _rcTitle!
                    : (media?.title ?? 'Carregando...');
                final artist = (_rcArtist?.isNotEmpty == true)
                    ? _rcArtist!
                    : (media?.artist ?? 'Ao vivo');
                final artUrl = (_rcArtUri?.isNotEmpty == true)
                    ? _rcArtUri
                    : media?.artUri?.toString();

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                        decoration: BoxDecoration(
                          color: cs.surface.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: cs.outlineVariant.withOpacity(0.25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            _Artwork(url: artUrl),
                            const SizedBox(height: 24),

                            // Título e artista (com RC em prioridade)
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              artist,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: cs.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),

                            const SizedBox(height: 16),

                            // Status pill
                            _StatusPill(
                              text: _statusText(state),
                              color: isPlaying
                                  ? cs.primary
                                  : cs.onSurfaceVariant.withOpacity(0.35),
                              textColor: isPlaying
                                  ? cs.onPrimary
                                  : cs.onSurface.withOpacity(0.85),
                            ),

                            const Spacer(),

                            // Botão play/pause (lógica intacta)
                            SizedBox(
                              width: 96,
                              height: 96,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      cs.primary.withOpacity(0.95),
                                      cs.secondary.withOpacity(0.95),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (isPlaying
                                                  ? cs.primary
                                                  : cs.secondary)
                                              .withOpacity(0.35),
                                      blurRadius: 28,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: FloatingActionButton(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: cs.onPrimary,
                                  onPressed: isBuffering
                                      ? null
                                      : () => isPlaying
                                            ? audioHandler.pause()
                                            : audioHandler.play(),
                                  child: isBuffering
                                      ? const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : Icon(
                                          isPlaying
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded,
                                          size: 42,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Legenda
                            Text(
                              'Toque para ${isPlaying ? 'pausar' : 'reproduzir'}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: cs.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _statusText(PlaybackState? s) {
    if (s == null) return 'Conectando...';
    switch (s.processingState) {
      case AudioProcessingState.loading:
      case AudioProcessingState.buffering:
        return 'Conectando...';
      case AudioProcessingState.ready:
        return s.playing ? 'Tocando' : 'Pausado';
      case AudioProcessingState.idle:
        return 'Parado';
      case AudioProcessingState.completed:
        return 'Encerrado';
      case AudioProcessingState.error:
        throw UnimplementedError();
    }
  }
}

class _Artwork extends StatelessWidget {
  final String? url;
  const _Artwork({this.url});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [cs.primaryContainer, cs.secondaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Halo
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [cs.primary.withOpacity(0.18), Colors.transparent],
              ),
            ),
          ),
          // Borda com traço
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: cs.outlineVariant.withOpacity(0.4),
                width: 1.2,
              ),
            ),
          ),
          // Capa
          Padding(
            padding: const EdgeInsets.all(8),
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withOpacity(0.6),
                ),
                child: (url == null || url!.isEmpty)
                    ? Icon(
                        Icons.radio_rounded,
                        size: 96,
                        color: cs.onPrimaryContainer.withOpacity(0.6),
                      )
                    : Image.network(
                        url!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.radio_rounded,
                          size: 96,
                          color: cs.onPrimaryContainer.withOpacity(0.6),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  const _StatusPill({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _ScreenState {
  final MediaItem? mediaItem;
  final PlaybackState playbackState;
  _ScreenState({required this.mediaItem, required this.playbackState});
}
