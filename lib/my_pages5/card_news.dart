import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bamboo/my_pages5/news_option.dart';
import 'package:bamboo/values/models.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/colors.dart';

class CardNews extends StatefulWidget {
  List<new_post> product;
  int index;
  CardNews(this.product, this.index);

  @override
  _CardNewsState createState() => _CardNewsState();
}

class _CardNewsState extends State<CardNews> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NewsOption(widget.product, widget.index)));
      },
      child: Container(
          height: 120,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.light_silver,
                  ),
                  child: Divider(
                    height: 2,
                    color: AppColors.light_silver,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        imageUrl: widget.product[widget.index].image,
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.local_dining),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        height: 80,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              // ignore: prefer_const_constructors
                              child: Text(
                                (Provider.of<Which_page>(context).dil != 0)
                                    ? widget.product[widget.index].name_tm
                                    : widget.product[widget.index].name_ru,
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
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
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              // ignore: prefer_const_constructors
                              child: Text(
                                (Provider.of<Which_page>(context).dil != 0)
                                    ? 'Giňişleýin'
                                    : 'Читать далее',
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
