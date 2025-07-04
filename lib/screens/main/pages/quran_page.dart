import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReadQuran extends StatefulWidget {
  const ReadQuran({super.key});

  @override
  State<ReadQuran> createState() => _ReadQuranState();
}

class _ReadQuranState extends State<ReadQuran> {
  late final WebViewController _controller;
  bool isLoading = true;

  final String pdfUrl =
      'https://quranicquotes.com/wp-content/uploads/2014/10/Quran-Arabic-full-text.pdf';
  final String viewerUrl = 'https://docs.google.com/gview?embedded=true&url=';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse('$viewerUrl$pdfUrl'));
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context); // Access

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ArabicText(
          languageProvider.localizedStrings["Read Quran"] ?? 'Read Quran',
          style: TextStyle(color: Colors.white),
        ),
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
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
