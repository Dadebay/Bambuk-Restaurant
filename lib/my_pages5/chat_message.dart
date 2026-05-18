class ChatMessage {
  final int id;
  final int customerId;
  final String message;
  final String senderType;
  final bool isRead;
  final DateTime? createdAt;

  ChatMessage({
    required this.id,
    required this.customerId,
    required this.message,
    required this.senderType,
    required this.isRead,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: _toInt(json['id']),
      customerId: _toInt(json['customer_id']),
      message: (json['message'] ?? '').toString(),
      senderType: (json['sender_type'] ?? 'customer').toString(),
      isRead: _toBool(json['is_read']),
      createdAt: _toDateTime(json['created_at']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return false;
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
