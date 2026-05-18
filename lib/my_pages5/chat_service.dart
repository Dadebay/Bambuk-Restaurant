import 'dart:convert';

import 'package:bamboo/my_pages5/chat_message.dart';
import 'package:bamboo/values/constants.dart' as constants;
import 'package:http/http.dart' as http;

class ChatService {
  Future<List<ChatMessage>> getMessages({required int customerId}) async {
    final response = await http.get(
      Uri.https(constants.api, '/api/v1/chat/messages/$customerId'),
      headers: _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load messages: ${response.statusCode}');
    }

    final decoded = json.decode(utf8.decode(response.bodyBytes));
    final List<dynamic> messagesJson = _extractMessages(decoded);
    return messagesJson.whereType<Map<String, dynamic>>().map(ChatMessage.fromJson).toList();
  }

  Future<ChatMessage?> sendMessage({required String text, int? customerId}) async {
    final body = <String, dynamic>{'message': text};
    if (customerId != null) {
      body['customer_id'] = customerId;
    }

    final response = await http.post(
      Uri.https(constants.api, '/api/v1/chat/send'),
      headers: {
        ..._headers(),
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to send message: ${response.statusCode}');
    }

    final decoded = json.decode(utf8.decode(response.bodyBytes));
    final msgMap = _extractSingleMessage(decoded);
    if (msgMap == null) return null;
    return ChatMessage.fromJson(msgMap);
  }

  Map<String, String> _headers() {
    return {
      'Authorization': 'Bearer ${constants.token}',
      'Accept': 'application/json',
    };
  }

  List<dynamic> _extractMessages(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded['messages'] is List) {
        return decoded['messages'] as List<dynamic>;
      }
      if (decoded['data'] is List) {
        return decoded['data'] as List<dynamic>;
      }
      if (decoded['data'] is Map<String, dynamic>) {
        final data = decoded['data'] as Map<String, dynamic>;
        if (data['messages'] is List) {
          return data['messages'] as List<dynamic>;
        }
      }
    }

    if (decoded is List) {
      return decoded;
    }

    return <dynamic>[];
  }

  Map<String, dynamic>? _extractSingleMessage(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded['message'] is Map<String, dynamic>) {
        return decoded['message'] as Map<String, dynamic>;
      }
      if (decoded['data'] is Map<String, dynamic>) {
        final data = decoded['data'] as Map<String, dynamic>;
        if (data['message'] is Map<String, dynamic>) {
          return data['message'] as Map<String, dynamic>;
        }

        if (data.containsKey('id') && data.containsKey('message')) {
          return data;
        }
      }

      if (decoded.containsKey('id') && decoded.containsKey('message')) {
        return decoded;
      }
    }

    return null;
  }
}
