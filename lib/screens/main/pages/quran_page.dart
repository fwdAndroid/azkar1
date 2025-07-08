import 'package:azkar/screens/main/quran_screens/surah_detail_screen.dart';
import 'package:azkar/utils/surah_names_utils.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

class ReadQuran extends StatefulWidget {
  const ReadQuran({super.key});

  @override
  State<ReadQuran> createState() => _ReadQuranState();
}

class _ReadQuranState extends State<ReadQuran> {
  List<int> allSurah = List.generate(114, (index) => index + 1);
  List<int> filteredSurah = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredSurah = allSurah;
    _searchController.addListener(_filterSurahs);
  }

  void _filterSurahs() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredSurah = allSurah;
      });
    } else {
      setState(() {
        filteredSurah = allSurah.where((surahNumber) {
          final arabic = arabicSurahNames[surahNumber - 1].toLowerCase();
          final english = quran.getSurahNameEnglish(surahNumber).toLowerCase();
          final transliteration = transliterationSurahNames[surahNumber - 1]
              .toLowerCase();

          return arabic.contains(query) ||
              english.contains(query) ||
              transliteration.contains(query);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quran App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Modern search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search surah...',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSurah.length,
                itemBuilder: (context, index) {
                  final surahNumber = filteredSurah[index];
                  return _buildSurahCard(context, surahNumber);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahCard(BuildContext context, int surahNumber) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            surahNumber.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        title: ArabicText(
          arabicSurahNames[surahNumber - 1],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: ArabicText(
          '${quran.getVerseCount(surahNumber)} verses ',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurahDetailScreen(surahNumber: surahNumber),
            ),
          );
        },
      ),
    );
  }
}
