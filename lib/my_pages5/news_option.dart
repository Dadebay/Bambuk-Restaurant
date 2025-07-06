import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/colors.dart';
import '../values/models.dart';

class NewsOption extends StatefulWidget {
  List<new_post> product;
  int index;
  NewsOption(this.product, this.index);

  @override
  _NewsOptionState createState() => _NewsOptionState();
}

class _NewsOptionState extends State<NewsOption> {
  @override
  Widget build(BuildContext context) {
    widget.product[widget.index].body_tm =
        widget.product[widget.index].body_tm.replaceAll('<h2>', '');
    widget.product[widget.index].body_tm =
        widget.product[widget.index].body_tm.replaceAll('<h1>', '');
    widget.product[widget.index].body_tm =
        widget.product[widget.index].body_tm.replaceAll('<h3>', '');
    widget.product[widget.index].body_tm =
        widget.product[widget.index].body_tm.replaceAll('<h4>', '');
    widget.product[widget.index].body_tm =
        widget.product[widget.index].body_tm.replaceAll('<strong>', '');

    widget.product[widget.index].body_ru =
        widget.product[widget.index].body_ru.replaceAll('<h2>', '');
    widget.product[widget.index].body_ru =
        widget.product[widget.index].body_ru.replaceAll('<h1>', '');
    widget.product[widget.index].body_ru =
        widget.product[widget.index].body_ru.replaceAll('<h3>', '');
    widget.product[widget.index].body_ru =
        widget.product[widget.index].body_ru.replaceAll('<h4>', '');

    widget.product[widget.index].body_ru =
        widget.product[widget.index].body_ru.replaceAll('<strong>', '');

    return Scaffold(
        appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: SafeArea(
            child: Container(
              height: 60,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(color: AppColors.appBar_back),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      (Provider.of<Which_page>(context).dil != 0)
                          ? 'Täzelikler'
                          : 'Новости',
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
          preferredSize: Size.fromHeight(100),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ListView(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    widget.product[widget.index].image,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                (Provider.of<Which_page>(context).dil != 0)
                    ? widget.product[widget.index].name_tm
                    : widget.product[widget.index].name_ru,
                style: const TextStyle(
                  fontFamily: 'Semi',
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    child: const Icon(
                      Icons.watch_later_outlined,
                      size: 15,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 5, right: 10),
                    // ignore: prefer_const_constructors
                    child: Text(
                      (Provider.of<Which_page>(context).dil != 0)
                          ? widget.product[widget.index].date
                          : widget.product[widget.index].date,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Html(
                data:
                    """${(Provider.of<Which_page>(context).dil != 0) ? widget.product[widget.index].body_tm : widget.product[widget.index].body_ru}""",
              ),
            ],
          ),
        ));
  }
}
