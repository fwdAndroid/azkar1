import 'package:azkar/provider/font_provider.dart';
import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FontSettingsScreen extends StatelessWidget {
  final List<String> fonts = ['Amiri', 'Scheherazade'];

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontSettingsProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context); // Access

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: ArabicText('اعدادات الخط'),
        backgroundColor: Colors.transparent,
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ArabicText(
                  languageProvider
                          .localizedStrings["Choose the type of Arabic font"] ??
                      "Choose the type of Arabic font",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Font Selection (Radio Buttons)
                ...fonts.map((font) {
                  return RadioListTile<String>(
                    title: ArabicText(font, style: TextStyle(fontFamily: font)),
                    value: font,
                    groupValue: fontProvider.arabicFontFamily,
                    onChanged: (value) {
                      if (value != null) {
                        fontProvider.updateFontFamily(value);
                      }
                    },
                  );
                }).toList(),

                const SizedBox(height: 20),
                ArabicText(
                  languageProvider.localizedStrings["Font Size"] ??
                      "Font Size: ${fontProvider.fontSize.toInt()}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: fontProvider.fontSize,
                  min: 18,
                  max: 48,
                  divisions: 15,
                  label: fontProvider.fontSize.toInt().toString(),
                  onChanged: (size) {
                    fontProvider.updateFontSize(size);
                  },
                ),

                const SizedBox(height: 20),
                const Divider(),
                ArabicText(
                  languageProvider.localizedStrings["Font Preview"] ??
                      "Font Preview",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: ArabicText(
                    languageProvider
                            .localizedStrings["God is the Light of the heavens and the earth."] ??
                        'God is the Light of the heavens and the earth.',
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                // 🔁 Reset Button
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: ArabicText(
                      languageProvider
                              .localizedStrings["Restore default settings"] ??
                          "Restore default settings",
                    ),
                    onPressed: () {
                      fontProvider.updateFontFamily('Amiri');
                      fontProvider.updateFontSize(24.0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: ArabicText(
                            languageProvider
                                    .localizedStrings["Default settings have been restored"] ??
                                "Default settings have been restored",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
