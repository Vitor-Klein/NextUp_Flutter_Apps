import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        children: const [
          _ModernImageExpansionTile(
            title: 'History',
            icon: Icons.history_edu,
            imagePaths: [
              'assets/history1.png',
              'assets/history2.png',
              'assets/history3.png',
            ],
            texts: [
              '''Oak Ridge Beginnings
The records indicate the Oak Ridge Missionary Baptist Church was organized in 1888. The following is a mere glimpse of the history.

Portions of the following were given by past members of Oak Ridge with Deacon Thomas Crockett being one of the key contributors. Deacon Crockett became a member of Oak Ridge in 1913. He passed away on May 22, 1985.

In 1880, Christian men in the neighborhood of Corum Road (now 91st & Parallel) and on Sprewell Hill (now Georgia Avenue) in White Church, Kansas saw a need for a church in their community. The men Asberry Porter, Willis Porter, Mel Sharp, Wade Scott, Allen Thompson, and Kemp Turner began holding services in their homes and became the “Colored Missionary Baptist Church of the Association of the State Kansas.” The Association provided visiting ministers for some Sundays. This practice continued for several years.
''',
              '''After much investigation for land and fervent prayer, J.E. Bogart gave the land to the church in 1888. With the stipulation that the land be used for ‘the express and only purpose as a place of worship”. The land along Parallel was a high ridge with large oak trees densely planted, hence the name of “Oak Ridge” was chosen for the church. Later, the church became known as “the little church on the hill”.

The men of the church built a basement of stone and services were held there in the beginning. It took many years to build the church, money was very scarce, but by the early 1900’s they were in a building.

In the early years, ministers were not plentiful, so there were visiting ministers who would take care of the church’s needs until a pastor was chosen. There have been eleven pastors who have served over the past years...
''',
              '''Under the pastorate of Rev. Downs, a new edifice was erected by purchasing a little over two acres of land from Mrs. Anna Jackson. The congregation marched into the new building on March 13, 1994, the dedication service was held on April 17, 1994.

Our eleventh pastor, Rev. Ricky D. Turner, was installed on April 5, 1998. Under his leadership, new ministries have been added, the church expanded with the purchase of 13.9 acres, and the current building was inaugurated in January 2005. Phase II of the project added many facilities.

Our continued growth is a testament to God’s grace as we continue to follow Pastor Turner, building on the foundation of Jesus Christ our Lord.
''',
            ],
          ),
          SizedBox(height: 12),
          _ModernImageExpansionTile.single(
            title: 'Membership',
            icon: Icons.group,
            imagePath: 'assets/history2.png',
            text: '''The Meaning of Membership
The Oak Ridge Missionary Baptist Church is called to be a caring community of Christians committed to developing a personal relationship with our Lord that inevitably eventuates into a ministry of evangelization, edification.

As members of the Oak Ridge Missionary Baptist Church family, we are called to discover and develop our God-given gifts and become sanctified stewards of our talents, time, money, and minds: and through the power of the Holy Spirit make a difference in our world.

Furthermore, we are called to demonstrate and incarnate God’s love, share the gospel, be a blessing to the hurting and the needy, that God will be glorified in all that we say and do...

Our eleventh pastor, Rev. Ricky D. Turner, was installed on April 5, 1998. The membership continues to increase and the building project expanded from 9200 to 9301 Parallel Parkway.

Phase I was completed in 2005 and Phase II in 2006 with expanded facilities for children, worship and outreach.
''',
          ),
          SizedBox(height: 12),
          _ModernImageExpansionTile.single(
            title: 'Beliefs',
            icon: Icons.book,
            imagePath: 'assets/history3.png',
            text: '''The Absolute Authority of the Inspired Scriptures
“We believe the Holy Bible was written by men divinely inspired and is a perfect treasure of heavenly instructions…”

The True God
“We believe that there is one, and only one living and true God, an infinite, intelligent spirit…”

The Atonement
Baptists believe in the atonement made by Christ as the only basis of salvation…

Salvation
Baptists believe that the most important thing to every individual is the personal salvation of the soul. Every responsible soul is lost without Christ, and the gospel is offered freely to all. Refusal to accept Christ brings condemnation, while faith brings eternal life.
''',
          ),
        ],
      ),
    );
  }
}

class _ModernImageExpansionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String>? imagePaths;
  final List<String>? texts;
  final String? imagePath;
  final String? text;

  const _ModernImageExpansionTile({
    required this.title,
    required this.icon,
    this.imagePaths,
    this.texts,
    this.imagePath,
    this.text,
  });

  const _ModernImageExpansionTile.single({
    required this.title,
    required this.icon,
    required this.imagePath,
    required this.text,
  }) : imagePaths = null,
       texts = null;

  @override
  Widget build(BuildContext context) {
    final isMulti = imagePaths != null && texts != null;

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
          children: isMulti
              ? List.generate(imagePaths!.length, (i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(imagePaths![i]),
                      const SizedBox(height: 8),
                      Text(
                        texts![i],
                        style: const TextStyle(fontSize: 15.5, height: 1.5),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                })
              : [
                  Image.asset(imagePath!),
                  const SizedBox(height: 8),
                  Text(
                    text!,
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
