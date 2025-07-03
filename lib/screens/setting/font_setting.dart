import 'package:azkar/provider/font_provider.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FontSettingsScreen extends StatelessWidget {
  final List<String> fonts = ['Amiri', 'Scheherazade'];

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontSettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('اعدادات الخط'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "اختر نوع الخط العربي",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Font Selection (Radio Buttons)
            ...fonts.map((font) {
              return RadioListTile<String>(
                title: Text(font, style: TextStyle(fontFamily: font)),
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
            Text(
              "حجم الخط: ${fontProvider.fontSize.toInt()}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            const Text(
              "معاينة الخط",
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
                'ٱللَّهُ نُورُ ٱلسَّمَـٰوَٰتِ وَٱلْأَرْضِ',
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
                label: const Text("استعادة الإعدادات الافتراضية"),
                onPressed: () {
                  fontProvider.updateFontFamily('Amiri');
                  fontProvider.updateFontSize(24.0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تمت استعادة الإعدادات الافتراضية"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
