import 'dart:convert';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:azkar/model/ruqyah_model_quran.dart';

class RuqyahScreen extends StatefulWidget {
  const RuqyahScreen({Key? key}) : super(key: key);

  @override
  State<RuqyahScreen> createState() => _RuqyahScreenState();
}

class _RuqyahScreenState extends State<RuqyahScreen> {
  late Future<List<RuqyahItem>> ruqyahList;

  @override
  void initState() {
    super.initState();
    ruqyahList = loadRuqyahFromJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: const ArabicText(
          "Ruqyah from Quran",
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
        child: SafeArea(
          child: FutureBuilder<List<RuqyahItem>>(
            future: ruqyahList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: ArabicText(
                    '❌ Error loading Ruqyah data:\n${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: ArabicText('No Ruqyah data found.'));
              }

              final data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return ExpansionTile(
                    title: ArabicText(
                      item.title,
                      style: TextStyle(color: Colors.white),
                    ),
                    children: item.verses.map((verse) {
                      return Column(
                        children: [
                          ListTile(
                            title: ArabicText(
                              verse.arabic,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: ArabicText(
                              verse.english,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<List<RuqyahItem>> loadRuqyahFromJson() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/lang/ruqyah_quran.json',
      );

      debugPrint("✅ JSON file loaded successfully.");

      final data = json.decode(jsonString);
      final List items = data['ruqyah'];

      final parsedItems = items
          .map((item) => RuqyahItem.fromJson(item))
          .toList();

      debugPrint("✅ Parsed Ruqyah items count: ${parsedItems.length}");
      for (var item in parsedItems) {
        debugPrint("📘 Loaded: ${item.title}, Verses: ${item.verses.length}");
      }

      return parsedItems;
    } catch (e) {
      debugPrint("❌ Failed to load Ruqyah JSON: $e");
      rethrow;
    }
  }
}
