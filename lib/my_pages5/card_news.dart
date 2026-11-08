import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:bamboo/my_pages5/news_option.dart';
import 'package:bamboo/values/models.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/colors.dart';

class CardNews extends StatefulWidget {
  final List<new_post> product;
  final int index;
  CardNews(this.product, this.index, {super.key});

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
      child: SizedBox(
          height: 120,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 2,
                  decoration: const BoxDecoration(
                    color: AppColors.light_silver,
                  ),
                  child: const Divider(
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
                            const Icon(IconlyLight.image, color: Colors.grey),
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
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
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
                                    IconlyLight.time_circle,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 10),
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
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
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
