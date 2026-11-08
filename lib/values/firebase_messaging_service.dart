import 'dart:convert';
import 'dart:io';

import 'package:bamboo/values/local_notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._();

  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._();

  factory FirebaseMessagingService.instance() => _instance;

  Future<void> init({
    required LocalNotificationsService localNotificationsService,
  }) async {
    // Bildirim izni iste (Android 13+ ve iOS için gerekli)
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('Notification authorization: ${settings.authorizationStatus}');

    // iOS için foreground bildirimleri göster
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final String? title = message.notification?.title;
      final String? body = message.notification?.body;

      if (title != null || body != null) {
        // Extract URL from data payload based on platform
        String? urlToLaunch;

        // Platform-specific link extraction
        if (Platform.isAndroid) {
          urlToLaunch = message.data['android_link'] as String?;
        } else if (Platform.isIOS) {
          urlToLaunch = message.data['ios_link'] as String?;
        }

        // Fallback to generic 'url' field if platform-specific link not found
        if (urlToLaunch == null || urlToLaunch.isEmpty) {
          urlToLaunch = message.data['url'] as String?;
        }

        // Fallback to body if it's a URL
        if ((urlToLaunch == null || urlToLaunch.isEmpty) && body != null) {
          if (body.startsWith('http://') || body.startsWith('https://')) {
            urlToLaunch = body;
          }
        }

        localNotificationsService.showNotification(
          title: title ?? "Yeni Bildirim",
          body: body ?? "Detaylar için dokunun.",
          payload: urlToLaunch,
        );

        // Save notification to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final notifications = prefs.getStringList('notifications') ?? [];
        final newNotification = jsonEncode({
          'title': title,
          'body': body,
          'url': urlToLaunch,
          'date': DateTime.now().toIso8601String(),
        });
        notifications.add(newNotification);
        await prefs.setStringList('notifications', notifications);
      }
    });
  }
}
