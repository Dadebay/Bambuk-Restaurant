import 'dart:async';
import 'dart:convert';

import 'package:bamboo/providers/bottom_prov.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/api_logger.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../DB/db.dart';

class Verify extends StatefulWidget {
  const Verify({super.key, required this.phoneNumber});
  final String phoneNumber;
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  /// SMS bilen gelyan kodun uzynlygy.
  static const int otpLength = 5;

  /// Kody gaytadan ibermek ucin garasylyan wagt (sekunt).
  static const int resendSeconds = 60;

  final TextEditingController verifyCode = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool loading = false;
  bool _hasError = false;
  int _secondsLeft = resendSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Fokus uytgande gutujygyn cyzygy tazelenmeli.
    _focusNode.addListener(() => _safeSetState(() {}));
    // initState-de setState gerek dal - gonuden-goni baslayarys.
    _secondsLeft = resendSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    verifyCode.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Widget agacdan ayrylanda setState cagyrylmazlygy ucin.
  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  /// Kod gaytadan iberilende hasaplayjyny nol nokadyndan baslayar.
  void _startCountdown() {
    _safeSetState(() => _secondsLeft = resendSeconds);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        _safeSetState(() => _secondsLeft = 0);
      } else {
        _safeSetState(() => _secondsLeft--);
      }
    });
  }

  String get _code => verifyCode.text;
  bool get _isComplete => _code.length == otpLength;

  int get _dil => Provider.of<Which_page>(context, listen: false).dil;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future sending(String name) async {
    var headers = {
      "phone": widget.phoneNumber,
      "otp": name,
    };
    var url = Uri.https(Constants.api, '/api/v1/login/verify');
    ApiLog.request(tag: 'OTP BARLAG', method: 'POST', url: url, body: headers);

    http.Response response;
    try {
      response = await http.post(url, body: headers);
    } catch (e, st) {
      ApiLog.error(tag: 'OTP BARLAG', error: e, stackTrace: st);
      if (!mounted) return;
      _safeSetState(() {
        loading = false;
        _hasError = true;
      });
      _showMessage(Constants.ru_failed_to_load[_dil]);
      return;
    }
    ApiLog.response(tag: 'OTP BARLAG', response: response);

    if (!mounted) return;
    if (response.statusCode == 200) {
      Constants.phone = widget.phoneNumber;
      var jsonData = json.decode(utf8.decode(response.bodyBytes));
      var m = jsonData['data'];
      DatabaseHelper.deleteUserAll();
      DatabaseHelper.addUser(m['id'], m['name'], m['surname'] ?? '', m['email'], m['username'], m['api_token']);
      Constants.token = m['api_token'];

      Constants.name1 = m['name'];
      Constants.name2 = m['surname'] ?? '';
      Constants.name = Constants.name1;
      if (m['surname'] != null) {
        Constants.name = m['name'] + ' ' + m['surname'] ?? '';
      }
      Constants.email = m['email'];
      try {
        Map<String, String> header = {'Authorization': 'Bearer ${Constants.token}'};
        final bonusUrl = Uri.https(Constants.api, '/api/v1/users/me/bonus');
        ApiLog.request(tag: 'BONUS', method: 'GET', url: bonusUrl, headers: header);
        var responseAmount = await http.get(bonusUrl, headers: header);
        ApiLog.response(tag: 'BONUS', response: responseAmount);
        var mamount = json.decode(utf8.decode(responseAmount.bodyBytes));
        Constants.bonusMoney = mamount['amount'];
      } catch (e, st) {
        ApiLog.error(tag: 'BONUS', error: e, stackTrace: st);
      }
      if (!mounted) return;
      _showMessage("Siz ulgamda!");

      Provider.of<BottomProv>(context, listen: false).set_reg(true);
      _safeSetState(() {
        loading = false;
        _hasError = false;
      });
      Navigator.pop(context);
      Provider.of<BottomProv>(context, listen: false).set_ver_true();
    } else {
      Constants.phone = "";
      _safeSetState(() {
        loading = false;
        _hasError = true;
      });
      _showMessage(Constants.ru_otp_wrong[_dil]);
    }
  }

  /// Kody gaytadan ibermek ucin login endpointi taze SMS ugradyar.
  Future<void> _resendCode() async {
    if (_secondsLeft > 0 || loading) return;
    _safeSetState(() {
      loading = true;
      _hasError = false;
    });
    try {
      var url = Uri.https(Constants.api, '/api/v1/login');
      final resendBody = {"phone": widget.phoneNumber};
      ApiLog.request(tag: 'OTP GAYTADAN IBER', method: 'POST', url: url, body: resendBody);
      final resendResponse = await http.post(url, body: resendBody);
      ApiLog.response(tag: 'OTP GAYTADAN IBER', response: resendResponse);
      if (!mounted) return;
      verifyCode.clear();
      _showMessage(Constants.ru_otp_resent[_dil]);
      _startCountdown();
    } catch (e, st) {
      ApiLog.error(tag: 'OTP GAYTADAN IBER', error: e, stackTrace: st);
      if (!mounted) return;
      _showMessage(Constants.ru_failed_to_load[_dil]);
    } finally {
      _safeSetState(() => loading = false);
    }
  }

  void _submit() {
    if (loading || !_isComplete) return;
    FocusScope.of(context).unfocus();
    _safeSetState(() => loading = true);
    sending(verifyCode.text);
  }

  @override
  Widget build(BuildContext context) {
    final int dil = Provider.of<Which_page>(context).dil;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          _buildBackground(),
          _buildDecorativeCircles(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _buildLogo(),
                    const SizedBox(height: 36),
                    Text(
                      Constants.ru_otp_title[dil],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontFamily: 'GilroyBold',
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Constants.ru_otp_subtitle[dil],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'GilroyMedium',
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildPhoneChip(),
                    const SizedBox(height: 32),
                    _buildOtpInput(),
                    if (_hasError) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_rounded, size: 16, color: Color(0xFFE53935)),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              Constants.ru_otp_wrong[dil],
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'GilroyMedium',
                                color: Color(0xFFE53935),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 28),
                    _buildPrimaryButton(
                      text: Constants.ru_otp_confirm[dil],
                      isLoading: loading,
                      isEnabled: _isComplete,
                      onTap: _submit,
                    ),
                    const SizedBox(height: 24),
                    _buildResendRow(dil),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          _buildBackButton(),
        ],
      ),
    );
  }

  // ─────────────────────── Bolekler ───────────────────────

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Image.asset(logoImage, fit: BoxFit.contain),
    );
  }

  /// Kodyn iberilen belgisi
  Widget _buildPhoneChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        '+993 ${widget.phoneNumber}',
        style: const TextStyle(
          fontSize: 15,
          fontFamily: 'GilroySemiBold',
          color: AppColors.primary,
        ),
      ),
    );
  }

  /// Bir gorunmez TextField + gorkezyan gutujyklar.
  Widget _buildOtpInput() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(otpLength, (index) => _buildOtpBox(index)),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: verifyCode,
              focusNode: _focusNode,
              autofocus: true,
              keyboardType: TextInputType.number,
              // iOS/Android SMS kody awtomatiki doldurmak ucin.
              autofillHints: const [AutofillHints.oneTimeCode],
              maxLength: otpLength,
              showCursor: false,
              style: const TextStyle(color: Colors.transparent),
              cursorColor: Colors.transparent,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(otpLength),
              ],
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                _safeSetState(() {
                  if (_hasError) _hasError = false;
                });
                if (value.length == otpLength) _submit();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpBox(int index) {
    final bool isFilled = index < _code.length;
    final bool isActive = index == _code.length && _focusNode.hasFocus;

    final Color borderColor = _hasError
        ? const Color(0xFFE53935)
        : isActive
            ? AppColors.primary
            : isFilled
                ? AppColors.primary.withOpacity(0.45)
                : const Color(0xFFEEEEEE);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 54,
      height: 62,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: (_hasError ? const Color(0xFFE53935) : AppColors.primary).withOpacity(isActive || isFilled ? 0.12 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        isFilled ? _code[index] : '',
        style: const TextStyle(
          fontSize: 24,
          fontFamily: 'GilroyBold',
          color: Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _buildResendRow(int dil) {
    final bool canResend = _secondsLeft == 0;
    return Column(
      children: [
        Text(
          Constants.ru_otp_no_code[dil],
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'GilroyMedium',
            color: Color(0xFF9E9E9E),
          ),
        ),
        const SizedBox(height: 6),
        canResend
            ? GestureDetector(
                onTap: _resendCode,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    Constants.ru_otp_resend[dil],
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'GilroyBold',
                      color: AppColors.primary,
                    ),
                  ),
                ),
              )
            : Text(
                '${Constants.ru_otp_resend_in[dil]} 00:${_secondsLeft.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'GilroySemiBold',
                  color: Color(0xFFBDBDBD),
                ),
              ),
      ],
    );
  }

  /// Login sahypasyndaky yaly gradient dugme.
  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onTap,
    required bool isLoading,
    required bool isEnabled,
  }) {
    final bool active = isEnabled && !isLoading;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: active || isLoading ? 1 : 0.45,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFF6BA31A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(active ? 0.35 : 0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'GilroyBold',
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF0F7E4), Colors.white, Colors.white],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
    );
  }

  Widget _buildDecorativeCircles() {
    return Stack(
      children: [
        Positioned(
          top: -60,
          right: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.06),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 30,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.04),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: -50,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.05),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 8,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF2D2D2D),
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
