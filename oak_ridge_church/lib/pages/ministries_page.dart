import 'package:flutter/material.dart';

class MinistriesPage extends StatelessWidget {
  const MinistriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'Ministries',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        children: const [
          _ModernImageExpansionTile.single(
            title: 'Worship & Arts Ministry',
            icon: Icons.music_note,
            imagePath: 'assets/ministries/worship.png',
            text: '''Daily Bread (Sign) Ministry
Ministering through biblical thoughts and to inform the public of “Special Days”.

Drama Productions
Presents religious interpretations of scriptures in an art form, song and/or dramatic acting by our very own talented membership.

Media
Records worship and special services on CD’s and DVD’s. Maintains a master tape of all services so that they can be provided for members or guests upon request.

Music Ministry
Comprised of various choirs and makes a vital contribution to all worship services. Supports the Pastor in ministering to other churches.''',
          ),
          SizedBox(height: 12),
          _ModernImageExpansionTile.single(
            title: 'Christian Education Ministries',
            icon: Icons.school,
            imagePath: 'assets/ministries/education.png',
            text: '''Bobby A. Stewart Church Growth
Designed to keep the entire membership close to the church family...

Children & Youth Ministry (K-12th Grade)
Special classes to increase their knowledge about Christ...

Oak Ridge Youth Development School
A Summer Youth Enrichment program...

L.O.V.E. (Living Our Vows Everyday) Class
For couples who are planning to be married and all married couples...

New Members Council
Help those who want to make a decision for Christ...

New Members Orientation Class
Help the new member become orientated to the church...

Sunday School
Classes for all age groups every Sunday at 8:30 a.m.

Tutorial Ministry
Serves the educational needs of Christ’s church.

Vacation Bible School
Diversified class groupings held for three nights.

Wallace L. Downs Scholarship Committee
Scholarships for students who want to attend college...

Young Adult Ministry
Ministers to the needs of young adults (18–35).

Young Men’s Society
Mentoring program for young males (10–18).

Young Women’s Society (YWS)
Mentoring program for young females (8–18).''',
          ),
          SizedBox(height: 12),
          _ModernImageExpansionTile.single(
            title: 'Outreach Ministries',
            icon: Icons.public,
            imagePath: 'assets/ministries/outreach.png',
            text: '''Brotherhood Ministry
Involves all the men of the church...

Bus Ministry
Bringing members and visitors to the church.

Court Appointed Special Advocate (CASA)
An advocate for children in court systems.

Evangelism Ministry
Presents Jesus to those who are lost.

Journey To Healing Ministry
Ministering to those who are suffering from a loss.

Mission Ministry
Demonstrates God’s love through acts of service.

Prison Ministry
Ministers to incarcerated individuals with the gospel.''',
          ),
          SizedBox(height: 12),
          _ModernImageExpansionTile.single(
            title: 'Service Ministries',
            icon: Icons.volunteer_activism,
            imagePath: 'assets/ministries/service.png',
            text: '''Church Picnic Committee
Organizes and plans the annual church picnic.

Culinary/Hospitality
Buys food and prepares meals...

Excursion
Coordinates church trips...

Newsletter
Publishes quarterly church news...

Nurses Corp
On-duty qualified nurses for every service.

Publicity & Announcement Committee
Promotes events via media and bulletin boards.

Property & Space
Manages building maintenance.

Usher Board
Welcomes and serves during services.

Security
Ensures safety of congregation and facilities.

Volunteer
Members who volunteer their time for ministry.

Finance
Assists the Pastor in church administration.''',
          ),
          SizedBox(height: 12),
          _ModernImageExpansionTile.single(
            title: 'Spiritual Service Ministries',
            icon: Icons.spa,
            imagePath: 'assets/ministries/spiritual.png',
            text: '''Associate Ministers
Assist the Pastor.

Deacon Ministry
Supports church spiritually and maintains peace.

Deaconess Ministries
Assists with communion and baptism of females.

Minister’s Wives
Spiritual support and unity.

Nominating Committee
Promotes spiritual growth and harmony in leadership.''',
          ),
          SizedBox(height: 12),
          _ModernImageExpansionTile.single(
            title: 'Ambassador Ministries',
            icon: Icons.groups_3,
            imagePath: 'assets/ministries/ambassadors.jpg',
            text: '''Young Adults (Age 18 – 35 years)
Ministers to young adults without separation.

Seasoned Adults (Age 36 – 59 years)

Senior Saints (Age 65 and Over)
Monthly fellowships and educational outings.''',
          ),
        ],
      ),
    );
  }
}

class _ModernImageExpansionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String imagePath;
  final String text;

  const _ModernImageExpansionTile.single({
    required this.title,
    required this.icon,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Icon(icon, color: const Color(0xFF2B4A83)),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B4A83),
            ),
          ),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          children: [
            Image.asset(imagePath),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 15.5, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
