import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationErrorWidget extends StatelessWidget {
  final String? error;
  final Function? callback;

  const LocationErrorWidget({Key? key, this.error, this.callback})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = SizedBox(height: 32);
    final errorColor = Color(0xffb00020);
    final languageProvider = Provider.of<LanguageProvider>(context); // Access

    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.location_off, size: 150, color: errorColor),
            box,
            ArabicText(
              error!,
              style: TextStyle(color: errorColor, fontWeight: FontWeight.bold),
            ),
            box,
            ElevatedButton(
              child: ArabicText(
                languageProvider.localizedStrings["Retry"] ?? "Retry",
              ),
              onPressed: () {
                if (callback != null) callback!();
              },
            ),
          ],
        ),
      ),
    );
  }
}
