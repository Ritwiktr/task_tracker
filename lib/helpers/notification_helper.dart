import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  static Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledDate) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'task_tracker_channel',
          'Task Tracker Notifications',
          channelDescription: 'Notifications for tasks due today',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: '${scheduledDate.toIso8601String()}|$title|$body',
    );
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    // Handle iOS notification when app is in the foreground
    print("Notification received: $id, $title, $body, $payload");
    // You can show a dialog or navigate to a specific screen here
  }

  static void onDidReceiveNotificationResponse(NotificationResponse details) {
    // Handle notification tapped logic here
    print("Notification tapped: ${details.payload}");
    if (details.payload != null) {
      final parts = details.payload!.split('|');
      if (parts.length == 3) {
        final scheduledDate = DateTime.parse(parts[0]);
        final title = parts[1];
        final body = parts[2];
        print("Due date and time: ${scheduledDate.toString()}");
        print("Title: $title");
        print("Body: $body");
        // You can navigate to a specific screen or perform actions based on this information
      }
    }
  }
}