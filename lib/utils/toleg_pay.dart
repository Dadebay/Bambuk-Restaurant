import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// Backend `/api/v1/orders` (bank = toleg) jogaby.
class TolegPayment {
  final String paymentUrl, statusUrl, refreshUrl;

  TolegPayment(
      {required this.paymentUrl,
      required this.statusUrl,
      required this.refreshUrl});

  /// Jogap Toleg tölegi däl bolsa `null` gaýtarýar.
  static TolegPayment? tryParse(dynamic j) {
    if (j is! Map || j['payment_method'] != 'toleg') return null;
    final paymentUrl = j['payment_url'];
    final statusUrl = j['status_url'];
    final refreshUrl = j['refresh_url'];
    if (paymentUrl is! String || statusUrl is! String || refreshUrl is! String)
      return null;
    if (paymentUrl.trim().isEmpty ||
        Uri.tryParse(paymentUrl)?.hasScheme != true ||
        Uri.tryParse(statusUrl)?.scheme != 'https' ||
        Uri.tryParse(refreshUrl)?.scheme != 'https') {
      return null;
    }
    return TolegPayment(
      paymentUrl: paymentUrl,
      statusUrl: statusUrl,
      refreshUrl: refreshUrl,
    );
  }
}

/// Toleg programmasyny açýar we tölegiň statusuny yzygiderli barlaýar.
/// Netije: `true` = töledi.
Future<bool> showTolegPayDialog(
    BuildContext context, TolegPayment payment) async {
  final res = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _TolegPayDialog(payment: payment),
  );
  return res ?? false;
}

class _TolegPayDialog extends StatefulWidget {
  const _TolegPayDialog({required this.payment});

  final TolegPayment payment;

  @override
  State<_TolegPayDialog> createState() => _TolegPayDialogState();
}

class _TolegPayDialogState extends State<_TolegPayDialog>
    with WidgetsBindingObserver {
  static const _pollEvery = Duration(seconds: 3);
  static const _maxWait = Duration(minutes: 15);

  Timer? _timer;
  final _started = DateTime.now();
  bool _finished = false;
  bool _timedOut = false;
  bool _busy = false;
  String? _status;
  String _message = 'Töleg garaşylýar...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _open();
    _timer = Timer.periodic(_pollEvery, (_) => _check());
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _open() async {
    final ok = await launchUrl(Uri.parse(widget.payment.paymentUrl),
        mode: LaunchMode.externalApplication);
    if (!ok && mounted)
      setState(
          () => _message = 'Toleg programmasy açylmady. Täzeden synanyşyň.');
  }

  Future<void> _check({bool refresh = false}) async {
    if (_finished || _busy) return;
    if (!refresh && DateTime.now().difference(_started) > _maxWait) {
      _timer?.cancel();
      if (mounted) setState(() => _timedOut = true);
      return;
    }
    _busy = true;
    try {
      final uri = Uri.parse(
          refresh ? widget.payment.refreshUrl : widget.payment.statusUrl);
      final r = refresh ? await http.post(uri) : await http.get(uri);
      final body = json.decode(utf8.decode(r.bodyBytes));
      if (r.statusCode == 200 && body is Map) {
        if (!mounted) return;
        setState(() {
          _status = body['status'] as String?;
          _message = (body['message'] as String?) ?? _message;
          _finished = body['finished'] == true;
        });
        if (_finished) _timer?.cancel();
      } else if (refresh && body is Map && body['message'] != null && mounted) {
        setState(() => _message = body['message'].toString());
      }
    } catch (_) {
      // Tor ýalňyşlygy: indiki tikde täzeden synanyşarys.
    } finally {
      _busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final success = _finished && _status == 'success';
    final failed = _finished &&
        (_status == 'failed' || _status == 'expired' || _status == 'cancelled');
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Text('Toleg'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_finished && !_timedOut)
              const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CircularProgressIndicator()),
            if (_finished)
              Icon(
                success
                    ? Icons.check_circle
                    : failed
                        ? Icons.error
                        : Icons.info_outline,
                size: 56,
                color: success
                    ? Colors.green
                    : failed
                        ? Colors.red
                        : Colors.blue,
              ),
            const SizedBox(height: 8),
            Text(_message, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          if (_finished)
            TextButton(
                onPressed: () => Navigator.pop(context, success),
                child: const Text('OK'))
          else ...[
            TextButton(onPressed: _open, child: const Text('Toleg-i aç')),
            TextButton(
                onPressed: () => _check(refresh: true),
                child: const Text('Statusy barla')),
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Ýap')),
          ],
        ],
      ),
    );
  }
}
