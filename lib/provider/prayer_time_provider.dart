import 'package:azkar/service/location_service.dart';
import 'package:azkar/service/prayer_location.dart';
import 'package:azkar/service/prayer_model.dart';
import 'package:azkar/service/prayer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class PrayerTimeProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  PrayerLocation? _currentLocation;
  List<PrayerTime> _prayerTimes = [];
  bool _isLoading = false;
  String? _error;

  PrayerLocation? get currentLocation => _currentLocation;
  List<PrayerTime> get prayerTimes => _prayerTimes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PrayerTimeProvider() {
    loadLocationAndPrayerTimes();
  }

  /// 🔔 Schedules notifications for each enabled prayer
  Future<void> scheduleAllPrayerNotifications(
    List<PrayerTime> prayerTimes,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    for (var prayer in prayerTimes) {
      final isEnabled = prefs.getBool('notify_${prayer.name}') ?? true;

      // Cancel if disabled
      if (!isEnabled) {
        await flutterLocalNotificationsPlugin.cancel(prayer.name.hashCode);
        continue;
      }

      try {
        final now = DateTime.now();
        final timeParts = prayer.time.split(':');
        final hour = int.tryParse(timeParts[0]) ?? 0;
        final minute = int.tryParse(timeParts[1]) ?? 0;

        var scheduledTime = tz.TZDateTime.local(
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );

        // Schedule for next day if time has passed
        if (scheduledTime.isBefore(now)) {
          scheduledTime = scheduledTime.add(const Duration(days: 1));
        }

        await flutterLocalNotificationsPlugin.zonedSchedule(
          prayer.name.hashCode,
          "${prayer.name} Azan",
          "It's time for ${prayer.name} prayer",
          scheduledTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'azan_channel',
              'Azan Notifications',
              channelDescription: 'Prayer time notifications',
              importance: Importance.max,
              priority: Priority.high,
              sound: RawResourceAndroidNotificationSound('azan'),
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (e) {
        debugPrint("⚠️ Error scheduling ${prayer.name}: $e");
      }
    }
  }

  /// 🕒 Get the next upcoming prayer and its DateTime (for countdown)
  MapEntry<PrayerTime, DateTime>? getNextPrayerWithTime() {
    final now = DateTime.now();

    for (final prayer in _prayerTimes) {
      try {
        final parts = prayer.time.split(':');
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;

        final prayerDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );

        if (prayerDateTime.isAfter(now)) {
          return MapEntry(prayer, prayerDateTime);
        }
      } catch (e) {
        debugPrint('⚠️ Error parsing prayer time: ${prayer.name} – $e');
      }
    }

    // If all prayers have passed, return tomorrow's Fajr
    if (_prayerTimes.isNotEmpty) {
      final parts = _prayerTimes.first.time.split(':');
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      final tomorrow = DateTime(now.year, now.month, now.day + 1, hour, minute);
      return MapEntry(_prayerTimes.first, tomorrow);
    }

    return null;
  }

  /// 📍 Load location and fetch prayer times, then schedule notifications
  Future<void> loadLocationAndPrayerTimes() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load saved or current location
      _currentLocation = await _locationService.getSavedLocation();
      if (_currentLocation == null) {
        _currentLocation = await _locationService.getCurrentLocation();
        await _locationService.saveSelectedLocation(_currentLocation!);
      }

      // Fetch and assign prayer times
      _prayerTimes = await PrayerTimeService.fetchPrayerTimes(
        _currentLocation!,
      );
      _error = null;

      // 🔁 Schedule notifications
      await scheduleAllPrayerNotifications(_prayerTimes);
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading prayer times: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🌍 Change location and re-fetch/schedule
  Future<void> updateLocation(PrayerLocation newLocation) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _locationService.saveSelectedLocation(newLocation);
      _currentLocation = newLocation;

      _prayerTimes = await PrayerTimeService.fetchPrayerTimes(newLocation);
      _error = null;

      // Re-schedule notifications for new location
      await scheduleAllPrayerNotifications(_prayerTimes);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔁 Reset to current device location
  Future<void> resetToCurrentLocation() async {
    try {
      final currentLocation = await _locationService.getCurrentLocation();
      await updateLocation(currentLocation);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 🕓 Get a specific prayer time by name
  String getPrayerTime(String prayerName) {
    final prayer = _prayerTimes.firstWhere(
      (p) => p.name == prayerName,
      orElse: () =>
          PrayerTime(name: prayerName, time: '--:--', isCurrent: false),
    );
    return prayer.time;
  }

  /// ✅ Check if this is the currently active prayer
  bool isCurrentPrayer(String prayerName) {
    return _prayerTimes.any((p) => p.name == prayerName && p.isCurrent);
  }
}
