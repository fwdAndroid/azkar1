import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Request POST_NOTIFICATIONS permission (for Android 13+)
  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // Schedule a test Azan notification
  Future<void> _testAzanNotification() async {
    await _requestNotificationPermission();

    const androidDetails = AndroidNotificationDetails(
      'azan_channel',
      'Azan Notifications',
      channelDescription: 'Channel for Azan notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
        'azan',
      ), // Ensure azan.mp3 is in res/raw
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    final now = DateTime.now();
    final testTime = tz.TZDateTime.from(
      now.add(const Duration(seconds: 5)),
      tz.local,
    );

    await _notificationsPlugin.zonedSchedule(
      9999, // Unique ID for test
      'Test Azan',
      'This is a test Azan notification',
      testTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Test Azan notification scheduled!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Settings")),
      body: Center(
        child: ElevatedButton(
          onPressed: _testAzanNotification,
          child: const Text("Test Azan Notification"),
        ),
      ),
    );
  }
}
