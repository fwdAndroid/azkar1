import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/screens/drawer_pages/allah_names.dart';
import 'package:azkar/screens/drawer_pages/tasbeeh_counter.dart';
import 'package:azkar/screens/main/quran_screens/audio_quran.dart';
import 'package:azkar/screens/setting/change_language.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context); // Access

    return Drawer(
      backgroundColor: Color(0xff097132),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 10),
            child: Image.asset("assets/logo.png", height: 150, width: 150),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListTile(
              title: ArabicText(
                languageProvider.localizedStrings["Allah Names"] ??
                    'Allah Names',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllahNames()),
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            title: ArabicText(
              languageProvider.localizedStrings["Tasbeeh Counter"] ??
                  'Tasbeeh Counter',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TashbeehCounter()),
              );
            },
          ),
          Divider(),
          ListTile(
            title: ArabicText(
              languageProvider.localizedStrings["Audio Quran"] ?? 'Audio Quran',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AudioQuran()),
              );
            },
          ),
          Divider(),
          ListTile(
            title: ArabicText(
              languageProvider.localizedStrings["Language Setting"] ??
                  'Language Setting',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => ChangeLangage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
