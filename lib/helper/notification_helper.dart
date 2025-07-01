import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../service/prayer_model.dart'; // PrayerTime model

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> scheduleAzanNotifications(List<PrayerTime> prayers) async {
    await _plugin.cancelAll();

    const androidDetails = AndroidNotificationDetails(
      'azan_channel',
      'Azan Notifications',
      channelDescription: 'Notifications for Azan times',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
        'azan',
      ), // Use azan.mp3 from /res/raw
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    for (final prayer in prayers) {
      final timeParts = prayer.time.split(':');
      final now = DateTime.now();

      // Convert to today’s DateTime
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      if (scheduledTime.isAfter(now)) {
        await _plugin.zonedSchedule(
          prayer.name.hashCode,
          'Prayer Time',
          'Time for ${prayer.name} prayer',
          tz.TZDateTime.from(scheduledTime, tz.local),
          notificationDetails,
          matchDateTimeComponents: DateTimeComponents.time,
          androidScheduleMode: AndroidScheduleMode.alarmClock,
        );
      }
    }
  }
}
