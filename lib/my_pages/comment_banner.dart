import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../photo_view.dart';
import '../providers/page1provider.dart';
import '../values/colors.dart';
import '../values/models.dart';
import 'package:bamboo/values/constants.dart' as Constants;

// ignore: must_be_immutable
class CommentBannerPage extends StatelessWidget {
  CommentBanner commentBanner;
  CommentBannerPage({super.key, required this.commentBanner});

  @override
  Widget build(BuildContext context) {
    var provDil = Provider.of<Which_page>(context).dil;
    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: AppColors.light_silver),
            child: Stack(
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
        color: Colors.white,
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 300,
                  padding: const EdgeInsets.only(bottom: 15),
                  decoration: const BoxDecoration(
                    color: AppColors.light_silver,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(),
                    child: Image.network(
                      provDil != 0
                          ? commentBanner.imageTm
                          : commentBanner.imageRu,
                      height: 230,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    Constants.op_image = provDil != 0
                        ? commentBanner.imageTm
                        : commentBanner.imageRu;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PhotView()));
                  }),
                  child: Container(
                    height: 300,
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(bottom: 20, right: 20),
                    child: const Icon(
                      Icons.zoom_in,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 15),
              child: Text(
                (provDil != 0) ? commentBanner.nameTm : commentBanner.nameRu,
                maxLines: 3,
                // ignore: prefer_const_constructors
                style: TextStyle(
                    color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 15),
              child: Text(
                (provDil != 0)
                    ? commentBanner.contentTm
                    : commentBanner.contentRu,
                maxLines: 100,
                // ignore: prefer_const_constructors
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
