// ignore_for_file: prefer_const_constructors

import 'package:bamboo/my_pages4/verify.dart';
import 'package:bamboo/providers/bottom_prov.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/api_logger.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'DB/db.dart';

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  /// +993 prefiksinden sonraky rugsat berilyan sany mukdary.
  static const int phoneDigitCount = 8;

  bool sign = Constants.which_sign;
  TextEditingController loginName =
      TextEditingController(text: Constants.phone);
  TextEditingController regName = TextEditingController();
  TextEditingController regSurname = TextEditingController();
  TextEditingController regEmail = TextEditingController();
  TextEditingController regPhone = TextEditingController();
  TextEditingController regName1 = TextEditingController(text: Constants.name1);
  TextEditingController regSurname1 =
      TextEditingController(text: Constants.name2);
  TextEditingController regEmail1 =
      TextEditingController(text: Constants.email);
  TextEditingController regPhone1 =
      TextEditingController(text: Constants.phone);
  TextEditingController regMoney =
      TextEditingController(text: '${Constants.bonusMoney} TMT');
  bool loading = false;

  /// Telefon belgisi doly (8 san) dalse duydurys gorkezyar.
  bool _isPhoneValid(String phone) => phone.length == phoneDigitCount;

  void _showPhoneWarning() {
    final int dil = Provider.of<Which_page>(context, listen: false).dil;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(Constants.ru_phone_invalid[dil]),
    ));
  }

  Future sending(String name) async {
    var headers = {
      "phone": name,
    };

    var url = Uri.https(Constants.api, '/api/v1/login');
    ApiLog.request(
        tag: 'LOGIN / OTP SORAG', method: 'POST', url: url, body: headers);

    http.Response response;
    try {
      // Wagt cakli: server jogap bermese-de ekran hemise aylanyp durmaly dal.
      response = await http
          .post(url, body: headers)
          .timeout(const Duration(seconds: 25));
    } catch (e, st) {
      ApiLog.error(tag: 'LOGIN / OTP SORAG', error: e, stackTrace: st);
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(Constants.ru_failed_to_load[
            Provider.of<Which_page>(context, listen: false).dil]),
      ));
      return;
    }
    ApiLog.response(tag: 'LOGIN / OTP SORAG', response: response);

    if (!mounted) return;
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Verify(
                    phoneNumber: name,
                  )));
    } else {
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Siz registrasiya boldunyzmy?"),
      ));
    }
  }

  Future delete_accaunt() async {
    Map<String, String> header = {'Authorization': 'Bearer ${Constants.token}'};
    var response = await http.delete(
        Uri.https(Constants.api, '/api/v1/users/me/destroy'),
        headers: header);
    if (response.statusCode == 200) {
      Constants.name = '';
      Constants.token = '';
      Constants.email = '';
      Constants.phone = '';
      DatabaseHelper.deleteUserAll();
      setState(() {
        loginName = TextEditingController();
      });
    } else {}
  }

  String gmail = '';
  String mail = '';
  Future reg_sending(
      String name, String surname, String email, String phone) async {
    if (!_isPhoneValid(phone)) {
      setState(() {
        loading = false;
      });
      _showPhoneWarning();
      return;
    }
    if (name.isNotEmpty) {
      var headers = {
        "name": name,
        "surname": surname,
        "email": email,
        "phone": phone,
      };
      var url = Uri.https(Constants.api, '/api/v1/register');
      Constants.phone = phone;
      ApiLog.request(tag: 'REGISTER', method: 'POST', url: url, body: headers);

      http.Response response;
      try {
        response = await http.post(url, body: headers);
      } catch (e, st) {
        ApiLog.error(tag: 'REGISTER', error: e, stackTrace: st);
        if (!mounted) return;
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(Constants.ru_failed_to_load[
              Provider.of<Which_page>(context, listen: false).dil]),
        ));
        return;
      }
      ApiLog.response(tag: 'REGISTER', response: response);

      if (!mounted) return;
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Verify(
                      phoneNumber: phone,
                    )));
      } else {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Siz hasaba alynan"),
        ));
      }
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Doly dolduryň"),
      ));
    }
  }

  // ============ Shared UI Helpers ============

  /// Modern styled input field with icon
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    Widget? prefixOverride,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        style: TextStyle(
          color: Color(0xFF2D2D2D),
          fontSize: 15,
          fontFamily: 'GilroyMedium',
        ),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: prefixOverride ??
              Container(
                width: 48,
                alignment: Alignment.center,
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
          labelText: label,
          labelStyle: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 14,
            fontFamily: 'GilroyMedium',
          ),
          floatingLabelStyle: TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontFamily: 'GilroySemiBold',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFFEEEEEE), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  /// Phone number input field with +993 prefix
  Widget _buildPhoneField({
    required TextEditingController controller,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: Color(0xFF2D2D2D),
          fontSize: 17,
          fontFamily: 'GilroySemiBold',
          letterSpacing: 1.5,
        ),
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        // Turkmenistan belgileri +993-den son 8 sany bolyar.
        maxLength: phoneDigitCount,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(phoneDigitCount),
        ],
        decoration: InputDecoration(
          // Asakdaky "0/8" hasaplayjyny gizleyaris.
          counterText: '',
          prefixIcon: Container(
            width: 104,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone_rounded, color: AppColors.primary, size: 20),
                SizedBox(width: 6),
                Text(
                  '+993',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 17,
                    fontFamily: 'GilroySemiBold',
                  ),
                ),
                SizedBox(width: 12),
                // Prefiks bilen belgini ayryan inceden cyzyk
                Container(
                  width: 1,
                  height: 24,
                  color: Color(0xFFE8E8E8),
                ),
              ],
            ),
          ),
          // Maska yerinde dursun diyip labelText derek hintText ulanylyar.
          hintText: label,
          hintStyle: TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 17,
            fontFamily: 'GilroyMedium',
            letterSpacing: 1.5,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFFEEEEEE), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  /// Primary action button (gradient green)
  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onTap,
    required bool isLoading,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [
              AppColors.primary,
              Color(0xFF6BA31A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'GilroyBold',
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }

  /// Page background with subtle gradient
  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Color(0xFFF0F7E4),
            Colors.white,
            Colors.white,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
    );
  }

  /// Decorative circle elements
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
              color: AppColors.primary.withValues(alpha: 0.06),
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
              color: AppColors.primary.withValues(alpha: 0.04),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: -50,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.05),
            ),
          ),
        ),
      ],
    );
  }

  /// Back button
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
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF2D2D2D),
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  // ============ Build Method ============

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);
    if (Provider.of<BottomProv>(context).ver) {
      setState(() {
        regName1 = TextEditingController(text: Constants.name1);
        regSurname1 = TextEditingController(text: Constants.name2);
        regEmail1 = TextEditingController(text: Constants.email);
        regPhone1 = TextEditingController(text: Constants.phone);
      });
      return _buildProfilePage(prov, context);
    } else {
      if (!sign) {
        return _buildLoginPage(prov, context);
      } else {
        return _buildRegistrationPage(context, prov);
      }
    }
  }

  // ============ Profile Page (Logged In) ============

  Widget _buildProfilePage(Which_page prov, BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildBackground(),
          _buildDecorativeCircles(),
          SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 28),
              children: [
                SizedBox(height: 60),
                // Profile avatar
                Center(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.15),
                          AppColors.primary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 24,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/images/profil.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28),
                // Name field
                _buildInputField(
                  controller: regName1,
                  label: Constants.ru_name[prov.dil],
                  icon: Icons.person_outline_rounded,
                ),
                SizedBox(height: 16),
                // Surname field
                _buildInputField(
                  controller: regSurname1,
                  label: Constants.ru_surname[prov.dil],
                  icon: Icons.person_outline_rounded,
                ),
                // Email field (hidden)
                Visibility(
                  visible: false,
                  child: _buildInputField(
                    controller: regEmail1,
                    label: 'Email',
                    icon: Icons.email_outlined,
                  ),
                ),
                SizedBox(height: 16),
                // Phone field
                _buildPhoneField(
                  controller: regPhone1,
                  label: '** ** ** **',
                ),
                SizedBox(height: 16),
                // Bonus field
                _buildInputField(
                  controller: regMoney,
                  label: Constants.ru_bonus[prov.dil],
                  icon: Icons.wallet_rounded,
                  readOnly: true,
                ),
                SizedBox(height: 32),
                // Delete account button
                (Provider.of<BottomProv>(context).reg)
                    ? GestureDetector(
                        onTap: () async {
                          Map<String, String> header = {
                            'Authorization': 'Bearer ${Constants.token}'
                          };
                          var url = Uri.https(
                              Constants.api, '/api/v1/users/me/destroy');
                          var response =
                              await http.delete(url, headers: header);
                          if (response.statusCode == 204) {
                            DatabaseHelper.deleteUserAll();
                            setState(() {
                              Constants.phone = '';
                              Constants.token = '';
                              Constants.name = '';
                              Constants.name1 = '';
                              Constants.name2 = '';
                              Constants.email = '';
                              regName1 =
                                  TextEditingController(text: Constants.name1);
                              regSurname1 =
                                  TextEditingController(text: Constants.name2);
                              regEmail1 =
                                  TextEditingController(text: Constants.email);
                              regPhone1 =
                                  TextEditingController(text: Constants.phone);
                            });
                            Provider.of<BottomProv>(context, listen: false)
                                .set_reg(false);
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Siz ulgamdan çykdyňyz!"),
                            ));
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  "Ýalňyşlyk ýüze çykdy täzeden synanyşyň!"),
                            ));
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.red.shade300, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              Constants.ru_delete[
                                  Provider.of<Which_page>(context).dil],
                              style: TextStyle(
                                fontFamily: 'GilroySemiBold',
                                color: Colors.red.shade400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 24),
              ],
            ),
          ),
          _buildBackButton(),
        ],
      ),
    );
  }

  // ============ Login Page ============

  Widget _buildLoginPage(Which_page prov, BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildBackground(),
          _buildDecorativeCircles(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    // Logo with decorative ring
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            blurRadius: 30,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(12),
                      child: Image.asset(
                        logoImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 36),
                    // Welcome text
                    Text(
                      Constants.ru_login[prov.dil],
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'GilroyBold',
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      Constants.ru_telefon[prov.dil],
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'GilroyMedium',
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    SizedBox(height: 36),
                    // Phone input
                    _buildPhoneField(
                      controller: loginName,
                      label: '** ** ** **',
                    ),
                    SizedBox(height: 28),
                    // Login button
                    _buildPrimaryButton(
                      text: Constants.ru_login[prov.dil],
                      isLoading: loading,
                      onTap: () {
                        if (loading) return;
                        if (!_isPhoneValid(loginName.text)) {
                          _showPhoneWarning();
                          return;
                        }
                        // Ilki loading, sonra isleg: `sending` icinde ilkinji
                        // `await`-e cenli sinhron isleyar - tersine bolsa iki
                        // gezek basylanda iki isleg gidip biler.
                        setState(() {
                          loading = true;
                        });
                        sending(loginName.text);
                      },
                    ),
                    SizedBox(height: 28),
                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Color(0xFFEEEEEE),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '•',
                            style: TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Color(0xFFEEEEEE),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Constants.ru_did_login[prov.dil],
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 13,
                            fontFamily: 'GilroyMedium',
                          ),
                        ),
                        SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sign = true;
                            });
                          },
                          child: Text(
                            Constants.ru_sign[prov.dil],
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontFamily: 'GilroyBold',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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

  // ============ Registration Page ============

  Widget _buildRegistrationPage(BuildContext context, Which_page prov) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildBackground(),
          _buildDecorativeCircles(),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          blurRadius: 24,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    child: Image.asset(
                      logoImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 24),
                  // Title
                  Text(
                    Constants.ru_sign[prov.dil],
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'GilroyBold',
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    Constants.ru_telefon[prov.dil],
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'GilroyMedium',
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  SizedBox(height: 32),
                  // Name field
                  _buildInputField(
                    controller: regName,
                    label: Constants.ru_name[prov.dil],
                    icon: Icons.person_outline_rounded,
                  ),
                  SizedBox(height: 16),
                  // Surname field
                  _buildInputField(
                    controller: regSurname,
                    label: Constants.ru_surname[prov.dil],
                    icon: Icons.person_outline_rounded,
                  ),
                  // Email field (hidden)
                  Visibility(
                    visible: false,
                    child: _buildInputField(
                      controller: regEmail,
                      label: 'Email',
                      icon: Icons.email_outlined,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Phone field
                  _buildPhoneField(
                    controller: regPhone,
                    label: '** ** ** **',
                  ),
                  SizedBox(height: 28),
                  // Register button
                  _buildPrimaryButton(
                    text: Constants.ru_sign[prov.dil],
                    isLoading: loading,
                    onTap: () {
                      if (loading) return;
                      if (!_isPhoneValid(regPhone.text)) {
                        _showPhoneWarning();
                        return;
                      }
                      reg_sending(regName.text, regSurname.text,
                          'test@gmail.como', regPhone.text);
                      setState(() {
                        loading = true;
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Color(0xFFEEEEEE),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '•',
                          style: TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Color(0xFFEEEEEE),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Constants.ru_did_signin[prov.dil],
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 13,
                          fontFamily: 'GilroyMedium',
                        ),
                      ),
                      SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            sign = false;
                          });
                        },
                        child: Text(
                          Constants.ru_login[prov.dil],
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontFamily: 'GilroyBold',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildBackButton(),
        ],
      ),
    );
  }
}
