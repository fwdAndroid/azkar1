import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReadQuran extends StatefulWidget {
  const ReadQuran({super.key});

  @override
  State<ReadQuran> createState() => _ReadQuranState();
}

class _ReadQuranState extends State<ReadQuran> {
  late final WebViewController _controller;
  bool _isLoading = true;

  final String firebasePDF =
      'https://firebasestorage.googleapis.com/v0/b/star-44459.appspot.com/o/quran.pdf?alt=media&token=2b722aef-cb52-48aa-95f9-70ab26cd97d3';

  @override
  void initState() {
    super.initState();
    final String viewerUrl =
        'https://docs.google.com/gview?embedded=true&url=$firebasePDF';
    _controller = WebViewController()
      ..loadRequest(Uri.parse(viewerUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Read Quran')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
