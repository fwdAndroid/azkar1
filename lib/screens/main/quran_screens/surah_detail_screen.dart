import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;

  const SurahDetailScreen({super.key, required this.surahNumber});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  int fontSize = 18;
  bool showTranslation = true;

  @override
  Widget build(BuildContext context) {
    final surahName = quran.getSurahName(widget.surahNumber); // Arabic: البقرة
    final versesCount = quran.getVerseCount(widget.surahNumber);

    return Scaffold(
      appBar: AppBar(title: ArabicText(surahName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: versesCount,
          itemBuilder: (context, index) {
            final verseNumber = index + 1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Arabic text
                  ArabicText(
                    quran.getVerse(
                      widget.surahNumber,
                      verseNumber,
                      verseEndSymbol: true,
                    ),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: fontSize.toDouble() + 4,
                      fontFamily: 'Uthmanic',
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Verse number
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: ArabicText(
                      verseNumber.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Translation (if enabled)
                  if (showTranslation)
                    ArabicText(
                      quran.getVerseTranslation(
                        widget.surahNumber,
                        verseNumber,
                      ),
                      style: TextStyle(
                        fontSize: fontSize.toDouble(),
                        color: Colors.grey[700],
                      ),
                    ),
                  const Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
