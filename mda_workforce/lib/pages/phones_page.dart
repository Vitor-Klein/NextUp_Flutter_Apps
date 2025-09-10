import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:url_launcher/url_launcher.dart';

const kRemoteConfigKey = 'phone_list';

class PhoneDirectoryPage extends StatefulWidget {
  const PhoneDirectoryPage({super.key});

  @override
  State<PhoneDirectoryPage> createState() => _PhoneDirectoryPageState();
}

class _PhoneDirectoryPageState extends State<PhoneDirectoryPage> {
  final _searchCtrl = TextEditingController();
  final _remoteConfig = FirebaseRemoteConfig.instance;

  bool _loading = true;
  String? _error;
  List<PhoneEntry> _all = [];
  String _filterType = 'all'; // all | cell | office

  @override
  void initState() {
    super.initState();
    _loadRemoteConfig();
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadRemoteConfig({bool refresh = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (refresh) {
        await _remoteConfig.fetchAndActivate();
      } else {
        // Primeiro tenta usar cache; se estiver vazio, busca
        await _remoteConfig.activate();
        if (_remoteConfig.getString(kRemoteConfigKey).isEmpty) {
          await _remoteConfig.fetchAndActivate();
        }
      }

      final raw = _remoteConfig.getString(kRemoteConfigKey);
      if (raw.isEmpty) {
        throw Exception(
          'Remote Config key "$kRemoteConfigKey" está vazia ou não existe.',
        );
      }

      final decoded = jsonDecode(raw);
      final list = (decoded['phones'] as List)
          .map((e) => PhoneEntry.fromJson(e as Map<String, dynamic>))
          .toList();

      setState(() {
        _all = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Falha ao carregar contatos: $e';
        _loading = false;
      });
    }
  }

  List<PhoneEntry> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    Iterable<PhoneEntry> base = _all;

    if (_filterType != 'all') {
      base = base.where((e) => e.type == _filterType);
    }

    if (q.isEmpty) return base.toList();

    return base.where((e) {
      final hay = '${e.name} ${e.division ?? ''} ${e.number}'
          .toLowerCase()
          .replaceAll(RegExp(r'\s+'), ' ');
      return hay.contains(q);
    }).toList();
  }

  Future<void> _call(String number) async {
    // Normaliza para apenas dígitos, e usa tel:
    final digits = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: digits);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o discador.')),
      );
    }
  }

  Color _colorForType(String type, BuildContext context) {
    switch (type) {
      case 'cell':
        return Colors.green.shade600;
      case 'office':
        return Colors.blue.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'cell':
        return Icons.smartphone;
      case 'office':
        return Icons.phone;
      default:
        return Icons.contact_phone;
    }
  }

  Widget _legend(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _legendItem(context, 'Cell', _colorForType('cell', context)),
        _legendItem(context, 'Office', _colorForType('office', context)),
      ],
    );
  }

  Widget _legendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Directory'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _filterType,
            onSelected: (v) => setState(() => _filterType = v),
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'all', child: Text('Todos')),
              PopupMenuItem(value: 'cell', child: Text('Somente celulares')),
              PopupMenuItem(
                value: 'office',
                child: Text('Somente escritórios'),
              ),
            ],
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar por tipo',
          ),
          IconButton(
            onPressed: () => _loadRemoteConfig(refresh: true),
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar do Remote Config',
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? _ErrorView(
                message: _error!,
                onRetry: () => _loadRemoteConfig(refresh: true),
              )
            : RefreshIndicator(
                onRefresh: () => _loadRemoteConfig(refresh: true),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    // Busca
                    TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Buscar por nome, divisão ou número...',
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Legenda + contagem
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _legend(context),
                        Text(
                          '${_filtered.length} resultados',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Lista
                    ..._filtered.map(
                      (e) => _PhoneCard(
                        entry: e,
                        color: _colorForType(e.type, context),
                        icon: _iconForType(e.type),
                        onCall: () => _call(e.number),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _PhoneCard extends StatelessWidget {
  final PhoneEntry entry;
  final VoidCallback onCall;
  final Color color;
  final IconData icon;

  const _PhoneCard({
    required this.entry,
    required this.onCall,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tile = ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.12),
        child: Icon(icon, color: color),
      ),
      title: Text(entry.name, style: theme.textTheme.titleMedium),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.division != null && entry.division!.trim().isNotEmpty)
            Text(entry.division!.trim()),
          Text(
            _humanizeNumber(entry.number),
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.call),
        color: color,
        onPressed: onCall,
        tooltip: 'Ligar',
      ),
      onTap: onCall,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
        color: Theme.of(context).cardColor,
      ),
      child: tile,
    );
  }

  String _humanizeNumber(String n) {
    // Formata 10 dígitos como 601-359-2320; mantém '+' se houver.
    final digits = n.replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.startsWith('+')) {
      return digits; // internacional já ok
    }
    final m = RegExp(r'^(\d{3})(\d{3})(\d{4})$').firstMatch(digits);
    if (m != null) {
      return '${m.group(1)}-${m.group(2)}-${m.group(3)}';
    }
    return digits;
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 38),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneEntry {
  final String name;
  final String number;
  final String type; // "cell" | "office" | outro
  final String? division;

  PhoneEntry({
    required this.name,
    required this.number,
    required this.type,
    this.division,
  });

  factory PhoneEntry.fromJson(Map<String, dynamic> json) {
    return PhoneEntry(
      name: (json['name'] ?? '').toString().trim(),
      number: (json['number'] ?? '').toString().trim(),
      type: (json['type'] ?? 'other').toString().trim().toLowerCase(),
      division: (json['division'] ?? '').toString().trim().isEmpty
          ? null
          : json['division'].toString().trim(),
    );
  }
}
