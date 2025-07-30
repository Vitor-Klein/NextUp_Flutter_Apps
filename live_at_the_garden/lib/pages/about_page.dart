import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/header.jpg'),
            const SizedBox(height: 16),
            const Text(
              'Live at the Garden has been providing Memphis with music since 2001! Each year, the Memphis Botanic Garden is the setting behind the successful Live at the Garden concert series.\n\n'
              'Beginning June 5, 2001, with our first performer, Memphis\' own Issac Hayes, Live has grown into one of the most successful outdoor entertainment series in the United States! Live is a series of five concerts during the summer and fall. Season tables and season lawn tickets are hot commodities! Individual show tickets are also sold through ticketmaster.com.\n\n'
              'Over the past 20 years, Live at the Garden has played host to such great artists such as Rob Thomas, Daryl Hall & John Oates, The Goo Goo Dolls, Diana Ross, Styx, ZZ Top, Robert Plant, Little Big Town, Darius Rucker, and Train just to name a few.\n\n'
              'With 2,500 people seated at white linen-cloth tables, and 4,500 people partying on the lawn, where else can you sip a cold beverage, relax and listen to some of the hottest touring artists in the world? Whether you bring in your own food and drinks, pre-order from one of our Live at the Garden caterers, or purchase on-site, Live at the Garden has everything you need for a great Memphis night!',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
