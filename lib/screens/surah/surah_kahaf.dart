import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OpenSurahPage extends StatefulWidget {
  final String pdfAssetPath;
  const OpenSurahPage({super.key, required this.pdfAssetPath});

  @override
  State<OpenSurahPage> createState() => _OpenSurahPageState();
}

class _OpenSurahPageState extends State<OpenSurahPage> {
  List ayahs = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: ArabicText(
          languageProvider.localizedStrings["Surah Al-Kahf"] ?? 'Surah Al-Kahf',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
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
    );
  }
}
