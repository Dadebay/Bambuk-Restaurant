// ignore_for_file: file_names
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// A service class to manage Firebase Cloud Messaging (FCM) and Awesome Notifications.
class FCMConfig {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initializes Awesome Notifications and configures Firebase Messaging.
  Future<void> initializeNotifications() async {
    try {
      // Request user permission for notifications.
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted notifications permission');

        // Fetch the Firebase Messaging token.
        final token = await _messaging.getToken();
        if (token != null) {
          debugPrint('FCM Token: $token');
        } else {
          debugPrint('Error: Unable to fetch FCM token.');
        }

        // Subscribe to predefined topics.
        await _subscribeToTopics(['ttf_channel']);
      } else {
        debugPrint('User denied notifications permission');
      }

      // Initialize Awesome Notifications.
      await _initializeAwesomeNotifications();
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  /// Requests permission for displaying notifications.
  Future<void> requestNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  /// Sends a notification using Awesome Notifications.
  Future<void> sendNotification({required String title, required String body}) async {
    int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        wakeUpScreen: true,
      ),
    );
  }

  /// Subscribes to a list of topics.
  Future<void> _subscribeToTopics(List<String> topics) async {
    for (String topic in topics) {
      try {
        await _messaging.subscribeToTopic(topic);
        debugPrint('Subscribed to topic: $topic');
      } catch (e) {
        debugPrint('Error subscribing to topic $topic: $e');
      }
    }
  }

  /// Initializes Awesome Notifications configuration.
  Future<void> _initializeAwesomeNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          locked: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic Group',
        ),
      ],
      debug: false,
    );
  }
}
