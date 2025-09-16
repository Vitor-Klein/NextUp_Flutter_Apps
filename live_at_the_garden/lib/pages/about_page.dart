import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({
    super.key,
    this.remoteConfigKey = 'about_page',
    this.appBarTitle = 'About Us',
  });

  /// Nome da chave no Remote Config que contém a *lista* de blocos.
  final String remoteConfigKey;

  /// Título do AppBar (opcional).
  final String appBarTitle;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool _loading = true;
  String? _error;
  late final FirebaseRemoteConfig _rc;
  List<_Block> _blocks = const [];

  @override
  void initState() {
    super.initState();
    _rc = FirebaseRemoteConfig.instance;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _rc.fetchAndActivate();

      final raw = _rc.getString(widget.remoteConfigKey).trim();
      if (raw.isEmpty) {
        throw Exception('A chave "${widget.remoteConfigKey}" está vazia.');
      }

      final decoded = json.decode(raw);
      if (decoded is! List) {
        throw Exception('O valor da chave deve ser uma LISTA de blocos.');
      }

      final blocks = decoded
          .whereType<Map<String, dynamic>>()
          .map(_Block.fromMap)
          .where((b) => b != null)
          .cast<_Block>()
          .toList(growable: false);

      if (mounted) {
        setState(() {
          _blocks = blocks;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Widget _buildBlock(BuildContext context, _Block b) {
    switch (b.type) {
      case 'title':
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            b.content,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        );

      case 'description':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            b.content,
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
        );

      case 'image':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              b.content,
              fit: BoxFit.cover,
              loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              },
              errorBuilder: (ctx, err, stack) => Container(
                height: 160,
                color: Colors.black12,
                alignment: Alignment.center,
                child: const Text('Falha ao carregar imagem'),
              ),
            ),
          ),
        );

      default:
        // Tipos desconhecidos são ignorados silenciosamente.
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      content = _ErrorView(message: _error!, onRetry: _load);
    } else if (_blocks.isEmpty) {
      content = _EmptyView(onRetry: _load);
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _blocks.map((b) => _buildBlock(context, b)).toList(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: content,
        ),
      ),
    );
  }
}

class _Block {
  final String type;
  final String content;

  const _Block({required this.type, required this.content});

  static _Block? fromMap(Map<String, dynamic> map) {
    final type = map['type']?.toString().trim();
    final content = map['content']?.toString() ?? '';
    if (type == null || type.isEmpty) return null;
    return _Block(type: type, content: content);
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 40),
          const SizedBox(height: 12),
          Text(
            'Erro ao carregar conteúdo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onRetry});
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 40),
          const SizedBox(height: 12),
          Text(
            'Sem blocos para exibir',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Atualize o Remote Config com a lista de blocos desta página.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: onRetry, child: const Text('Recarregar')),
        ],
      ),
    );
  }
}
