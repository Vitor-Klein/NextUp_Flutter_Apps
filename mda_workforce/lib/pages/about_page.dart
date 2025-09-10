import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // ===== Helpers =====
  Future<void> _call(String number) async {
    final cleaned = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: cleaned);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Não foi possível ligar para $number');
    }
  }

  Future<void> _email(String email, {String subject = ''}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: subject.isEmpty ? null : 'subject=${Uri.encodeComponent(subject)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Não foi possível enviar e-mail para $email');
    }
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Não foi possível abrir $url');
    }
  }

  // ===== Models =====
  static const _sectionPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700);
    final bodyStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(height: 1.6);

    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: ListView(
        children: [
          // Header
          Image.asset('assets/header.png', fit: BoxFit.cover),
          const SizedBox(height: 8),

          // 1) Welcome to Mississippi
          Padding(
            padding: _sectionPadding,
            child: Text('Welcome to Mississippi', style: titleStyle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'MDA is Mississippi’s premier economic and community development agency. '
              'Companies of every size – from homegrown Mississippi start-ups to international corporations – depend on MDA’s team of employees '
              'for business development assistance, support with business incentives and access to talent from workforce training programs, colleges and universities.\n\n'
              'MDA also helps small- to mid-sized businesses become competitive in national and global economies through a comprehensive series of international trade and investment programs.',
              style: bodyStyle,
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 24),

          // 2) How can we help? (com sub-seções e contatos)
          Padding(
            padding: _sectionPadding,
            child: Text('How can we help?', style: titleStyle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'The Mississippi Development Authority is dedicated to ensuring companies have the information they need to keep them on the road to success.\n\n'
              'Expect neighborly, competent business guidance when you connect with us. That’s just how we do things in the Magnolia State.',
              style: bodyStyle,
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 8),

          // Sub-seções em ExpansionTiles
          _ProgramTile(
            programTitle: 'Minority & Small Business',
            description:
                'MDA strives for economic development in Mississippi by connecting minority- and women-owned businesses with a strong network of support, educational resources, financial programs and technical assistance.',
            contacts: const [
              Contact(
                'Carol Harris',
                'Director of Minority and Small Business',
                phone: '601.359.5081',
              ),
              Contact(
                'Joycie Lenoir',
                'MS APEX Accelerator, Program Manager',
                phone: '601.359.2904',
              ),
              Contact(
                'Natalie Purvis',
                'MS APEX Accelerator Advisor/Counselor-Meridian',
                phone: '601.934.5975',
              ),
              Contact(
                'Dr. Latonia Lewis',
                'Business Dev. Program Manager; Community Liaison',
                phone: '601.359.6678',
              ),
              Contact(
                'Cacynthia Patterson',
                'Bid Clerk: Bids, Solicitations, Social Media',
                phone: '601.359.2036',
              ),
              Contact(
                'Gernika Collins',
                'Certification Officer: Certifications, Loans, Marketing, Solicitations',
                phone: '601.359.2910',
              ),
              Contact(
                'Princess Hayes',
                'MS APEX Accelerator Advisor/Counselor-Central MS',
                phone: '601.359.2988',
              ),
              Contact(
                'James Stanton',
                'MS APEX Accelerator Advisor/Counselor-Southaven',
                phone: '662.324.2379',
              ),
            ],
            onCall: _call,
            onEmail: _email,
          ),

          _ProgramTile(
            programTitle: 'Entrepreneur Center',
            description:
                'As a bureau within MDA’s Minority & Small Business Division, The Entrepreneur Center team fosters the spirit of entrepreneurialism throughout Mississippi.',
            contacts: const [
              Contact(
                'Joe Donovan',
                'Director of Technology, Innovation and Entrepreneurship',
                phone: '601.359.2399',
              ),
              Contact(
                'Nerissa Tripp',
                'Minority Surety Bond, Minority Loan Program, Financial Analysis & Business Planning',
                phone: '601.359.2219',
              ),
              Contact(
                'Michael Harris',
                'Business Start-up, Expansion, Planning & Training',
                phone: '601.359.3420',
              ),
              Contact(
                'Nash Nunnery',
                'Business Start-up, Expansion, Planning & Training',
                phone: '601.359.9241',
              ),
            ],
            onCall: _call,
            onEmail: _email,
          ),

          _ProgramTile(
            programTitle: 'Business Research & Workforce Development',
            description:
                'Our team supports the state’s businesses by providing marketing, information and technical assistance programs.',
            contacts: const [
              Contact(
                'Bill Ashley',
                'Director of Business Research & Workforce Development',
                phone: '601.359.3040',
              ),
              Contact(
                'Deloise Tate',
                'Research Specialist/New & Expanded Industry Reports',
                phone: '601.359.2990',
              ),
            ],
            onCall: _call,
            onEmail: _email,
          ),

          _ProgramTile(
            programTitle: 'Business Recruitment and Expansion',
            contacts: const [
              Contact(
                'Bill Cork',
                'Chief Economic Development Officer',
                phone: '601.359.5769',
              ),
              Contact('Joey Roberts', 'Project Manager', phone: '601.359.2374'),
              Contact(
                'Gabriella Nuzzo',
                'Project Manager',
                phone: '601.359.6645',
              ),
              Contact('Jhai Keeton', 'Project Manager', phone: '601.359.2900'),
              Contact(
                'Joseph Cambonga',
                'Project Manager',
                phone: '601.359.2677',
              ),
              Contact('TA Jones', 'Project Manager', phone: '601.359.2789'),
              Contact(
                'Marc Measells',
                'Project Manager',
                phone: '601.359.9513',
              ),
              Contact(
                'Hunter Gardner',
                'Project Manager',
                phone: '601.359.5754',
              ),
              Contact(
                'Susie Robinson',
                'Economic Development Specialist',
                phone: '601.359.5763',
              ),
              Contact(
                'Denise Stewart',
                'Staff Officer - Executive',
                phone: '601.359.9343',
              ),
            ],
            onCall: _call,
            onEmail: _email,
          ),

          _ProgramTile(
            programTitle: 'International Trade and Investment',
            description:
                'Training and technical support to improve international prospects; the team also sponsors trade missions.',
            contacts: const [
              Contact(
                'Vickie Watters',
                'Director of Trade',
                phone: '601.359.2070',
              ),
              Contact(
                'Luigi Dominighini',
                'Latin American Trade Manager',
                phone: '601.359.9429',
              ),
              Contact(
                'Aggie Sikora',
                'Canadian and European Trade Manager',
                phone: '601.359.9342',
              ),
            ],
            onCall: _call,
            onEmail: _email,
          ),

          _ProgramTile(
            programTitle: 'Energy & Natural Resources',
            description:
                'Energy efficiency, workforce, projects and policy development, energy data and security for sector growth.',
            contacts: const [
              Contact(
                'Jason Pope',
                'Director of Energy and Natural Resources',
                phone: '601.359.2552',
              ),
              Contact(
                'Lisa Campbell',
                'Energy Education & Workforce Manager',
                phone: '601.359.6641',
              ),
              Contact(
                'Michael Cooley',
                'Energy Analyst',
                phone: '601.359.9402',
              ),
              Contact(
                'Gayle Sims',
                'Bureau Manager – Federal Reporting, MS Industrial Energy Efficiency',
                phone: '601.359.2923',
              ),
            ],
            onCall: _call,
            onEmail: _email,
          ),

          _ProgramTile(
            programTitle: 'Community and Rural Development',
            description:
                'Strengthens communities by helping identify, develop and promote unique assets to enhance quality of life.',
            contacts: const [
              Contact(
                'Tim Climer',
                'Manager of Programs & Services',
                phone: '601.359.9387',
              ),
            ],
            onCall: _call,
            onEmail: _email,
          ),

          _ProgramTile(
            programTitle: 'Community Incentives',
            description:
                'Assists with loan and grant qualifications and public infrastructure repair and improvement.',
            contacts: const [
              Contact(
                'Steve Hardin',
                'Director of Community Incentives',
                phone: '601.359.2366',
              ),
              Contact(
                'Peggy Knott',
                'Administrative Assistant',
                phone: '601.359.9323',
              ),
              Contact('Lisa Maxwell', 'Bureau Manager', phone: '601.359.2498'),
              Contact(
                'Tange Bozeman',
                'Program Manager',
                phone: '601.359.9490',
              ),
              Contact('Erin Hovanec', 'Bureau Manager', phone: '601.359.9376'),
              Contact(
                'Carolyn McKinney',
                'Program Manager',
                phone: '601.359.9316',
              ),
              Contact(
                'Tammie Lawrence',
                'Program Manager',
                phone: '601.359.9339',
              ),
              Contact(
                'Frednia Perkins',
                'Program Manager',
                phone: '601.359.9324',
              ),
              Contact('Caleb Prine', 'Program Manager', phone: '601-359-3633'),
              Contact(
                'Jacquelum M Allen',
                'Program Manager',
                phone: '6013592351',
              ),
              Contact(
                'Tammy Shaffer',
                'Program Manager',
                phone: '601.359.9289',
              ),
            ],
            onCall: _call,
            onEmail: _email,
          ),

          const Divider(height: 24),

          // 3) Local and international offices
          Padding(
            padding: _sectionPadding,
            child: Text('Local and international offices', style: titleStyle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Our team is ready to help. Find us at:',
              style: bodyStyle,
            ),
          ),
          const SizedBox(height: 8),
          _OfficeCard(
            title: 'Mississippi Development Authority Headquarters',
            lines: const ['501 North West Street, Jackson, MS 39201'],
          ),
          _OfficeCard(
            title: 'State of Mississippi South American Representative Office',
            lines: const [
              'Alcantara 200, Piso 6, Las Condes',
              'Santiago, Chile',
              '(+56-2) 2369-5653',
            ],
            contactEmail: 'odiaz@mississippi.org',
            contactName: 'Orlando Diaz, director',
            onEmail: _email,
          ),
          _OfficeCard(
            title: 'State of Mississippi Japan Representative Office',
            lines: const [
              'Helios Kannai Bldg. #413 3-21-2',
              'Motohama-cho, Naka-Ku, Yokohama, Kanagawa 231-0004, Japan',
              '(81.45)222-0792',
            ],
            contactEmail: 'Ykobayashi@mississippi.org',
            onEmail: _email,
          ),
          _OfficeCard(
            title: 'State of Mississippi Korea Director',
            lines: const [
              'A-1711, 406 Teheran-ro, Gangnam-gu (Champs Elysees Center)',
              'Seoul, Korea',
              '+82-2-548-9125',
            ],
            contactEmail: 'choss.ms@gmail.com',
            contactName: 'Seok Soon “SS” Cho, chief representative',
            onEmail: _email,
          ),
          _OfficeCard(
            title: 'State of Mississippi Europe Representative Office',
            lines: const [
              'Holsteinische Str. 29',
              '12161 Berlin, Germany',
              '+49 30 2579 1125',
              '+82-2-548-9125',
            ],
            contactEmail: 'sgerlach@mississippi.org',
            contactName: 'Sebastian Gerlach, director',
            onEmail: _email,
          ),

          const Divider(height: 24),

          // 4) Doing business with MDA
          Padding(
            padding: _sectionPadding,
            child: Text('Doing business with MDA', style: titleStyle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'We look forward to hearing from you and are excited for the opportunity to continue doing good work for Mighty Mississippi. '
              'For information about doing business with the state of Mississippi, check out the Department of Finance and Administration’s State of Mississippi Vendors Guide, '
              'which discusses the structure of purchasing in Mississippi and the various techniques of purchasing available governmental units. '
              'The guide identifies the commodity class and the items covered by both negotiated agreements and competitively bid contracts. '
              'It also covers open market purchases and the commodities covered.',
              style: bodyStyle,
              textAlign: TextAlign.justify,
            ),
          ),

          // Se você tiver a URL do Vendors Guide, coloque aqui:
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: FilledButton(
          //     onPressed: () => _open('https://exemplo.da/url/do/vendors_guide'),
          //     child: const Text('Open Vendors Guide'),
          //   ),
          // ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ======= Reusable widgets & data =======

class Contact {
  final String name;
  final String role;
  final String? phone;
  final String? email;

  const Contact(this.name, this.role, {this.phone, this.email});
}

class _ProgramTile extends StatelessWidget {
  final String programTitle;
  final String? description;
  final List<Contact> contacts;
  final Future<void> Function(String) onCall;
  final Future<void> Function(String, {String subject}) onEmail;

  const _ProgramTile({
    required this.programTitle,
    required this.contacts,
    required this.onCall,
    required this.onEmail,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(height: 1.5);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: Text(
            programTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            if (description != null) ...[
              Text(
                description!,
                style: bodyStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 12),
            ],
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: contacts
                  .map(
                    (c) => _ContactCard(
                      contact: c,
                      onCall: onCall,
                      onEmail: onEmail,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final Contact contact;
  final Future<void> Function(String) onCall;
  final Future<void> Function(String, {String subject}) onEmail;

  const _ContactCard({
    required this.contact,
    required this.onCall,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: Colors.black54);

    return Container(
      width: 380,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact.name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(contact.role, style: muted),
          const SizedBox(height: 10),
          Row(
            children: [
              if (contact.phone != null) ...[
                IconButton(
                  tooltip: 'Ligar',
                  onPressed: () => onCall(contact.phone!),
                  icon: const Icon(Icons.phone),
                ),
                Text(
                  contact.phone!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 12),
              ],
              if (contact.email != null) ...[
                IconButton(
                  tooltip: 'Enviar e-mail',
                  onPressed: () =>
                      onEmail(contact.email!, subject: 'Contact via MDA'),
                  icon: const Icon(Icons.email_outlined),
                ),
                Flexible(
                  child: Text(contact.email!, overflow: TextOverflow.ellipsis),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _OfficeCard extends StatelessWidget {
  final String title;
  final List<String> lines;
  final String? contactEmail;
  final String? contactName;
  final Future<void> Function(String, {String subject})? onEmail;

  const _OfficeCard({
    required this.title,
    required this.lines,
    this.contactEmail,
    this.contactName,
    this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).textTheme.bodyMedium;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...lines.map((l) => Text(l, style: body)),
            if (contactEmail != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.alternate_email, size: 18),
                  const SizedBox(width: 6),
                  Flexible(
                    child: GestureDetector(
                      onTap: onEmail == null
                          ? null
                          : () => onEmail!(contactEmail!, subject: 'Inquiry'),
                      child: Text(
                        contactName == null
                            ? contactEmail!
                            : '$contactName — $contactEmail',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
