import 'package:flutter/material.dart';

class PicturesPage extends StatelessWidget {
  const PicturesPage({super.key});

  final List<String> imagePaths = const [
    'assets/gallery/01.png',
    'assets/gallery/02.png',
    'assets/gallery/03.png',
    'assets/gallery/04.png',
    'assets/gallery/05.png',
    'assets/gallery/06.png',
    'assets/gallery/07.jpg',
    'assets/gallery/08.jpg',
    'assets/gallery/09.jpg',
    'assets/gallery/10.png',
    'assets/gallery/11.jpg',
    'assets/gallery/12.jpg',
    'assets/gallery/13.jpg',
    'assets/gallery/14.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: imagePaths.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showImageModal(context, imagePaths[index]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(imagePaths[index], fit: BoxFit.cover),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showImageModal(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
