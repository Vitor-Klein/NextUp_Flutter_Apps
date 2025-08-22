import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  // ====== CONFIGURE AQUI SEUS DADOS ======
  static const String companyName = 'Next.up';
  static const String phone = '+55 41 2626-4007';
  static const String whatsapp = '+55 41 2626-4007';
  static const String email = 'nextup.consultoria@gmail.com';
  static const String address =
      'Rua Somis Fellini, 600, Industrial, Medianeira-PR';
  static const String mapsQuery =
      'Rua Somis Fellini, 600, Industrial, Medianeira-PR';
  static const String website = 'https://nextup.com.br';
  static const String instagram = 'https://www.instagram.com/nextupconsultoria';
  static const String linkedin =
      'https://www.linkedin.com/company/nextupconsultoria ';

  static const String hours = '''
Seg - Sex: 09:00 — 18:00
Dom: Fechado
''';
  // =======================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact",
          style: TextStyle(
            color: Colors.black87, // título preto
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black87), // ícones pretos
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image(image: AssetImage('assets/logo.png'), height: 200),
            ),
            const SizedBox(height: 8),
            Text(
              'Estamos prontos para ajudar você.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Card: formas de contato rápidas
            _Card(
              title: 'Fale Conosco',
              child: Column(
                children: [
                  _ContactTile(
                    icon: Icons.call_outlined,
                    label: phone,
                    onTap: () => _callNumber(phone),
                    onCopy: () => _copy(context, phone),
                    actionLabel: 'Ligar',
                  ),
                  _ContactTile(
                    icon: FontAwesomeIcons.whatsapp,
                    label: whatsapp,
                    onTap: () => _openWhatsApp(whatsapp, 'Olá!'),
                    onCopy: () => _copy(context, whatsapp),
                    actionLabel: 'WhatsApp',
                  ),
                  _ContactTile(
                    icon: Icons.alternate_email_outlined,
                    label: email,
                    onTap: () => _sendEmail(email, 'Contato', ''),
                    onCopy: () => _copy(context, email),
                    actionLabel: 'E-mail',
                  ),
                  _ContactTile(
                    icon: Icons.language_outlined,
                    label: website,
                    onTap: () => _openUrl(website),
                    onCopy: () => _copy(context, website),
                    actionLabel: 'Abrir',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Card: endereço + abrir no Maps com preview
            _Card(
              title: 'Nossa Localização',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => _openMaps(mapsQuery),
                      child: Image.network(
                        'https://maps.googleapis.com/maps/api/staticmap?center=${Uri.encodeComponent(mapsQuery)}&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7C${Uri.encodeComponent(mapsQuery)}&key=AIzaSyCAQEhMMmPC3okxrFLG3iiGCftz6lcx1HM',
                        fit: BoxFit.cover,
                        height: 180,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.pin_drop_outlined),
                    label: const Text('Abrir no Maps'),
                    onPressed: () => _openMaps(mapsQuery),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Card: horários
            _Card(
              title: 'Horários de Atendimento',
              child: Text(
                hours.trim(),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
              ),
            ),

            const SizedBox(height: 16),

            // Card: redes sociais
            _Card(
              title: 'Redes Sociais',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _SocialChip(
                    icon: Icons.photo_camera_outlined,
                    label: 'Instagram',
                    onTap: () => _openUrl(instagram),
                  ),
                  _SocialChip(
                    icon: Icons.business_outlined,
                    label: 'LinkedIn',
                    onTap: () => _openUrl(linkedin),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Helpers =====
  static Future<void> _callNumber(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    await launchUrl(uri);
  }

  static Future<void> _openWhatsApp(String number, String text) async {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse(
      'https://wa.me/$digits?text=${Uri.encodeComponent(text)}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> _sendEmail(String to, String subject, String body) async {
    final uri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {'subject': subject, 'body': body},
    );
    await launchUrl(uri);
  }

  static Future<void> _openMaps(String query) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$text" copiado'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ===== Widgets de UI =====

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(blurRadius: 8, color: Colors.black12, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final VoidCallback onCopy;
  final String actionLabel;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.onCopy,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: Colors.black87),
      ),
      trailing: Wrap(
        spacing: 6,
        children: [
          IconButton(
            onPressed: onCopy,
            icon: const Icon(Icons.copy, size: 18),
            tooltip: "Copiar",
          ),
          ElevatedButton(onPressed: onTap, child: Text(actionLabel)),
        ],
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _SocialChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SocialChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
