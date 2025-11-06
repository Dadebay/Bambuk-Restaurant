import 'dart:convert';

import 'package:bamboo/values/constants.dart' as constants;
import 'package:bamboo/webview_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      body: json['body'] ?? 'No Body',
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    );
  }

  factory NotificationModel.fromPrefs(Map<String, dynamic> json, int index) {
    return NotificationModel(
      id: index, // Assign a unique ID for local notifications
      title: json['title'] ?? 'No Title',
      body: json['body'] ?? 'No Body',
      createdAt: DateTime.tryParse(json['date'] ?? ''),
    );
  }
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Fetch from backend
      final response = await http.get(
        Uri.parse('https://bambukresto.com.tm:4443/api/v1/push-notifications'),
        headers: {
          'Authorization': 'Bearer ${constants.token}',
        },
      );

      final Map<String, NotificationModel> notificationsMap = {};

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          final backendNotifications = (data['data'] as List).map((item) => NotificationModel.fromJson(item)).toList();
          for (var notification in backendNotifications) {
            final key = '${notification.title}-${notification.body}';
            notificationsMap.putIfAbsent(key, () => notification);
          }
        }
      } else {
        print('Backend Error: ${response.statusCode}');
        print('Backend Body: ${response.body}');
        throw Exception('Failed to load notifications from backend. Status Code: ${response.statusCode}');
      }

      // Fetch from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final localNotificationsJson = prefs.getStringList('notifications') ?? [];
      int localIndex = 0;
      for (final notificationJson in localNotificationsJson.reversed) {
        // reversed to process newest first
        final notificationData = json.decode(notificationJson);
        final notification = NotificationModel.fromPrefs(notificationData, localIndex++);
        final key = '${notification.title}-${notification.body}';

        // Local notifications have priority and will update backend ones if they exist
        notificationsMap[key] = notification;
      }

      final mergedNotifications = notificationsMap.values.toList();

      // Sort by date, newest first
      mergedNotifications.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      setState(() {
        _notifications = mergedNotifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        title: Text(constants.ru_notifications[Provider.of<Which_page>(context).dil]),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Text('${constants.ru_error_occurred[Provider.of<Which_page>(context).dil]}: $_error'),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Text(
          constants.ru_no_notifications[Provider.of<Which_page>(context).dil],
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchNotifications,
      child: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            child: ListTile(
              title: Text(
                notification.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(notification.body),
                  const SizedBox(height: 8),
                  if (notification.createdAt != null)
                    Text(
                      DateFormat('dd MMMM yyyy, HH:mm').format(notification.createdAt!),
                      style: const TextStyle(fontSize: 15, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                if (notification.body.startsWith('http')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(url: notification.body),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
