import 'package:bamboo/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:bamboo/providers/bottom_prov.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/colors.dart';
import 'package:http/http.dart' as http;
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../DB/db.dart';

class Verify extends StatefulWidget {
  const Verify({super.key, required this.phoneNumber});
  final String phoneNumber;
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  TextEditingController verifyCode = TextEditingController();
  bool loading = false;
  Future sending(String name) async {
    print(name);
    print(Constants.phone);
    var headers = {
      "phone": widget.phoneNumber,
      "otp": name,
    };
    var url = Uri.https(Constants.api, '/api/v1/login/verify');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(url, body: headers);
    print(response.body);
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
        var responseAmount = await http.get(Uri.https(Constants.api, '/api/v1/users/me/bonus'), headers: header);
        var mamount = json.decode(utf8.decode(responseAmount.bodyBytes));
        Constants.bonusMoney = mamount['amount'];
      } catch (e) {}
      // ignore: prefer_const_constructors, use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Siz ulgamda!"),
      ));

      // ignore: use_build_context_synchronously
      Provider.of<BottomProv>(context, listen: false).set_reg(true);
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
      Provider.of<BottomProv>(context, listen: false).set_ver_true();
    } else {
      Constants.phone = "";
      // ignore: use_build_context_synchronously, prefer_const_constructors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Girizen kodynyz ýalňyş"),
      ));
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: SafeArea(
          child: Container(
            height: 55,
            margin: const EdgeInsets.only(left: 20, top: 10, right: 20),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    margin: const EdgeInsets.only(top: 40, left: 10),
                    color: const Color.fromARGB(0, 255, 255, 255),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(100),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(left: 35, right: 35, bottom: 20),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                logoImage,
                height: 120,
                width: 120,
              ),
              Container(
                height: 70,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                // ignore: prefer_const_constructors
                child: Text(
                  (Provider.of<Which_page>(context).dil != 0) ? 'Telefonyňyza sms arkaly gelen kody ýazyň *' : 'Введите код подтверждения, отправленный на телефон *',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              TextFormField(
                controller: verifyCode,
                style: const TextStyle(color: AppColors.primary),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    // ignore: prefer_const_constructors
                    prefixIcon: Icon(
                      Icons.lock,
                      color: AppColors.primary,
                    ),
                    labelStyle: TextStyle(color: AppColors.primary),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                    // ignore: prefer_const_constructors
                    hintStyle: TextStyle(
                      inherit: true,
                      fontSize: 14.0,
                      fontFamily: "WorkSansLight",
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                    ),
                    hintText: '** ***'),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!loading) {
                        sending(
                          verifyCode.text,
                        );
                      }
                      setState(() {
                        loading = true;
                      });
                    },
                    child: Container(
                      width: 220,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                      // ignore: prefer_const_constructors
                      child: (!loading)
                          ? Text(
                              (Provider.of<Which_page>(context).dil != 0) ? 'Kody giriz' : 'Введите код',
                              style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                            )
                          : LinearProgressIndicator(
                              minHeight: 15,
                              value: animation.value,
                              color: AppColors.light_silver,
                              backgroundColor: AppColors.primary,
                              semanticsLabel: 'Linear progress indicator',
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
