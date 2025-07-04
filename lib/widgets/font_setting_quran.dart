import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSettingsScreenQuran extends StatefulWidget {
  final String currentFont;
  final int currentFontSize;
  final void Function(String font, int fontSize) onApply;

  const FontSettingsScreenQuran({
    super.key,
    required this.currentFont,
    required this.currentFontSize,
    required this.onApply,
  });

  @override
  State<FontSettingsScreenQuran> createState() =>
      _FontSettingsScreenQuranState();
}

class _FontSettingsScreenQuranState extends State<FontSettingsScreenQuran> {
  late String selectedFont;
  late double fontSize;

  // Display name and actual fontFamily key used in pubspec
  final Map<String, String> fontMap = {
    'Uthmani': 'KFGQPC',
    'Scheherazade': 'Scheherazade',
    'Amiri': 'Amiri',
  };

  @override
  void initState() {
    super.initState();
    selectedFont = widget.currentFont;
    fontSize = widget.currentFontSize.toDouble();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', selectedFont);
    await prefs.setInt('fontSize', fontSize.toInt());
    widget.onApply(selectedFont, fontSize.toInt());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Font Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Quran Font:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),

            // Radio buttons for fonts
            ...fontMap.entries.map((entry) {
              return RadioListTile<String>(
                title: Text(
                  entry.key,
                  style: TextStyle(fontFamily: entry.value, fontSize: 18),
                ),
                value: entry.value,
                groupValue: selectedFont,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedFont = value);
                  }
                },
              );
            }),

            const SizedBox(height: 24),
            const Text('Font Size:', style: TextStyle(fontSize: 18)),
            Slider(
              value: fontSize,
              min: 14,
              max: 36,
              divisions: 11,
              label: fontSize.toInt().toString(),
              onChanged: (value) {
                setState(() => fontSize = value);
              },
            ),

            Center(child: Text('Preview ↓', style: TextStyle(fontSize: 16))),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: selectedFont, fontSize: fontSize),
              ),
            ),

            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Apply'),
                onPressed: _saveSettings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
