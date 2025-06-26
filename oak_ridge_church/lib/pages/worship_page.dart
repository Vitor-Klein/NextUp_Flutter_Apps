import 'package:flutter/material.dart';

class WorshipPage extends StatelessWidget {
  const WorshipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'Worship Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        children: const [
          _ModernExpansionTile(
            title: 'Worship Services',
            icon: Icons.church,
            content: '''
Sunday School at 8:30 a.m.
Oak Ridge offers a wide range of classes for all ages including the New Membership Class and the L.O.V.E. Ministry class. If you need assistance in selecting the right class, our Sunday School Superintendent is available to assist you.

Sunday Worship Service at 9:50 a.m.
1st Sunday Communion & Baptism starts at 8:30 a.m.

You are invited to come and share in our dynamic and spirited worship services as we worship God in singing, scripture reading, prayers and the sharing of God’s word from Pastor Turner.

Youth Worship Service at 9:50 a.m.
Youth 1st thru 6th grade are dismissed from regular Worship Service to convene in the Youth Sanctuary for worship. Their worship experience is tailored to meet the spiritual needs of youth while training and developing them for future Christian service. Youth also get the opportunity to participate in youth oriented activities and games. If you need assistance in selecting the right class, our Director of Youth Ministry will be available to assist you.
''',
          ),
          SizedBox(height: 12),
          _ModernExpansionTile(
            title: 'Wednesday Services',
            icon: Icons.event_note,
            content: '''
If you like to enhance your spiritual growth, our Wednesday services are the place for you.

Noon Day Adult Bible Study 11:30am – 1:00pm
Spend your lunch hour with Pastor Turner as he teaches and explores the Gospel of John. With each session you will experience an enhancement of your spiritual growth.

Sunday School Teachers Meeting
Teacher’s meetings are held on Wednesday evenings at 6:00pm in Room 115. At these meetings, Pastor Turner explains the lesson and guides the teachers to which main points to cover.
Teacher’s are to gather information from these meetings as preparation for the following Sunday Morning Classes.
Any members that are interested in becoming a teacher must attend these classes regularly.

Tutorial Ministry 6:00pm – 6:30pm
The Oak Ridge Tutorial Ministry is a ministry designed to meet the educational need of our youth from K-12th grade. This group of dedicated professionals, offer tutoring services in most major subjects and encourage students to excel academically.

Youth Bible Study 6:30pm - 7:45pm
While the adults are having prayer meeting and Bible Study in the sanctuary, youth ages 6-18 years of age are being taught the Bible in Youth Bible Study. Youth also have the opportunity to participate in rap groups and participate in fun activities.

Prayer Meeting 6:30pm
Wednesday evening services begins with Prayer Meeting. This service is filled with songs, scripture and prayers. Members are also given the opportunity to share their personal testimonies and experiences with the church family.

Evening Bible Study
We invite you to come study the word of God with us as Pastor Turner teaches and explores the Book of the Bible.
''',
          ),
        ],
      ),
    );
  }
}

class _ModernExpansionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _ModernExpansionTile({
    required this.title,
    required this.icon,
    required this.content,
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
            Text(
              content,
              style: const TextStyle(
                fontSize: 15.5,
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
