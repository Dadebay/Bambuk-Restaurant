import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bamboo/values/models.dart';
import 'package:flutter_html/flutter_html.dart';
import '../providers/page1provider.dart';
import '../values/colors.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  void initState() {
    super.initState();
    getTime();
  }

  List<help> help_content = [];

  Future getTime() async {
    var response3 = await http.get(Uri.https(Constants.api, '/api/v1/pages'));
    var mitem = json.decode(utf8.decode(response3.bodyBytes))['data'];
    for (int i = 0; i < mitem.length; i++) {
      help_content.add(help(
        id: mitem[i]['id'],
        name_tm: mitem[i]['name_tm'] ?? '',
        name_ru: mitem[i]['name_ru'] ?? '',
        name_en: mitem[i]['name_en'] ?? '',
        body_tm: mitem[i]['pages'] == null ? '' : mitem[i]['pages'][0]['body_tm'] ?? '',
        body_ru: mitem[i]['pages'] == null ? '' : mitem[i]['pages'][0]['body_ru'] ?? '',
        body_en: mitem[i]['pages'] == null ? '' : mitem[i]['pages'][0]['body_en'] ?? '',
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconlyLight.arrow_left_circle, color: Colors.black),
        ),
        title: Text(
          Constants.ru_help[Provider.of<Which_page>(context).dil],
          style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Semi'),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
        child: ListView.builder(
            itemCount: help_content.length,
            itemBuilder: (BuildContext context, int index) {
              return _tile(
                help_content[index].id,
                help_content[index].name_tm,
                help_content[index].name_ru,
                help_content[index].name_en,
                help_content[index].body_tm,
                help_content[index].body_ru,
                help_content[index].body_en,
              );
            }),
      ),
    );
  }
}

class _tile extends StatefulWidget {
  int id;
  String name_tm;
  String name_ru;
  String name_en;
  String body_tm;
  String body_ru;
  String body_en;
  _tile(this.id, this.name_tm, this.name_ru, this.name_en, this.body_tm, this.body_ru, this.body_en);

  @override
  State<_tile> createState() => __tileState();
}

class __tileState extends State<_tile> {
  bool stat = false;
  @override
  Widget build(BuildContext context) {
    widget.body_tm = widget.body_tm.replaceAll('<h2', '<p');
    widget.body_tm = widget.body_tm.replaceAll('<h1', '<p');
    widget.body_tm = widget.body_tm.replaceAll('<h3', '<p');
    widget.body_tm = widget.body_tm.replaceAll('<h4', '<p');
    widget.body_tm = widget.body_tm.replaceAll('<h5', '<p');
    widget.body_tm = widget.body_tm.replaceAll('<strong>', '');

    widget.body_ru = widget.body_ru.replaceAll('<h2 style="text-align: center;">', '');
    widget.body_ru = widget.body_ru.replaceAll('<h2>', '');
    widget.body_ru = widget.body_ru.replaceAll('<h1>', '');
    widget.body_ru = widget.body_ru.replaceAll('<h3>', '');
    widget.body_ru = widget.body_ru.replaceAll('<h4>', '');
    widget.body_ru = widget.body_ru.replaceAll('<h5', '<p');
    widget.body_ru = widget.body_ru.replaceAll('<strong>', '');

    widget.body_en = widget.body_en.replaceAll('<h2 style="text-align: center;">', '');
    widget.body_en = widget.body_en.replaceAll('<h2>', '');
    widget.body_en = widget.body_en.replaceAll('<h1>', '');
    widget.body_en = widget.body_en.replaceAll('<h3>', '');
    widget.body_en = widget.body_en.replaceAll('<h4>', '');
    widget.body_en = widget.body_en.replaceAll('<h5', '<p');
    widget.body_en = widget.body_en.replaceAll('<strong>', '');

    var prov = Provider.of<Which_page>(context);
    return GestureDetector(
        onTap: () {
          setState(() {
            stat = !stat;
          });
        },
        child: Container(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 14),
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      prov.dil == 1
                          ? widget.name_tm
                          : prov.dil == 0
                              ? widget.name_ru
                              : widget.name_en,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.black, fontFamily: "GilroySemiBold", fontSize: 16),
                    ),
                  ),
                  Icon(
                    stat ? IconlyLight.arrow_up_circle : IconlyLight.arrow_down_circle,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
              if (stat) ...[
                const Divider(),
                Html(
                  data: (prov.dil == 1)
                      ? widget.body_tm
                      : prov.dil == 0
                          ? widget.body_ru
                          : widget.body_en,
                  style: {
                    'body': Style(fontFamily: 'GilroyRegular', fontSize: FontSize(14), color: Colors.black87),
                    'p': Style(fontFamily: 'GilroyRegular', fontSize: FontSize(14), color: Colors.black87),
                    'li': Style(fontFamily: 'GilroyRegular', fontSize: FontSize(14), color: Colors.black87),
                  },
                ),
              ],
            ])));
  }
}
