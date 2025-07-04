import 'package:azkar/provider/language_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ViewDuaPage extends StatefulWidget {
  final String uuid;
  const ViewDuaPage({super.key, required this.uuid});

  @override
  State<ViewDuaPage> createState() => _ViewDuaPageState();
}

class _ViewDuaPageState extends State<ViewDuaPage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          languageProvider.localizedStrings["Dua"] ?? "Dua",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("dua")
              .where("uuid", isEqualTo: widget.uuid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  languageProvider.localizedStrings["No Dua found."] ??
                      "No Dua found.",
                ),
              );
            }

            final azkarList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: azkarList.length,
              itemBuilder: (context, index) {
                final azkar = azkarList[index].data() as Map<String, dynamic>;
                final arabic = azkar['dua'] ?? azkar['dua'] ?? '';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.19),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "﷽",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Scheherazade',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          arabic,
                          style: GoogleFonts.scheherazadeNew(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),

                        /// ✅ AUDIO PLAYER
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
