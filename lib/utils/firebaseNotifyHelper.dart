import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotifyHelper {
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'ttf_channel',
    'TTF channel message',
    description: 'This channel is used for important notifications from TTF.',
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification'),
  );

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlug = FlutterLocalNotificationsPlugin();

  static makeInit() async {
    await Firebase.initializeApp();

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/app_icon');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlug.initialize(initializationSettings);

    await _flutterLocalNotificationsPlug.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_channel);

    _requestPermissions();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(_firebaseMessagingHandler);
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

  static void _requestPermissions() {
    _flutterLocalNotificationsPlug.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    _flutterLocalNotificationsPlug.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> _firebaseMessagingHandler(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      _flutterLocalNotificationsPlug.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            styleInformation: BigTextStyleInformation('BamBoo',
                summaryText: notification.body,
                htmlFormatBigText: true,
                contentTitle: notification.title,
                htmlFormatTitle: true,
                htmlFormatContent: true,
                htmlFormatSummaryText: true,
                htmlFormatContentTitle: true),
            icon: '@drawable/app_icon',
          ),
        ),
      );
    }
  }
}
