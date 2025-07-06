import 'package:bamboo/my_pages/comment_banner.dart';
import 'package:bamboo/values/models.dart';
import 'package:banner_image/banner_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bamboo/values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';

final list = [
  "assets/images/cafebar.png",
  "assets/images/cafebar.png",
  "assets/images/cafebar.png",
  "assets/images/cafebar.png",
];

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  @override
  Widget build(BuildContext context) {
    var provDil = Provider.of<Which_page>(context).dil;
    return BannerImage(
      aspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height) / 0.25,
      itemLength: (Constants.banner.isNotEmpty) ? Constants.banner.length : 2,
      selectedIndicatorColor: AppColors.appBar_back,
      borderRadius: BorderRadius.circular(8),
      autoPlay: true,
      onTap: (int index) {
        //
      },
      children: List.generate(
        (Constants.banner.isNotEmpty) ? Constants.banner.length : 2,
        (index) => CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: (Constants.banner.isNotEmpty)
              ? provDil == 1
                  ? Constants.banner[index].image
                  : provDil == 0
                      ? Constants.banner[index].imageRu
                      : Constants.banner[index].imageEn
              : 'https//images.logo',
          errorWidget: (context, url, error) => const Icon(Icons.local_dining),
        ),
      ),
    );
  }
}

class BannerScreen2 extends StatefulWidget {
  const BannerScreen2({super.key});

  @override
  State<BannerScreen2> createState() => _BannerScreen2State();
}

class _BannerScreen2State extends State<BannerScreen2> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BannerImage(
            aspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height) / 0.25,

            itemLength: (Constants.commentBanner.isNotEmpty) ? Constants.commentBanner.length : 2,
            // ignore: sort_child_properties_last
            children: List.generate(
              (Constants.commentBanner.isNotEmpty) ? Constants.commentBanner.length : 2,
              (index) => CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: (Constants.commentBanner.isNotEmpty)
                    ? Provider.of<Which_page>(context).dil != 0
                        ? Constants.commentBanner[index].imageTm
                        : Constants.commentBanner[index].imageRu
                    : 'https//images.logo',
                errorWidget: (context, url, error) => const Icon(Icons.local_dining),
              ),
            ),
            selectedIndicatorColor: AppColors.appBar_back,
            borderRadius: BorderRadius.circular(8),
            autoPlay: true,
            onTap: (int index) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommentBannerPage(
                            commentBanner: Constants.commentBanner[index],
                          )));
              //
            },
          ),
        ],
      ),
    );
  }
}

class HorizontalBannerScreen extends StatefulWidget {
  const HorizontalBannerScreen({super.key});

  @override
  State<HorizontalBannerScreen> createState() => _HorizontalBannerScreenState();
}

class _HorizontalBannerScreenState extends State<HorizontalBannerScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BannerImage(
            padding: const EdgeInsets.only(),
            itemLength: list.length,
            // ignore: sort_child_properties_last
            children: List.generate(
              list.length,
              (index) => Image.asset(
                list[index],
                fit: BoxFit.cover,
              ),
            ),
            selectedIndicatorColor: Colors.red,
            autoPlay: true,
            scrollDirection: Axis.vertical,
          ),
          const SizedBox(height: 15),
          BannerImage(
            itemLength: list.length,
            // ignore: sort_child_properties_last
            children: List.generate(
              list.length,
              (index) => Image.asset(
                list[index],
                fit: BoxFit.cover,
              ),
            ),
            borderRadius: BorderRadius.circular(8),
            selectedIndicatorColor: Colors.blue,
            indicatorColor: Colors.green.shade100,
            scrollDirection: Axis.vertical,
          ),
          const SizedBox(height: 15),
          BannerImage(
            aspectRatio: 2,
            itemLength: list.length,
            borderRadius: BorderRadius.circular(8),
            // ignore: sort_child_properties_last
            children: List.generate(
              list.length,
              (index) => Image.asset(
                list[index],
                fit: BoxFit.cover,
              ),
            ),
            selectedIndicatorColor: Colors.red,
            withOutIndicator: true,
            scrollDirection: Axis.vertical,
          ),
          const SizedBox(height: 15),
          BannerImage(
            aspectRatio: 20 / 10,
            itemLength: list.length,
            borderRadius: BorderRadius.circular(8),
            // ignore: sort_child_properties_last
            children: List.generate(
              list.length,
              (index) => Image.asset(
                list[index],
                fit: BoxFit.cover,
              ),
            ),
            selectedIndicatorColor: Colors.red,
            scrollDirection: Axis.vertical,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: [
            BannerImage(
              aspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height),
              padding: const EdgeInsets.only(),
              itemLength: list.length,
              // ignore: sort_child_properties_last
              children: List.generate(
                list.length,
                (index) => Image.asset(
                  list[index],
                  fit: BoxFit.cover,
                ),
              ),
              selectedIndicatorColor: Colors.red,
              autoPlay: false,
              withOutIndicator: true,
              fit: BoxFit.scaleDown,
            ),
          ],
        ),
      ),
    );
  }
}
