import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/colors.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController mess = TextEditingController();
  List<String> messageBody = [];
  int k = 0;

  Future getTime() async {
    Map<String, String> header = {'Authorization': 'Bearer ${Constants.token}'};
    var response3 = await http.get(Uri.https(Constants.api, '/api/v1/users/me/comments/'), headers: header);
    var mitem = json.decode(utf8.decode(response3.bodyBytes))['data'];
    messageBody.clear();
    for (int i = 0; i < mitem.length; i++) {
      messageBody.add(mitem[i]['body']);
    }
    setState(() {
      k = 1;
    });
    return 0;
  }

  @override
  void initState() {
    super.initState();
    getTime();
  }

  Future<void> sending(String message, BuildContext context) async {
    //if (name=="")name=Constants.pname;
    try {
      if (message.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Maglumaty doly dolduryň?"),
        ));
      } else {
        var url = Uri.https(Constants.api, '/api/v1/comments');
        var token = Constants.token;
        Map<String, String> data = {
          "body": message,
        };
        Map<String, String> headers = {'Authorization': 'Bearer $token'};
        var req = http.MultipartRequest('POST', url)
          ..fields.addAll(data)
          ..headers.addAll(headers);
        var res = await req.send();
        if (res.statusCode == 201) {}
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBar_back,
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: AppColors.appBar_back),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    Constants.ru_ttt[Provider.of<Which_page>(context).dil],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
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
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.only(left: 5, right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.light_silver,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/back.svg',
                          color: Colors.black,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(100),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                physics: const BouncingScrollPhysics(),
                itemCount: messageBody.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: AppColors.primary,
                          ),
                          child: Text(
                            messageBody[index],
                            maxLines: 30,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.only(left: 15, right: 15),
              margin: const EdgeInsets.only(bottom: 70),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: mess,
                      style: const TextStyle(color: AppColors.primary),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: AppColors.primary),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: AppColors.primary)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                        hintStyle: const TextStyle(
                          inherit: true,
                          fontSize: 14.0,
                          fontFamily: "WorkSansLight",
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sending(mess.text, context);
                      if (mess.text.isNotEmpty) {
                        setState(() {
                          messageBody.add(mess.text);
                          mess.clear();
                        });
                      }
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), color: AppColors.primary),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
