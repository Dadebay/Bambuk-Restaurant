// ignore_for_file: prefer_const_constructors

import 'package:bamboo/my_pages4/verify.dart';
import 'package:bamboo/providers/bottom_prov.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:flutter/material.dart';
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
    controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
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

  bool sign = Constants.which_sign;
  TextEditingController loginName = TextEditingController(text: Constants.phone);
  TextEditingController regName = TextEditingController();
  TextEditingController regSurname = TextEditingController();
  TextEditingController regEmail = TextEditingController();
  TextEditingController regPhone = TextEditingController();
  TextEditingController regName1 = TextEditingController(text: Constants.name1);
  TextEditingController regSurname1 = TextEditingController(text: Constants.name2);
  TextEditingController regEmail1 = TextEditingController(text: Constants.email);
  TextEditingController regPhone1 = TextEditingController(text: Constants.phone);
  TextEditingController regMoney = TextEditingController(text: '${Constants.bonusMoney} TMT');
  bool loading = false;

  Future sending(String name) async {
    //if (name=="")name=Constants.pname;
    print(name);
    print("------------------------------------------------");
    var headers = {
      "phone": name,
    };

    var url = Uri.https(Constants.api, '/api/v1/login');
    var response = await http.post(url, body: headers);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      print(headers);
      // DatabaseHelper.Constants2.phone = name;
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
    var response = await http.delete(Uri.https(Constants.api, '/api/v1/users/me/destroy'), headers: header);
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
  Future reg_sending(String name, String surname, String email, String phone) async {
    if ((name.isNotEmpty) && (email.isNotEmpty) && (phone.length > 7)) {
      if (email.contains('@')) {
        var headers = {
          "name": name,
          "surname": surname,
          "email": email,
          "phone": phone,
        };
        var url = Uri.https(Constants.api, '/api/v1/register');
        Constants.phone = phone;
        var response = await http.post(url, body: headers);
        print("------------------------------------------------");

        print(response.statusCode);
        print(response.body);
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
          content: Text("Mailiňizi dogry giriziň"),
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
      return Scaffold(
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 35, right: 35),
              child: Center(
                child: ListView(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Container(
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(right: 5),
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
                            style: TextStyle(color: AppColors.primary),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                ),
                                labelStyle: TextStyle(color: AppColors.primary),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: AppColors.primary)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                                hintStyle: TextStyle(
                                  inherit: true,
                                  fontSize: 14.0,
                                  fontFamily: "WorkSansLight",
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                ),
                                labelText: Constants.ru_name[prov.dil]),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: regSurname1,
                            style: TextStyle(color: AppColors.primary),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                ),
                                labelStyle: TextStyle(color: AppColors.primary),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: AppColors.primary)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                                hintStyle: TextStyle(
                                  inherit: true,
                                  fontSize: 14.0,
                                  fontFamily: "WorkSansLight",
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                ),
                                labelText: Constants.ru_surname[prov.dil]),
                          ),
                          Visibility(
                            visible: false,
                            child: TextFormField(
                              controller: regEmail1,
                              style: TextStyle(color: AppColors.primary),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: AppColors.primary,
                                  ),
                                  labelStyle: TextStyle(color: AppColors.primary),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: AppColors.primary)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                                  hintStyle: TextStyle(
                                    inherit: true,
                                    fontSize: 14.0,
                                    fontFamily: "WorkSansLight",
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                  ),
                                  labelText: 'Email'),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: regPhone1,
                            style: TextStyle(color: AppColors.primary),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: AppColors.primary,
                                ),
                                labelStyle: TextStyle(color: AppColors.primary),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: AppColors.primary)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                                hintStyle: TextStyle(
                                  inherit: true,
                                  fontSize: 14.0,
                                  fontFamily: "WorkSansLight",
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                ),
                                labelText: '** ** ** **'),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: regMoney,
                            readOnly: true,
                            style: TextStyle(color: AppColors.primary),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
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
                                        // Await the http get response, then decode the json-formatted response.
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

                                          // ignore: prefer_const_constructors, use_build_context_synchronously
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: const Text("Siz ulgamdan çykdyňyz!"),
                                          ));
                                        } else {
                                          // ignore: prefer_const_constructors, use_build_context_synchronously
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: const Text("Ýalňyşlyk ýüze çykdy täzeden synanyşyň!"),
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
                                            style: TextStyle(fontFamily: 'Semi', color: Colors.white),
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
                      color: Color.fromARGB(0, 255, 255, 255),
                      child: Icon(
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
    } else {
      if (!sign) {
        return loginPage(prov, context);
      } else {
        return registrationPage(context, prov);
      }
    }
  }

  Scaffold loginPage(Which_page prov, BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 35, right: 35),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    logoImage,
                    height: 180,
                    width: 130,
                  ),
                  TextField(
                    controller: loginName,
                    style: TextStyle(color: AppColors.primary),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 2.5),
                        width: 80,
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.phone,
                              color: AppColors.primary,
                            ),
                            Text(
                              '+993',
                              style: TextStyle(color: AppColors.primary, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      labelStyle: TextStyle(color: AppColors.primary, fontSize: 16),
                      labelText: '** ** ** **',
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: AppColors.primary)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                      hintStyle: TextStyle(
                        inherit: true,
                        fontSize: 14.0,
                        fontFamily: "WorkSansLight",
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!loading) {
                            sending(loginName.text);
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
                          child: (!loading)
                              ? Text(
                                  Constants.ru_login[prov.dil],
                                  style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'Semi'),
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Constants.ru_did_login[prov.dil],
                        style: TextStyle(
                          color: AppColors.silver,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            sign = true;
                          });
                        }),
                        child: Text(
                          Constants.ru_sign[prov.dil],
                          style: TextStyle(color: AppColors.primary, fontSize: 10, fontFamily: 'Semi'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
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
                  color: Color.fromARGB(0, 255, 255, 255),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Scaffold registrationPage(BuildContext context, Which_page prov) {
    return Scaffold(
      body: Stack(
        children: [
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
                    color: Color.fromARGB(0, 255, 255, 255),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 35, right: 35),
            child: ListView(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Image.asset(
                  logoImage,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: regName,
                  style: TextStyle(color: AppColors.primary),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                      labelStyle: TextStyle(color: AppColors.primary),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: AppColors.primary)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                      hintStyle: TextStyle(
                        inherit: true,
                        fontSize: 14.0,
                        fontFamily: "WorkSansLight",
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                      ),
                      labelText: Constants.ru_name[prov.dil]),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: regSurname,
                  style: TextStyle(color: AppColors.primary),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                      labelStyle: TextStyle(color: AppColors.primary),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: AppColors.primary)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                      hintStyle: TextStyle(
                        inherit: true,
                        fontSize: 14.0,
                        fontFamily: "WorkSansLight",
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                      ),
                      labelText: Constants.ru_surname[prov.dil]),
                ),
                Visibility(
                  visible: false,
                  child: TextFormField(
                    controller: regEmail,
                    style: TextStyle(color: AppColors.primary),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail,
                          color: AppColors.primary,
                        ),
                        labelStyle: TextStyle(color: AppColors.primary),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: AppColors.primary)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                        hintStyle: TextStyle(
                          inherit: true,
                          fontSize: 14.0,
                          fontFamily: "WorkSansLight",
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                        ),
                        labelText: 'Email'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: regPhone,
                  style: TextStyle(color: AppColors.primary),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 2.5),
                      width: 80,
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.phone,
                            color: AppColors.primary,
                          ),
                          Text(
                            '+993',
                            style: TextStyle(color: AppColors.primary, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    labelStyle: TextStyle(color: AppColors.primary, fontSize: 16),
                    labelText: '** ** ** **',
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: AppColors.primary)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                    hintStyle: TextStyle(
                      inherit: true,
                      fontSize: 14.0,
                      fontFamily: "WorkSansLight",
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                    ),
                  ),
                ),
                // TextFormField(
                //   controller: regPhone,
                //   style: TextStyle(color: AppColors.primary),
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //       // ignore: prefer_const_constructors
                //       prefixIcon: Icon(
                //         Icons.phone,
                //         color: AppColors.primary,
                //       ),
                //       labelStyle: TextStyle(color: AppColors.primary),
                //       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: AppColors.primary)),
                //       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                //       hintStyle: TextStyle(
                //         inherit: true,
                //         fontSize: 14.0,
                //         fontFamily: "WorkSansLight",
                //         color: Color.fromRGBO(0, 0, 0, 0.25),
                //       ),
                //       labelText: 'kerim** ** ** **'),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!loading) {
                          reg_sending(regName.text, regSurname.text, 'test@gmail.como', regPhone.text);
                        } else {}
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
                                Constants.ru_sign[prov.dil],
                                style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'Semi'),
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Constants.ru_did_signin[prov.dil],
                      style: TextStyle(
                        color: AppColors.silver,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          sign = false;
                        });
                      }),
                      child: Text(
                        Constants.ru_login[prov.dil],
                        style: TextStyle(color: AppColors.primary, fontSize: 10, fontFamily: 'Semi'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
