import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:azkar/provider/prayer_time_provider.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  final List<String> _prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
  final Map<String, bool> _prayerToggles = {};

  @override
  void initState() {
    super.initState();
    _loadToggles();
  }

  Future<void> _loadToggles() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var prayer in _prayers) {
        _prayerToggles[prayer] = prefs.getBool('notify_$prayer') ?? true;
      }
    });
  }

  Future<void> _togglePrayer(String prayer, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notify_$prayer', enabled);

    setState(() {
      _prayerToggles[prayer] = enabled;
    });

    final provider = Provider.of<PrayerTimeProvider>(context, listen: false);
    await provider.scheduleAllPrayerNotifications(provider.prayerTimes);

    final lang = Provider.of<LanguageProvider>(context, listen: false);

    final enabledText =
        lang.localizedStrings["notification_enabled"] ?? "notification enabled";
    final disabledText =
        lang.localizedStrings["notification_disabled"] ??
        "notification disabled";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ArabicText(
          enabled ? '$prayer $enabledText' : '$prayer $disabledText',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    final switchTitlePrefix =
        lang.localizedStrings["Enable Notification"] ?? "Enable Notification";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: ArabicText(
          lang.localizedStrings["Azan Notification Settings"] ??
              "Azan Notification Settings",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: _prayers.length,
          itemBuilder: (context, index) {
            final prayer = _prayers[index];
            final enabled = _prayerToggles[prayer] ?? true;

            return SwitchListTile(
              title: ArabicText(
                "$switchTitlePrefix $prayer",
                style: TextStyle(color: Colors.white),
              ),
              value: enabled,
              onChanged: (value) => _togglePrayer(prayer, value),
            );
          },
        ),
      ),
    );
  }
}
