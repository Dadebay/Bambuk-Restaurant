import 'package:flutter/material.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:bamboo/my_pages4/verify.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/colors.dart';
import 'package:http/http.dart' as http;
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;

import '../DB/db.dart';
import '../main.dart';
import '../providers/bottom_prov.dart';

class UserInf extends StatefulWidget {
  const UserInf({super.key});

  @override
  _UserInfState createState() => _UserInfState();
}

class _UserInfState extends State<UserInf> {
  TextEditingController regName1 = TextEditingController(text: Constants.name1);
  TextEditingController regMoney = TextEditingController(text: '${Constants.bonusMoney} TMT');
  TextEditingController regSurname1 = TextEditingController(text: Constants.name2);
  TextEditingController regEmail1 = TextEditingController(text: Constants.email);
  TextEditingController regPhone1 = TextEditingController(text: Constants.phone);
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 35, right: 35),
            child: Center(
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              color: AppColors.silver,
                              borderRadius: BorderRadius.circular(75),
                            ),
                            child: Image.asset(
                              'assets/images/profil.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: regName1,
                          style: const TextStyle(color: AppColors.primary),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                                color: AppColors.primary,
                              ),
                              labelStyle: const TextStyle(color: AppColors.primary),
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                              hintStyle: const TextStyle(
                                inherit: true,
                                fontSize: 14.0,
                                fontFamily: "WorkSansLight",
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                              ),
                              hintText: Constants.ru_name[prov.dil]),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: regSurname1,
                          style: const TextStyle(color: AppColors.primary),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                                color: AppColors.primary,
                              ),
                              labelStyle: const TextStyle(color: AppColors.primary),
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                              hintStyle: const TextStyle(
                                inherit: true,
                                fontSize: 14.0,
                                fontFamily: "WorkSansLight",
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                              ),
                              hintText: Constants.ru_surname[prov.dil]),
                        ),
                        Visibility(
                          visible: false,
                          child: TextFormField(
                            controller: regEmail1,
                            style: const TextStyle(color: AppColors.primary),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                ),
                                labelStyle: TextStyle(color: AppColors.primary),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                                hintStyle: TextStyle(
                                  inherit: true,
                                  fontSize: 14.0,
                                  fontFamily: "WorkSansLight",
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                ),
                                hintText: 'Email'),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: regPhone1,
                          style: const TextStyle(color: AppColors.primary),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              // ignore: prefer_const_constructors
                              prefixIcon: Icon(
                                Icons.phone,
                                color: AppColors.primary,
                              ),
                              labelStyle: TextStyle(color: AppColors.primary),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                              hintStyle: TextStyle(
                                inherit: true,
                                fontSize: 14.0,
                                fontFamily: "WorkSansLight",
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                              ),
                              hintText: '** ** ** **'),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: regMoney,
                          readOnly: true,
                          style: const TextStyle(color: AppColors.primary),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              // ignore: prefer_const_constructors

                              labelStyle: TextStyle(color: AppColors.primary),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                              hintStyle: TextStyle(
                                inherit: true,
                                fontSize: 14.0,
                                fontFamily: "WorkSansLight",
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                              ),
                              hintText: '** ** ** **'),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (Provider.of<BottomProv>(context).reg)
                                ? GestureDetector(
                                    onTap: (() async {
                                      Map<String, String> header = {'Authorization': 'Bearer ${Constants.token}'};
                                      var url = Uri.https(Constants.api, '/api/v1/users/me/destroy');
                                      var response = await http.delete(url, headers: header);
                                      if (response.statusCode == 204) {
                                        DatabaseHelper.deleteUserAll();
                                        setState(() {
                                          Constants.phone = '';
                                          Constants.token = '';
                                          Constants.name = '';
                                          Constants.name1 = '';
                                          Constants.name2 = '';
                                          Constants.email = '';
                                          regName1 = TextEditingController(text: Constants.name1);
                                          regSurname1 = TextEditingController(text: Constants.name2);
                                          regEmail1 = TextEditingController(text: Constants.email);
                                          regPhone1 = TextEditingController(text: Constants.phone);
                                        });
                                        Provider.of<BottomProv>(context, listen: false).set_reg(false);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text("Siz ulgamdan çykdyňyz!"),
                                        ));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text("Ýalňyşlyk ýüze çykdy täzeden synanyşyň!"),
                                        ));
                                      }
                                    }),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 60,
                                        padding: const EdgeInsets.only(left: 20, right: 20),
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          Constants.ru_delete[Provider.of<Which_page>(context).dil],
                                          style: const TextStyle(fontFamily: 'Semi', color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
        ],
      ),
    );
  }
}
