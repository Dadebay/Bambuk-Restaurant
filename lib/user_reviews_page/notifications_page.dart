import 'dart:convert';

import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as constants;
import 'package:bamboo/webview_app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
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
      id: index,
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
          final backendNotifications = (data['data'] as List)
              .map((item) => NotificationModel.fromJson(item))
              .toList();
          for (var notification in backendNotifications) {
            final key = '${notification.title}-${notification.body}';
            notificationsMap.putIfAbsent(key, () => notification);
          }
        }
      } else {
        throw Exception(
            'Failed to load notifications from backend. Status Code: ${response.statusCode}');
      }

      final prefs = await SharedPreferences.getInstance();
      final localNotificationsJson = prefs.getStringList('notifications') ?? [];
      int localIndex = 0;
      for (final notificationJson in localNotificationsJson.reversed) {
        final notificationData = json.decode(notificationJson);
        final notification =
            NotificationModel.fromPrefs(notificationData, localIndex++);
        final key = '${notification.title}-${notification.body}';
        notificationsMap[key] = notification;
      }

      final mergedNotifications = notificationsMap.values.toList();
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
    final int dil = Provider.of<Which_page>(context).dil;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context),
            child: const Icon(IconlyLight.arrow_left_circle,
                color: Colors.black87, size: 26),
          ),
        ),
        title: Text(
          constants.ru_notifications[dil],
          style: const TextStyle(
            fontFamily: 'Semi',
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ),
      body: _buildBody(dil),
    );
  }

  Widget _buildBody(int dil) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(IconlyLight.info_circle,
                  size: 56, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                constants.ru_failed_to_load[dil],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Semi',
                    color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _fetchNotifications,
                icon: const Icon(IconlyLight.arrow_right, size: 18),
                label: Text(constants.ru_contin[dil]),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(IconlyLight.notification,
                  size: 44, color: AppColors.primary),
            ),
            const SizedBox(height: 18),
            Text(
              constants.ru_no_notifications[dil],
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Semi',
                  color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _fetchNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return _NotificationCard(notification: _notifications[index]);
        },
      ),
    );
  }
}

// ── Expandable notification card ─────────────────────────────────────────────
class _NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  const _NotificationCard({required this.notification});

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  static const int _collapseThreshold = 100;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final notification = widget.notification;
    final bool isLink = notification.body.startsWith('http');
    final bool isLong = notification.body.length > _collapseThreshold;

    return GestureDetector(
      onTap: isLink
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => WebViewPage(url: notification.body)),
              )
          : isLong
              ? () => setState(() => _expanded = !_expanded)
              : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Icon ─────────────────────────────────────────────────
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLink ? IconlyLight.send : IconlyBold.notification,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              // ── Content ───────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: const TextStyle(
                        fontFamily: 'GilroyBold',
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Body — clipped or expanded
                    Text(
                      notification.body,
                      maxLines: _expanded || !isLong ? null : 3,
                      overflow:
                          _expanded || !isLong ? null : TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Monto',
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                    // Read more / less button
                    if (isLong) ...[
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => setState(() => _expanded = !_expanded),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _expanded ? 'Doly görkez' : 'Doly gör',
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Semi',
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              _expanded
                                  ? IconlyLight.arrow_up_2
                                  : IconlyLight.arrow_down_2,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Date
                    if (notification.createdAt != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(IconlyLight.time_circle,
                              size: 13, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd MMM yyyy, HH:mm')
                                .format(notification.createdAt!),
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Semi',
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // ── Trailing icon ─────────────────────────────────────────
              if (isLink)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Icon(IconlyLight.arrow_right_2,
                      color: Colors.grey.shade400, size: 18),
                )
              else if (isLong)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Icon(
                    _expanded
                        ? IconlyLight.arrow_up_2
                        : IconlyLight.arrow_down_2,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
