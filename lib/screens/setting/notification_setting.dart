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

    // 🔔 Reschedule notifications through the provider method
    final provider = Provider.of<PrayerTimeProvider>(context, listen: false);
    await provider.scheduleAllPrayerNotifications(provider.prayerTimes);

    // ✅ Show Snackbar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enabled
              ? '$prayer notification enabled'
              : '$prayer notification disabled',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Azan Notification Settings")),
      body: ListView.builder(
        itemCount: _prayers.length,
        itemBuilder: (context, index) {
          final prayer = _prayers[index];
          final enabled = _prayerToggles[prayer] ?? true;

          return SwitchListTile(
            title: Text("Enable $prayer Notification"),
            value: enabled,
            onChanged: (value) => _togglePrayer(prayer, value),
          );
        },
      ),
    );
  }
}
