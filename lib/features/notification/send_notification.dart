import 'dart:convert';
import 'package:car_rental_app_clean_arch/core/secrets/app_secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> sendPushNotification(
  String token,
  String message,
  String title,
) async {
  try {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'key=${AppSecrets.googleAPI}',
      },
      body: jsonEncode({
        "to": token,
        "notification": {
          "title": title,
          "body": message,
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
        }
      }),
    );

    debugPrint("✅ Push notification sent successfully.");
  } catch (e) {
    debugPrint("❌ Failed to send push notification: $e");
  }
}
