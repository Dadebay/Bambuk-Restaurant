
import 'dart:convert';
import 'dart:io';

import 'package:bamboo/values/local_notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._();

  static final FirebaseMessagingService _instance = FirebaseMessagingService._();

  factory FirebaseMessagingService.instance() => _instance;

  Future<void> init({
    required LocalNotificationsService localNotificationsService,
  }) async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    await FirebaseMessaging.instance.getToken().then((token) {
      print('');
      print('═══════════════════════════════════════════════════════════════');
      print('🔥 FIREBASE FCM TOKEN 🔥');
      print('═══════════════════════════════════════════════════════════════');
      print('Platform: ${Platform.isAndroid ? "ANDROID" : Platform.isIOS ? "iOS" : "Unknown"}');
      print('Token: $token');
      print('═══════════════════════════════════════════════════════════════');
      print('');
      debugPrint('FCM Token: $token');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('');
      print('📨 FOREGROUND MESSAGE RECEIVED 📨');
      print('═══════════════════════════════════════════════════════════════');
      debugPrint('Got a message whilst in the foreground!');
      final String? title = message.notification?.title;
      final String? body = message.notification?.body;
      print('Title: $title');
      print('Body: $body');
      print('Data: ${message.data}');
      print('═══════════════════════════════════════════════════════════════');
      print('');
      debugPrint('Foreground Message Title: $title');
      debugPrint('Foreground Message Body (URL if present): $body');
      debugPrint('Foreground Message data: ${message.data}');

      if (title != null || body != null) {
        localNotificationsService.showNotification(
          title: title ?? "Yeni Bildirim",
          body: body ?? "Detaylar için dokunun.",
        );

        // Save notification to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final notifications = prefs.getStringList('notifications') ?? [];
        final newNotification = jsonEncode({
          'title': title,
          'body': body,
          'date': DateTime.now().toIso8601String(),
        });
        notifications.add(newNotification);
        await prefs.setStringList('notifications', notifications);
      }
    });
  }
}
