// notification_service.dart (or wherever FCMConfig and NotificationController are)
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bamboo/main.dart';
import 'package:bamboo/webview_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import Get if you haven't already, for navigation from main app context
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart'; // Only if you need external launch as fallback

class FCMConfig {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static bool _isAwesomeInitialized = false;

  Future<void> _initializeAwesomeNotificationsOnce() async {
    if (_isAwesomeInitialized) return; // Initialize only once
    await AwesomeNotifications().initialize(
      null, // null for default app icon
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for app alerts and updates.',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic Group',
        ),
      ],
      debug: true, // Set to false in production
    );
    _isAwesomeInitialized = true;
    debugPrint('Awesome Notifications Initialized/Verified.');
  }

  Future<void> initializeNotifications() async {
    try {
      await _initializeAwesomeNotificationsOnce();
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
        debugPrint('User granted Firebase notifications permission');
        final token = await _messaging.getToken();
        if (token != null) {
          debugPrint('FCM Token: $token');
          // You might want to send this token to your server
        } else {
          debugPrint('Error: Unable to fetch FCM token.');
        }
        await _subscribeToTopics(['ttf_channel']); // Example topic
      } else {
        debugPrint('User denied Firebase notifications permission');
      }
      await requestAwesomeNotificationPermission();
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  Future<void> ensureAwesomeInitializedForBackground() async {
    await _initializeAwesomeNotificationsOnce();
  }

  Future<void> requestAwesomeNotificationPermission() async {
    await _initializeAwesomeNotificationsOnce();
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      debugPrint('Requesting Awesome Notifications permission.');
      await AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      debugPrint('Awesome Notifications permission already granted.');
    }
  }

  bool _isValidUrl(String? urlString) {
    if (urlString == null || urlString.isEmpty) {
      return false;
    }
    return urlString.startsWith('http://') || urlString.startsWith('https://');
  }

  Future<void> sendNotification({
    required String title,
    required String body, // This will be the URL or plain text
  }) async {
    await _initializeAwesomeNotificationsOnce();

    int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    Map<String, String?> notificationPayload = {};
    String notificationBodyText = body;
    String? summaryText;

    if (_isValidUrl(body)) {
      notificationPayload = {'url': body}; // Crucial: pass URL in payload
      summaryText = body; // Can show URL in summary if desired
      // You might want to change notificationBodyText if it's a URL
      // e.g., notificationBodyText = "Tap to view details";
      // For now, we'll keep body as is, but payload['url'] is key.
    }

    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'basic_channel',
          title: title.isEmpty ? 'Yeni Bildirim' : title, // Default title if empty
          body: notificationBodyText, // The main text of the notification
          summary: summaryText, // Optional: shown below body, could be the URL
          notificationLayout: NotificationLayout.Default,
          wakeUpScreen: true,
          payload: notificationPayload, // URL is here for click handling
        ),
      );
      debugPrint('Awesome Notification created. Title: $title, Body: $notificationBodyText, Payload: $notificationPayload');
    } catch (e) {
      debugPrint('Error creating Awesome Notification: $e');
    }
  }

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
}

class NotificationController {
  // This class now primarily handles callbacks that AwesomeNotifications requires.
  // The actual navigation logic will be in _MyAppState using actionStream.

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod: ${receivedNotification.toMap()}');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod: ${receivedNotification.toMap()}');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod: ${receivedAction.toMap()}');
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod - Payload: ${receivedAction.payload}');
    debugPrint('onActionReceivedMethod - Summary: ${receivedAction.summary}');

    String? urlToLaunch = receivedAction.payload?['url'];

    if ((urlToLaunch == null || urlToLaunch.isEmpty) && receivedAction.summary != null && (receivedAction.summary!.startsWith('http://') || receivedAction.summary!.startsWith('https://'))) {
      urlToLaunch = receivedAction.summary;
    }

    if (urlToLaunch != null && urlToLaunch.isNotEmpty) {
      Get.to(() => WebViewPage(url: urlToLaunch!));
    } else {
      Get.to(() => const MyHomePage());
    }
  }
}
