import 'dart:convert';

import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SurahYasinPage extends StatefulWidget {
  final String pdfAssetPath;
  const SurahYasinPage({super.key, required this.pdfAssetPath});

  @override
  State<SurahYasinPage> createState() => _SurahYasinPageState();
}

class _SurahYasinPageState extends State<SurahYasinPage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: ArabicText(
          languageProvider.localizedStrings["Surah Yasin"] ?? 'Surah Yasin',
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
        child: Container(
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
