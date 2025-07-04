import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChangeLangage extends StatefulWidget {
  const ChangeLangage({super.key});

  @override
  State<ChangeLangage> createState() => _ChangeLangageState();
}

class _ChangeLangageState extends State<ChangeLangage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
    ); // Access the provider

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: ArabicText(
          languageProvider.localizedStrings['Language'] ?? "Language",
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 16),
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: ArabicText(
                    languageProvider.localizedStrings['Select Language'] ??
                        'Select Language',
                  ),
                ),
              ),

              // ListTile for English
              ListTile(
                onTap: () {
                  languageProvider.changeLanguage('en'); // Change to English
                  Navigator.pop(context);
                },
                trailing: Icon(
                  languageProvider.currentLanguage == 'en'
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: Colors.white,
                  size: 20,
                ),
                title: ArabicText(
                  languageProvider.localizedStrings['English'] ?? "English",
                ),
              ),
              // ListTile for Arrabic
              ListTile(
                onTap: () {
                  languageProvider.changeLanguage('ar'); // Change to French
                  Navigator.pop(context);
                },
                trailing: Icon(
                  languageProvider.currentLanguage == 'ar'
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: Colors.white,
                  size: 20,
                ),
                title: ArabicText(
                  languageProvider.localizedStrings['Arabic'] ?? "Arabic",
                ),
              ),

              // ListTile for Portuguese
            ],
          ),
        ),
      ),
    );
  }
}
