import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

class NotificationService {
  final FirebaseMessaging fireMessaging;
  final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();

  NotificationService(this.fireMessaging);

  Future<void> initialize() async {
    // Request permission for notifications
    await _requestPermission();
    
    // Initialize foreground message handling
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Initialize background message handling
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await fireMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission for notifications");
    } else {
      print("User denied or has not granted permission");
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print("Foreground message received: ${message.notification?.title}");
    _showNotification(message);
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print("Background message received: ${message.notification?.title}");
  }

  Future<void> _showNotification(RemoteMessage message) async {
    var androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    var platformDetails = NotificationDetails(android: androidDetails);
    await localNotifications.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformDetails,
    );
  }

  Future<String?> getToken() async {
    return await fireMessaging.getToken();
  }
}