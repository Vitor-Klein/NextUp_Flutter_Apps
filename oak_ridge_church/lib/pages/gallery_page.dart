import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  final List<String> imagePaths = const [
    'assets/gallery/01.jpg',
    'assets/gallery/02.jpg',
    'assets/gallery/03.jpg',
    'assets/gallery/04.jpg',
    'assets/gallery/05.jpg',
    'assets/gallery/06.jpg',
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
                borderRadius: BorderRadius.circular(12),
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
