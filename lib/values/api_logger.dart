import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// API islegleri ucin renkli logger.
///
/// Dine debug rejiminde isleyar - release build-de hic zat cap etmeyar.
/// `debugPrint` ulanylyar, sebabi `print` uzyn setirleri kesyar (Android logcat).
///
/// Eger konsolda renk derek `[32m` yaly nysanlar gorunse, [useColors]-y
/// `false` ediň - reňkler öçer, ýazgylar galar.
class ApiLog {
  ApiLog._();

  /// ANSI reňkleri ulanylsynmy?
  ///
  /// `flutter run` (terminal) we VS Code Debug Console reňkleri goldayar.
  /// Android Studio Logcat käwagt goldamayar - şonda muny `false` ediň.
  static bool useColors = true;

  // ─── ANSI kodlary ───
  static const String _reset = '\x1B[0m';
  static const String _bold = '\x1B[1m';
  static const String _cyan = '\x1B[36m';
  static const String _green = '\x1B[32m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _magenta = '\x1B[35m';
  static const String _grey = '\x1B[90m';

  static String _c(String text, String color) =>
      useColors ? '$color$text$_reset' : text;

  static const String _line = '───────────────────────────────────────────────';

  /// Iberilyan islegi cap edyar (gok).
  static void request({
    required String tag,
    required String method,
    required Uri url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    if (!kDebugMode) return;
    _print('');
    _print(_c('┌─ ➡️  $tag  ·  ISLEG IBERILYAR', '$_bold$_cyan'));
    _print(_c('│ $method ${url.path}', _cyan));
    if (headers != null && headers.isNotEmpty) {
      _print(_c('│ Header fields: ${headers.keys.join(', ')}', _grey));
    }
    if (body != null && body.isNotEmpty) {
      _print(_c('│ Body fields: ${body.keys.join(', ')}', '$_bold$_yellow'));
    }
    _print(_c('└$_line', _cyan));
  }

  /// Gelen jogaby cap edyar (200 = yasyl, galanlary = gyzyl).
  static void response({
    required String tag,
    required http.Response response,
  }) {
    if (!kDebugMode) return;
    final bool ok = response.statusCode >= 200 && response.statusCode < 300;
    final String color = ok ? _green : _red;
    final String icon = ok ? '✅' : '❌';

    _print('');
    _print(
        _c('┌─ $icon  $tag  ·  JOGAP ${response.statusCode}', '$_bold$color'));
    _print(_c('│ Path: ${response.request?.url.path ?? '<unknown>'}', _grey));
    _print(_c('│ Content-Type: ${response.headers['content-type']}', _grey));
    _print(_c('│ Body size: ${response.bodyBytes.length} bytes', _grey));
    _print(_c('└$_line', color));
  }

  /// Isleg asla backend-e yetmedik yagdayynda (internet, DNS, SSL, timeout).
  static void error({
    required String tag,
    required Object error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;
    _print('');
    _print(_c('┌─ 🔥  $tag  ·  ISLEG BASARSYZ (backend-e yetmedi)',
        '$_bold$_magenta'));
    _print(_c('│ Type: ${error.runtimeType}', _grey));
    if (stackTrace != null) _print(_c('│ Stack: $stackTrace', _grey));
    _print(_c('└$_line', _magenta));
  }

  /// Islendik yerde el bilen bellik goymak ucin (sary).
  static void note(String tag, Object message) {
    if (!kDebugMode) return;
    _print(_c('•  [$tag] $message', _yellow));
  }

  /// `debugPrint` uzyn setirleri bogyar - setir-setir cap edyaris.
  static void _print(String text) {
    for (final line in text.split('\n')) {
      debugPrint(line);
    }
  }
}
