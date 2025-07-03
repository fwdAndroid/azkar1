import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/provider/theme_provider.dart';
import 'package:azkar/screens/main/quran_screens/audio_quran.dart';
import 'package:azkar/screens/main/quran_screens/read_quran.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:azkar/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  // This should be your full list of ayahs, fetched or stored globally
  // For example purposes, I initialize an empty list here
  List<dynamic> allAyahs = [];

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context); // Access

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            drawer: DrawerWidget(),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: ArabicText(
                languageProvider.localizedStrings["Quran"] ?? 'Quran',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) => IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Colors.white,
                    ),
                    onPressed: () => themeProvider.toggleTheme(),
                  ),
                ),
              ],
              bottom: TabBar(
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: <Widget>[
                  Tab(
                    text: languageProvider.localizedStrings["Quran"] ?? 'Quran',
                  ),
                  Tab(
                    text:
                        languageProvider.localizedStrings["Audio Quran"] ??
                        'Audio Quran',
                  ),
                ],
              ),
            ),

            body: TabBarView(children: <Widget>[ReadQuran(), AudioQuran()]),
          ),
        ],
      ),
    );
  }
}
