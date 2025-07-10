import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  late PdfViewerController _pdfController;

  @override
  void initState() {
    _pdfController = PdfViewerController();
    super.initState();
  }

  Future<void> _downloadBiblePdf() async {
    try {
      final byteData = await rootBundle.load('assets/bible/bible.pdf');
      final Uint8List bytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/Bible.pdf');
      await file.writeAsBytes(bytes);

      final params = SaveFileDialogParams(sourceFilePath: file.path);
      await FlutterFileDialog.saveFile(params: params);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF saved successfully.')),
        );
      }
    } catch (e) {
      debugPrint('Error saving PDF: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save PDF.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1 Peter Bible Study - October '),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadBiblePdf,
          ),
        ],
      ),
      body: SfPdfViewer.asset(
        'assets/bible/bible.pdf',
        controller: _pdfController,
      ),
    );
  }
}
