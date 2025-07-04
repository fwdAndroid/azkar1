// lib/widgets/hijri_calendar.dart
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class HijriWidget extends StatelessWidget {
  const HijriWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final hijriDate = HijriCalendar.now();
    final gregorianDate = DateTime.now();

    // Format the hijri date
    final hijriFormatted =
        "${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear} AH";

    // Format the gregorian date
    final gregorianFormatted = DateFormat(
      'EEEE, d MMMM y',
    ).format(gregorianDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ArabicText(
            hijriFormatted,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D3B2A),
            ),
          ),
          const SizedBox(height: 8),
          ArabicText(
            gregorianFormatted,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ArabicText(
            hijriDate.longMonthName,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
