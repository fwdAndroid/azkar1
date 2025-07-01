import 'dart:async';
import 'package:azkar/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TashbeehCounter extends StatefulWidget {
  const TashbeehCounter({super.key});

  @override
  State<TashbeehCounter> createState() => _TashbeehCounterState();
}

class _TashbeehCounterState extends State<TashbeehCounter> {
  int counter = 0;
  bool timerRunning = false;
  DateTime? startTime;
  Duration elapsed = Duration.zero;
  Timer? timer;

  void startTimer() {
    setState(() {
      counter = 0;
      elapsed = Duration.zero;
      timerRunning = true;
      startTime = DateTime.now();
    });

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        elapsed = DateTime.now().difference(startTime!);
      });
    });
  }

  void stopTimer() {
    if (!timerRunning) return;

    timer?.cancel();
    setState(() {
      timerRunning = false;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Session Summary"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Total Taps: $counter"),
            const SizedBox(height: 8),
            Text("Total Time: ${elapsed.inSeconds} seconds"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void incrementCounter() {
    if (!timerRunning) return;
    setState(() {
      counter++;
    });
  }

  void reset() {
    timer?.cancel();
    setState(() {
      counter = 0;
      elapsed = Duration.zero;
      timerRunning = false;
    });
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final counterFontSize = screenWidth * 0.2;
    final buttonFontSize = screenWidth * 0.05;
    final timerFontSize = screenWidth * 0.07;
    final languageProvider = Provider.of<LanguageProvider>(context); // Access

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          languageProvider.localizedStrings["Tasbeeh"] ?? "Tasbeeh",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (timerRunning)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  formatDuration(elapsed),
                  style: TextStyle(
                    fontSize: timerFontSize,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Text(
              "$counter",
              style: TextStyle(
                fontSize: counterFontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // Tap Button
            ElevatedButton(
              onPressed: incrementCounter,
              style: _buttonStyle(screenWidth, screenHeight),
              child: Text(
                languageProvider.localizedStrings["Tap"] ?? "Tap",
                style: TextStyle(fontSize: buttonFontSize),
              ),
            ),

            const SizedBox(height: 20),

            // Start Button
            ElevatedButton(
              onPressed: timerRunning ? null : startTimer,
              style: _buttonStyle(screenWidth, screenHeight),
              child: Text(
                languageProvider.localizedStrings["Start"] ?? "Start",
                style: TextStyle(fontSize: buttonFontSize),
              ),
            ),

            const SizedBox(height: 10),

            // Stop Button
            ElevatedButton(
              onPressed: timerRunning ? stopTimer : null,
              style: _buttonStyle(screenWidth, screenHeight),
              child: Text(
                languageProvider.localizedStrings["Stop"] ?? "Stop",
                style: TextStyle(fontSize: buttonFontSize),
              ),
            ),

            const SizedBox(height: 20),

            // Reset
            TextButton(
              onPressed: reset,
              child: Text(
                languageProvider.localizedStrings["Reset"] ?? "Reset",
                style: TextStyle(
                  fontSize: buttonFontSize,
                  color: Colors.white70,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle(double width, double height) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white.withOpacity(0.9),
      foregroundColor: Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.2,
        vertical: height * 0.02,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    );
  }
}
