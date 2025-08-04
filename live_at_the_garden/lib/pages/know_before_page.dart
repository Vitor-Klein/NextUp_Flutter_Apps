import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class KnowBeforePage extends StatelessWidget {
  const KnowBeforePage({super.key});

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Não foi possível abrir o link: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<_LinkItem> items = [
      _LinkItem(
        'Know Before You Go',
        'https://latgradians.squarespace.com/know-before-you-go',
      ),
      _LinkItem(
        'Directions and Parking',
        'https://latgradians.squarespace.com/directions-and-parking',
      ),
      _LinkItem(
        'Where Is My Table',
        'https://latgradians.squarespace.com/table-location',
      ),
      _LinkItem(
        'Where To Stay',
        'https://latgradians.squarespace.com/wheretostay',
      ),
      _LinkItem('Media', 'https://latgradians.squarespace.com/media'),
      _LinkItem('Venue Map', 'https://latgradians.squarespace.com/map'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Know Before You Go'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => _openUrl(item.url),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.amber),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LinkItem {
  final String title;
  final String url;

  _LinkItem(this.title, this.url);
}
