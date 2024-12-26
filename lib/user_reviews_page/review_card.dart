import 'package:bamboo/user_reviews_page/review_view_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.image, required this.date, required this.title});
  final String image;
  final String date;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ReviewViewInfo(
              image: image,
              date: date,
              title: title,
            ));
      },
      child: Container(
        width: Get.size.width,
        padding: const EdgeInsets.all(15),
        // margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      fadeInCurve: Curves.ease,
                      color: Colors.amber,
                      imageUrl: image,
                      useOldImageOnUrlChange: true,
                      imageBuilder: (context, imageProvider) => Container(
                        width: Get.size.width,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Text('noImage'.tr),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: "Monto"),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: "Monto"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
