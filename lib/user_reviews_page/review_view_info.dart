import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ReviewViewInfo extends StatelessWidget {
  const ReviewViewInfo({super.key, required this.image, required this.date, required this.title});
  final String image;
  final String date;
  final String title;
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                IconlyLight.arrow_left_circle,
                color: Colors.black,
              )),
          title: Text(
            Constants.review_user[prov.dil],
            style: const TextStyle(color: Colors.black, fontFamily: "Semi", fontSize: 20),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                height: Get.size.height / 2,
                width: Get.size.width,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      image,
                      fit: BoxFit.fill,
                    ))),
            const SizedBox(height: 10),
            Text(
              date,
              style: const TextStyle(color: Colors.black, fontFamily: "Semi", fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontFamily: "Semi", fontSize: 20),
            ),
          ]),
        ));
  }
}
