import 'package:azkar/provider/font_provider.dart';
import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/provider/theme_provider.dart';
import 'package:azkar/widgets/font_setting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class AyatAlKursiScreen extends StatefulWidget {
  const AyatAlKursiScreen({super.key});

  @override
  State<AyatAlKursiScreen> createState() => _AyatAlKursiScreenState();
}

class _AyatAlKursiScreenState extends State<AyatAlKursiScreen> {
  final String ayahText =
      '''اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ
لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ
لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ
مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ
يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ
وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ
وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ
وَلَا يَئُودُهُ حِفْظُهُمَا ۚ
وَهُوَ الْعَلِيُّ الْعَظِيمُ''';

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final fontSettings = Provider.of<FontSettings>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Colors.white,
              ),
              onPressed: () => themeProvider.toggleTheme(),
            ),
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Font Settings')),
            ],
            onSelected: (value) {
              if (value == 0) {
                showDialog(
                  context: context,
                  builder: (_) => const FontSettingsDialog(),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: shareSurahText,
          ),
        ],
        title: Text(
          languageProvider.localizedStrings["Ayat al-Kursi"] ?? 'Ayat al-Kursi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    ayahText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSettings.fontSize + 4,
                      fontFamily: fontSettings.fontFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void shareSurahText() {
    if (ayahText.isEmpty) return;

    String surahText = ayahText;

    Share.share(surahText, subject: 'Surah Al-Kahf');
  }
}
