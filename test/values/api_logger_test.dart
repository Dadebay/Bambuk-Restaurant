import 'package:bamboo/values/api_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('API diagnostics keep request and response secrets out of logs', () {
    final messages = <String>[];
    final originalDebugPrint = debugPrint;
    final originalColors = ApiLog.useColors;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) messages.add(message);
    };
    ApiLog.useColors = false;
    addTearDown(() {
      debugPrint = originalDebugPrint;
      ApiLog.useColors = originalColors;
    });

    final url =
        Uri.parse('https://example.test/api/v1/login/verify?otp=654321');
    ApiLog.request(
      tag: 'OTP',
      method: 'POST',
      url: url,
      headers: {'Authorization': 'Bearer private-token'},
      body: {'phone': '12345678', 'otp': '654321'},
    );
    ApiLog.response(
      tag: 'OTP',
      response: http.Response(
        '{"api_token":"private-response-token"}',
        200,
        request: http.Request('POST', url),
      ),
    );
    ApiLog.error(tag: 'OTP', error: Exception('private-error-token'));

    final output = messages.join('\n');
    expect(output, contains('POST /api/v1/login/verify'));
    expect(output, contains('JOGAP 200'));
    for (final secret in [
      '12345678',
      '654321',
      'private-token',
      'private-response-token',
      'private-error-token',
    ]) {
      expect(output, isNot(contains(secret)));
    }
  });
}
