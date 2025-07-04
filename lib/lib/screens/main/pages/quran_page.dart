import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReadQuran extends StatefulWidget {
  final int initialPage;

  const ReadQuran({super.key, this.initialPage = 1});

  @override
  State<ReadQuran> createState() => _ReadQuranState();
}

class _ReadQuranState extends State<ReadQuran> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pdfViewerController.jumpToPage(widget.initialPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Read Quran')),
      body: SfPdfViewer.asset(
        'assets/quran.pdf',
        controller: _pdfViewerController,
      ),
    );
  }
}
