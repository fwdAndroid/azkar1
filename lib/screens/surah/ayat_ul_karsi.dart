import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AyatAlKursiScreen extends StatefulWidget {
  String pdfAssetPath;

  AyatAlKursiScreen({super.key, required this.pdfAssetPath});

  @override
  State<AyatAlKursiScreen> createState() => _AyatAlKursiScreenState();
}

class _AyatAlKursiScreenState extends State<AyatAlKursiScreen> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ArabicText(
          languageProvider.localizedStrings["Ayat al-Kursi"] ?? 'Ayat al-Kursi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Scaffold(
        backgroundColor: Colors.white24,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(child: SfPdfViewer.asset(widget.pdfAssetPath)),
        ),
      ),
    );
  }
}
