import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NotificationService {
  final FlutterLocalNotificationsPlugin? _localNotifications = !kIsWeb
      ? FlutterLocalNotificationsPlugin()
      : null;

  static const String _channelId = 'prodex_notifications';
  static const String _channelName = 'PRODEX Notifications';
  static const String _channelDescription = 'Notifications for PRODEX Platform';

  Future<void> initialize() async {
    try {
      if (!kIsWeb && _localNotifications != null) {
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');

        const InitializationSettings initializationSettings =
            InitializationSettings(android: initializationSettingsAndroid);

        await _localNotifications.initialize(initializationSettings);
      }
      print('Notification Service (Local Only) initialized');
    } catch (e) {
      print('Error initializing NotificationService: $e');
    }
  }

  Future<void> showNotification(String title, String body) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.high,
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _localNotifications?.show(
      DateTime.now().millisecond,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
