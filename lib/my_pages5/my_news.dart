import 'dart:convert';

import 'package:bamboo/my_pages5/card_news.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/colors.dart';

class MyNews extends StatefulWidget {
  const MyNews({super.key});

  @override
  _MyNewsState createState() => _MyNewsState();
}

class _MyNewsState extends State<MyNews> {
  List<new_post> product = [];

  Future getTime() async {
    var response3 = await http.get(Uri.https(Constants.api, '/api/v1/posts'));
    print(response3.body);
    print(response3.body);
    print(response3.body);
    var mitem = json.decode(utf8.decode(response3.bodyBytes))['data'];
    product.clear();
    for (int i = 0; i < mitem.length; i++) {
      product.add(new_post(
          id: mitem[i]['id'],
          name_tm: (mitem[i]['title_tm'] != null) ? mitem[i]['title_tm'] : '',
          name_ru: (mitem[i]['title_ru'] != null) ? mitem[i]['title_ru'] : '',
          body_tm: (mitem[i]['body_tm'] != null) ? mitem[i]['body_tm'].toString().replaceAll('<h3>', '') : '',
          body_ru: (mitem[i]['body_ru'] != null) ? mitem[i]['body_ru'] : '',
          date: (mitem[i]['date_start'] != null) ? mitem[i]['date_start'].toString().substring(0, 10) : '',
          view: (mitem[i]['viewed'] != null) ? mitem[i]['viewed'].toString() : '',
          image: (mitem[i]['image'] != null) ? 'http://tikin.com.tm/storage/${mitem[i]['image'].toString()}' : ''));
    }
    setState(() {});
    return 0;
  }

  @override
  void initState() {
    super.initState();
    getTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                      (Provider.of<Which_page>(context).dil != 0) ? 'Täzelikler' : 'Новости',
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
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
                    ),
                  )
                ],
              ),
            ),
          ),
          preferredSize: const Size.fromHeight(100),
        ),
        body: Container(
          child: ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: product.length,
              itemBuilder: (BuildContext context, int index) {
                return CardNews(product, index);
              }),
        ));
  }
}
